/*
 * Copyright 2020-2024. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 */

export class Channel {
  static readonly FUSED_LOCATION_METHOD: string = 'com.huawei.flutter.location/fusedlocation_methodchannel';
  static readonly FUSED_LOCATION_EVENT: string = 'com.huawei.flutter.location/fusedlocation_eventchannel';
  static readonly GEOFENCE_METHOD: string = 'com.huawei.flutter.location/geofence_methodchannel';
  static readonly GEOFENCE_EVENT: string = 'com.huawei.flutter.location/geofence_eventchannel';
  static readonly ACTIVITY_IDENTIFICATION_METHOD: string = 'com.huawei.flutter.location/activityidentification_methodchannel';
  static readonly ACTIVITY_IDENTIFICATION_EVENT: string = 'com.huawei.flutter.location/activityidentification_eventchannel';
  static readonly ACTIVITY_CONVERSION_EVENT: string = 'com.huawei.flutter.location/activityconversion_eventchannel';
  static readonly LOCATION_ENHANCE_METHOD: string = 'com.huawei.flutter.location/locationenhance_methodchannel';
  static readonly HMSLOGGER_METHOD: string = 'com.huawei.flutter.location/hmslogger_methodchannel';
  static readonly GEOCODER_METHOD: string = 'com.huawei.flutter.location/geocoder_methodchannel';
  static readonly LOCATION_UTILS_METHOD: string = 'com.huawei.flutter.location/locationutils_methodchannel';
}
