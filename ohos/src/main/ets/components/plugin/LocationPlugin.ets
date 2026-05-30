/*
 * Copyright 2020-2024. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 */

import {
  BinaryMessenger,
  EventChannel,
  EventSink,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  StandardMethodCodec,
  StreamHandler
} from '@ohos/flutter_ohos';
import geoLocationManager from '@ohos.geoLocationManager';
import { hilog } from '@kit.PerformanceAnalysisKit';

import { Channel } from './constants/Channel';
import { CoordinateConvert } from './utils/CoordinateConvert';
import { LocationConvert } from './utils/LocationConvert';
import { Value } from './utils/Value';
import type { AnyMap } from './utils/Value';

const TAG: string = '[LocationPlugin]';

class FusedLocationStreamHandler implements StreamHandler {
  private sink: EventSink | null = null;
  private callback: ((location: geoLocationManager.Location) => void) | null = null;
  private request: geoLocationManager.LocationRequest = LocationConvert.toLocationRequest(null);

  onListen(args: Object | null, events: EventSink): void {
    this.sink = events;
    if (args !== null && args !== undefined) {
      this.request = LocationConvert.toLocationRequest(args);
    }
    this.callback = (location: geoLocationManager.Location): void => {
      this.sink?.success(LocationConvert.toLocationMap(location));
    };
    try {
      geoLocationManager.on('locationChange', this.request, this.callback);
    } catch (e) {
      events.error(Value.errorCode(e as Object), Value.errorMessage(e as Object), null);
    }
  }

  onCancel(args: Object | null): void {
    try {
      if (this.callback) {
        geoLocationManager.off('locationChange', this.callback);
      }
    } catch (e) {
      hilog.warn(0x0000, TAG, `cancel fused stream failed: ${Value.errorMessage(e as Object)}`);
    }
    this.callback = null;
    this.sink = null;
  }

  setRequest(request: geoLocationManager.LocationRequest): void {
    this.request = request;
    if (this.sink) {
      const sink = this.sink;
      this.onCancel(null);
      this.onListen(null, sink);
    }
  }
}

class EmptyStreamHandler implements StreamHandler {
  private name: string;

  constructor(name: string) {
    this.name = name;
  }

  onListen(args: Object | null, events: EventSink): void {
    events.error('NOT_SUPPORTED', `${this.name} is not supported by the HarmonyOS implementation yet.`, null);
    events.endOfStream();
  }

  onCancel(args: Object | null): void {}
}

export default class LocationPlugin implements FlutterPlugin, MethodCallHandler {
  private messenger: BinaryMessenger | null = null;
  private channels: Array<MethodChannel> = [];
  private eventChannels: Array<EventChannel> = [];
  private fusedLocationChannel: MethodChannel | null = null;
  private fusedStreamHandler: FusedLocationStreamHandler | null = null;
  private callbacks: Map<number, (location: geoLocationManager.Location) => void> = new Map();
  private callbackSinks: Map<number, EventSink> = new Map();
  private eventRequests: Set<number> = new Set();
  private requestId: number = 0;
  private mockMode: boolean = false;
  private mockLocation: AnyMap | null = null;
  private logConfig: AnyMap | null = null;
  private locale: string = '';
  private locationEnabledCallback: ((enabled: boolean) => void) | null = null;

