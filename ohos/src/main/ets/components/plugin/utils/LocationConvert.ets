/*
 * Copyright 2020-2024. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 */

import geoLocationManager from '@ohos.geoLocationManager';
import { Value } from './Value';
import type { AnyMap } from './Value';

export class LocationConvert {
  static toLocationMap(location: geoLocationManager.Location | null | undefined): AnyMap {
    if (!location) {
      return Value.createMap();
    }
    const time = location.timeStamp ?? Date.now();
    const accuracy = location.accuracy ?? 0;
    const map = Value.createMap();
    map['provider'] = 'ohos';
    map['latitude'] = location.latitude ?? 0;
    map['longitude'] = location.longitude ?? 0;
    map['altitude'] = location.altitude ?? 0;
    map['speed'] = location.speed ?? 0;
    map['bearing'] = location.direction ?? 0;
    map['horizontalAccuracyMeters'] = accuracy;
    map['verticalAccuracyMeters'] = location.altitudeAccuracy ?? 0;
    map['speedAccuracyMetersPerSecond'] = location.speedAccuracy ?? 0;
    map['bearingAccuracyDegrees'] = location.directionAccuracy ?? 0;
    map['time'] = time;
    map['elapsedRealtimeNanos'] = time * 1000000;
    map['isFromMockProvider'] = false;
    return map;
  }

  static toHWLocationMap(location: geoLocationManager.Location | null | undefined): AnyMap {
    const map = LocationConvert.toLocationMap(location);
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

  static toHWLocationMapFromAddress(address: geoLocationManager.GeoAddress): AnyMap {
    const now = Date.now();
    const map = Value.createMap();
    map['provider'] = 'ohos';
    map['latitude'] = (address.latitude ?? 0) as number;
    map['longitude'] = (address.longitude ?? 0) as number;
    map['altitude'] = 0;
    map['speed'] = 0;
    map['bearing'] = 0;
    map['horizontalAccuracyMeters'] = 0;
    map['verticalAccuracyMeters'] = 0;
    map['speedAccuracyMetersPerSecond'] = 0;
    map['bearingAccuracyDegrees'] = 0;
    map['time'] = now;
    map['elapsedRealtimeNanos'] = now * 1000000;
    map['countryCode'] = address.countryCode ?? null;
    map['countryName'] = address.countryName ?? null;
    map['state'] = address.administrativeArea ?? null;
    map['city'] = address.locality ?? null;
    map['county'] = address.subLocality ?? address.subAdministrativeArea ?? null;
    map['street'] = address.roadName ?? null;
    map['featureName'] = address.placeName ?? null;
    map['postalCode'] = address.postalCode ?? null;
    map['phone'] = address.phoneNumber ?? null;
    map['url'] = address.addressUrl ?? null;
    map['extraInfo'] = Value.createMap();
    map['coordinateType'] = 0;
    return map;
  }

  static toLocationRequest(args: Object | null | undefined): geoLocationManager.LocationRequest {
    const map = Value.asMap(args);
    const priority = Value.number(map, 'priority', 100);
    let ohosPriority = geoLocationManager.LocationRequestPriority.ACCURACY;
    if (priority === 104 || priority === 105) {
      ohosPriority = geoLocationManager.LocationRequestPriority.LOW_POWER;
    } else if (priority === 102) {
      ohosPriority = geoLocationManager.LocationRequestPriority.FIRST_FIX;
    }

    return {
      priority: ohosPriority,
      scenario: geoLocationManager.LocationRequestScenario.NAVIGATION,
      timeInterval: Math.max(1, Math.floor(Value.number(map, 'interval', 1000) / 1000)),
      distanceInterval: Value.number(map, 'smallestDisplacement', 0)
    } as geoLocationManager.LocationRequest;
  }

  static toCurrentLocationRequest(args: Object | null | undefined): geoLocationManager.CurrentLocationRequest {
    const map = Value.asMap(args);
    return {
      priority: geoLocationManager.LocationRequestPriority.ACCURACY,
      scenario: geoLocationManager.LocationRequestScenario.NAVIGATION,
      maxAccuracy: Value.number(map, 'smallestDisplacement', 0),
      timeoutMs: Math.max(1000, Value.number(map, 'maxWaitTime', 10000))
    } as geoLocationManager.CurrentLocationRequest;
  }

  static toLocationResultMap(location: geoLocationManager.Location): AnyMap {
    const locationMap = LocationConvert.toLocationMap(location);
    const hwLocationMap = LocationConvert.toHWLocationMap(location);
    const map = Value.createMap();
    map['locations'] = [locationMap];
    map['hwLocations'] = [hwLocationMap];
    map['lastLocation'] = locationMap;
    map['lastHWLocation'] = hwLocationMap;
    return map;
  }

  static locationAvailability(enabled: boolean): AnyMap {
    const map = Value.createMap();
    map['cellStatus'] = enabled ? 0 : 1000;
    map['wifiStatus'] = enabled ? 0 : 1000;
    map['elapsedRealtimeNs'] = Date.now() * 1000000;
    map['locationStatus'] = enabled ? 0 : 1000;
    return map;
  }

  static locationSettingsStates(enabled: boolean): AnyMap {
    const map = Value.createMap();
    map['blePresent'] = true;
    map['bleUsable'] = enabled;
    map['gpsPresent'] = true;
    map['gpsUsable'] = enabled;
    map['locationPresent'] = true;
    map['locationUsable'] = enabled;
    map['networkLocationPresent'] = true;
    map['networkLocationUsable'] = enabled;
    map['hmsLocationPresent'] = false;
    map['hmsLocationUsable'] = false;
    map['gnssPresent'] = true;
    map['gnssUsable'] = enabled;
    return map;
  }
}