  getUniqueClassName(): string {
    return 'LocationPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.messenger = binding.getBinaryMessenger();
    this.fusedLocationChannel = this.registerMethodChannel(Channel.FUSED_LOCATION_METHOD);
    this.registerMethodChannel(Channel.GEOCODER_METHOD);
    this.registerMethodChannel(Channel.LOCATION_UTILS_METHOD);
    this.registerMethodChannel(Channel.HMSLOGGER_METHOD);
    this.registerMethodChannel(Channel.GEOFENCE_METHOD);
    this.registerMethodChannel(Channel.ACTIVITY_IDENTIFICATION_METHOD);
    this.registerMethodChannel(Channel.LOCATION_ENHANCE_METHOD);

    const fusedEvent = new EventChannel(this.messenger, Channel.FUSED_LOCATION_EVENT, StandardMethodCodec.INSTANCE);
    this.fusedStreamHandler = new FusedLocationStreamHandler();
    fusedEvent.setStreamHandler(this.fusedStreamHandler);
    this.eventChannels.push(fusedEvent);
    this.registerEmptyEventChannel(Channel.GEOFENCE_EVENT, 'Geofence event channel');
    this.registerEmptyEventChannel(Channel.ACTIVITY_IDENTIFICATION_EVENT, 'Activity identification event channel');
    this.registerEmptyEventChannel(Channel.ACTIVITY_CONVERSION_EVENT, 'Activity conversion event channel');
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channels.forEach((channel: MethodChannel) => channel.setMethodCallHandler(null));
    this.eventChannels.forEach((channel: EventChannel) => channel.setStreamHandler(null));
    this.callbacks.forEach((callback: (location: geoLocationManager.Location) => void) => {
      try {
        geoLocationManager.off('locationChange', callback);
      } catch (e) {
        hilog.warn(0x0000, TAG, `detach callback cleanup failed: ${Value.errorMessage(e as Object)}`);
      }
    });
    if (this.locationEnabledCallback) {
      try {
        geoLocationManager.off('locationEnabledChange', this.locationEnabledCallback);
      } catch (e) {
        hilog.warn(0x0000, TAG, `detach enabled cleanup failed: ${Value.errorMessage(e as Object)}`);
      }
    }
    this.channels = [];
    this.eventChannels = [];
    this.callbacks.clear();
    this.eventRequests.clear();
    this.fusedLocationChannel = null;
    this.fusedStreamHandler = null;
    this.locationEnabledCallback = null;
    this.messenger = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case 'initFusedLocationService':
        this.initFusedLocationService(result);
        break;
      case 'checkLocationSettings':
        this.checkLocationSettings(result);
        break;
      case 'getLastLocation':
        this.getLastLocation(result);
        break;
      case 'getLastLocationWithAddress':
        this.getLastLocationWithAddress(call, result);
        break;
      case 'getLocationAvailability':
        this.getLocationAvailability(result);
        break;
      case 'setMockMode':
        this.mockMode = call.args === true;
        result.success(null);
        break;
      case 'setMockLocation':
        this.mockLocation = Value.asMap(call.args);
        result.success(null);
        break;
      case 'requestLocationUpdates':
        this.requestLocationUpdates(call, result);
        break;
      case 'requestLocationUpdatesCb':
      case 'requestLocationUpdatesExCb':
        this.requestLocationUpdatesCb(call, result);
        break;
      case 'removeLocationUpdates':
        this.removeRequestLocationUpdates(call, result);
        break;
      case 'removeLocationUpdatesCb':
        this.removeLocationUpdatesCb(call, result);
        break;
      case 'getNavigationContextState':
        result.success({ 'state': 12, 'possibility': 0 });
        break;
      case 'enableBackgroundLocation':
      case 'disableBackgroundLocation':
        result.success(null);
        break;
      case 'setLogConfig':
        this.logConfig = Value.asMap(call.args);
        result.success('success');
        break;
      case 'getLogConfig':
        if (this.logConfig) {
          result.success(this.logConfig);
        } else {
          result.error('Error', 'LogConfig is null', null);
        }
        break;
      case 'initGeocoderService':
        this.initGeocoderService(call, result);
        break;
      case 'getFromLocation':
        this.getFromLocation(call, result);
        break;
      case 'getFromLocationName':
        this.getFromLocationName(call, result);
        break;
      case 'convertCoord':
        this.convertCoord(call, result);
        break;
      case 'startMethodExecutionTimer':
      case 'sendSingleEvent':
      case 'enableLogger':
      case 'disableLogger':
        result.success(null);
        break;
      default:
        this.unsupported(call.method, result);
        break;
    }
  }

  private registerMethodChannel(name: string): MethodChannel | null {
    if (!this.messenger) {
      return null;
    }
    const channel = new MethodChannel(this.messenger, name, StandardMethodCodec.INSTANCE);
    channel.setMethodCallHandler(this);
    this.channels.push(channel);
    return channel;
  }

  private registerEmptyEventChannel(name: string, label: string): void {
    if (!this.messenger) {
      return;
    }
    const channel = new EventChannel(this.messenger, name, StandardMethodCodec.INSTANCE);
    channel.setStreamHandler(new EmptyStreamHandler(label));
    this.eventChannels.push(channel);
  }

  private initFusedLocationService(result: MethodResult): void {
    try {
      this.locationEnabledCallback = (enabled: boolean): void => {
        hilog.info(0x0000, TAG, `location enabled changed: ${enabled}`);
      };
      geoLocationManager.on('locationEnabledChange', this.locationEnabledCallback);
    } catch (e) {
      hilog.warn(0x0000, TAG, `locationEnabledChange listen failed: ${Value.errorMessage(e as Object)}`);
    }
    result.success(null);
  }

  private checkLocationSettings(result: MethodResult): void {
    try {
      result.success(LocationConvert.locationSettingsStates(geoLocationManager.isLocationEnabled()));
    } catch (e) {
      result.error(Value.errorCode(e as Object), Value.errorMessage(e as Object), null);
    }
  }

  private getLastLocation(result: MethodResult): void {
    if (this.mockMode && this.mockLocation) {
      result.success(this.mockLocation);
      return;
    }
    try {
      result.success(LocationConvert.toLocationMap(geoLocationManager.getLastLocation()));
    } catch (e) {
      geoLocationManager.getCurrentLocation(LocationConvert.toCurrentLocationRequest(null))
        .then((location: geoLocationManager.Location) => result.success(LocationConvert.toLocationMap(location)))
        .catch((error: Object) => result.error(Value.errorCode(error), Value.errorMessage(error), null));
    }
  }

  private getLastLocationWithAddress(call: MethodCall, result: MethodResult): void {
    if (this.mockMode && this.mockLocation) {
      result.success(this.toMockHWLocation(this.mockLocation));
      return;
    }
    geoLocationManager.getCurrentLocation(LocationConvert.toCurrentLocationRequest(call.args))
      .then((location: geoLocationManager.Location) => result.success(LocationConvert.toHWLocationMap(location)))
      .catch((error: Object) => result.error(Value.errorCode(error), Value.errorMessage(error), null));
  }

  private getLocationAvailability(result: MethodResult): void {
    try {
      result.success(LocationConvert.locationAvailability(geoLocationManager.isLocationEnabled()));
    } catch (e) {
      result.error(Value.errorCode(e as Object), Value.errorMessage(e as Object), null);
    }
  }

  private requestLocationUpdates(call: MethodCall, result: MethodResult): void {
    const id = ++this.requestId;
    const request = LocationConvert.toLocationRequest(call.args);
    try {
      this.fusedStreamHandler?.setRequest(request);
      this.eventRequests.add(id);
      result.success(id);
    } catch (e) {
      result.error(Value.errorCode(e as Object), Value.errorMessage(e as Object), null);
    }
  }

  private requestLocationUpdatesCb(call: MethodCall, result: MethodResult): void {
    if (!this.messenger) {
      result.error('NO_MESSENGER', 'Flutter messenger is not attached.', null);
      return;
    }
    const id = ++this.requestId;
    const request = LocationConvert.toLocationRequest(call.args);
    hilog.info(0x0000, TAG, `requestLocationUpdatesCb: callbackId=${id}`);
    
    const channelName = `${Channel.FUSED_LOCATION_EVENT}/callback_${id}`;
    const eventChannel = new EventChannel(this.messenger, channelName, StandardMethodCodec.INSTANCE);
    
    const streamHandler: StreamHandler = {
      onListen: (args: Object | null, events: EventSink): void => {
        hilog.info(0x0000, TAG, `EventChannel onListen called for callbackId=${id}`);
        this.callbackSinks.set(id, events);
      },
      onCancel: (args: Object | null): void => {
        hilog.info(0x0000, TAG, `EventChannel onCancel called for callbackId=${id}`);
        this.callbackSinks.delete(id);
      }
    };
    
    eventChannel.setStreamHandler(streamHandler);
    this.eventChannels.push(eventChannel);
    
    const callback = (location: geoLocationManager.Location): void => {
      hilog.info(0x0000, TAG, `Location callback triggered: callbackId=${id}, lat=${location.latitude}, lon=${location.longitude}`);
      const sink = this.callbackSinks.get(id);
      if (sink) {
        const locationResult = LocationConvert.toLocationResultMap(location);
        const locationAvailability = LocationConvert.locationAvailability(true);
        
        sink.success({
          'type': 'onLocationResult',
          'callbackId': id,
          'locationResult': locationResult
        });
        
        sink.success({
          'type': 'onLocationAvailability',
          'callbackId': id,
          'locationAvailability': locationAvailability
        });
        
        hilog.info(0x0000, TAG, `Location data sent via EventChannel for callbackId=${id}`);
      } else {
        hilog.error(0x0000, TAG, `EventSink not found for callbackId=${id}`);
      }
    };
    
    try {
      geoLocationManager.on('locationChange', request, callback);
      this.callbacks.set(id, callback);
      hilog.info(0x0000, TAG, `Location listener registered successfully for callbackId=${id}`);
      result.success(id);
    } catch (e) {
      hilog.error(0x0000, TAG, `Failed to register location listener: ${Value.errorMessage(e as Object)}`);
      result.error(Value.errorCode(e as Object), Value.errorMessage(e as Object), null);
    }
  }

  private removeRequestLocationUpdates(call: MethodCall, result: MethodResult): void {
    const id = typeof call.args === 'number' ? call.args as number : -1;
    if (!this.eventRequests.has(id)) {
      result.error('NON_EXISTING_REQUEST_ID', 'Request ID does not exist.', null);
      return;
    }
    this.eventRequests.delete(id);
    result.success(null);
  }

  private removeLocationUpdatesCb(call: MethodCall, result: MethodResult): void {
    const id = typeof call.args === 'number' ? call.args as number : -1;
    const callback = this.callbacks.get(id);
    if (!callback) {
      result.error('NON_EXISTING_REQUEST_ID', 'Request ID does not exist.', null);
      return;
    }
    try {
      geoLocationManager.off('locationChange', callback);
      this.callbacks.delete(id);
      result.success(null);
    } catch (e) {
      result.error(Value.errorCode(e as Object), Value.errorMessage(e as Object), null);
    }
  }

  private initGeocoderService(call: MethodCall, result: MethodResult): void {
    const args = Value.asMap(call.args);
    const localeMap = Value.asMap(Value.mapValue(args, 'locale'));
    const language = Value.string(localeMap, 'languageCode');
    const country = Value.string(localeMap, 'countryCode');
    this.locale = country.length > 0 ? `${language}-${country}` : language;
    result.success(null);
  }

  private getFromLocation(call: MethodCall, result: MethodResult): void {
    const args = Value.asMap(call.args);
    const requestMap = Value.asMap(Value.mapValue(args, 'getFromLocationRequest'));
    const request: geoLocationManager.ReverseGeoCodeRequest = {
      latitude: Value.number(requestMap, 'latitude'),
      longitude: Value.number(requestMap, 'longitude'),
      maxItems: Value.number(requestMap, 'maxResults', 1)
    };
    if (this.locale.length > 0) {
      request.locale = this.locale;
    }
    geoLocationManager.getAddressesFromLocation(request)
      .then((addresses: Array<geoLocationManager.GeoAddress>) => {
        result.success(addresses.map((item: geoLocationManager.GeoAddress) => LocationConvert.toHWLocationMapFromAddress(item)));
      })
      .catch((error: Object) => result.error(Value.errorCode(error), Value.errorMessage(error), null));
  }

  private getFromLocationName(call: MethodCall, result: MethodResult): void {
    const args = Value.asMap(call.args);
    const requestMap = Value.asMap(Value.mapValue(args, 'getFromLocationNameRequest'));
    const request: geoLocationManager.GeoCodeRequest = {
      description: Value.string(requestMap, 'locationName'),
      maxItems: Value.number(requestMap, 'maxResults', 1)
    };
    if (this.locale.length > 0) {
      request.locale = this.locale;
    }
    const minLat = Value.mapValue(requestMap, 'lowerLeftLatitude');
    const minLon = Value.mapValue(requestMap, 'lowerLeftLongitude');
    const maxLat = Value.mapValue(requestMap, 'upperRightLatitude');
    const maxLon = Value.mapValue(requestMap, 'upperRightLongitude');
    if (typeof minLat === 'number') {
      request.minLatitude = minLat as number;
    }
    if (typeof minLon === 'number') {
      request.minLongitude = minLon as number;
    }
    if (typeof maxLat === 'number') {
      request.maxLatitude = maxLat as number;
    }
    if (typeof maxLon === 'number') {
      request.maxLongitude = maxLon as number;
    }
    geoLocationManager.getAddressesFromLocationName(request)
      .then((addresses: Array<geoLocationManager.GeoAddress>) => {
        result.success(addresses.map((item: geoLocationManager.GeoAddress) => LocationConvert.toHWLocationMapFromAddress(item)));
      })
      .catch((error: Object) => result.error(Value.errorCode(error), Value.errorMessage(error), null));
  }

  private convertCoord(call: MethodCall, result: MethodResult): void {
    const args = Value.asMap(call.args);
    result.success(CoordinateConvert.convert(
      Value.number(args, 'latitude'),
      Value.number(args, 'longitude'),
      Value.number(args, 'coordType')
    ));
  }

  private toMockHWLocation(location: AnyMap): AnyMap {
    const map: AnyMap = location;
    map['countryCode'] = null;
    map['countryName'] = null;
    map['state'] = null;
    map['city'] = null;
    map['county'] = null;
    map['street'] = null;
    map['featureName'] = null;
    map['postalCode'] = null;
    map['phone'] = null;
    map['url'] = null;
    map['extraInfo'] = Value.createMap();
    map['coordinateType'] = 0;
    return map;
  }

  private unsupported(method: string, result: MethodResult): void {
    result.error('NOT_SUPPORTED', `${method} is not supported by the HarmonyOS implementation yet.`, null);
  }
}
