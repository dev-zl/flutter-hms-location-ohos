import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'HMS Location Kit Flutter Demo',
      'about_permissions': 'About Permissions',
      'permissions_message':
          'Huawei Location needs some permissions to work properly.\n\n'
              'You are expected to handle these permissions to use Huawei Location Demo.',
      'fused_location_service': 'Fused Location Service',
      'activity_identification_service':
          'Activity Identification/Recognition Service',
      'geofence_service': 'Geofence Service',
      'high_precision_location_service': 'High Precision Location Service',
      'geocoder_service': 'Geocoder Service',
      'location_utils': 'Location Utils',
      'activity_identification_conversion':
          'Activity Identification and Conversion',
      'activity_identification': 'Activity Identification',
      'activity_conversion': 'Activity Conversion',
      'language': 'Language',
      'chinese': '中文',
      'english': 'English',
      'init_fused_location': 'Init Fused Location',
      'check_location_settings': 'checkLocationSettings',
      'get_last_location': 'getLastLocation',
      'get_last_location_with_address': 'getLastLocation\nWithAddress',
      'get_location_availability': 'getLocationAvailability',
      'set_mock_mode_true': 'setMockModeTrue',
      'set_mock_mode_false': 'setMockModeFalse',
      'set_mock_location': 'setMockLocation',
      'location_updates': 'Location Updates',
      'location_updates_with_callback': 'Location Updates with Callback',
      'location_updates_ex_with_callback': 'Location Updates Ex with Callback',
      'location_enhance_service': 'Location Enhance Service',
      'enable_bg_location': 'enableBgLocation',
      'disable_bg_location': 'disableBgLocation',
      'set_log_config': 'setLogConfig',
      'get_log_config': 'getLogConfig',
      'geofence_screen': 'Geofence Screen',
      'add_geofence': 'Add Geofence',
      'remove_geofence': 'Remove Geofence',
      'create_geofence_list': 'createGeofenceList',
      'delete_geofence_list': 'deleteGeofenceList',
      'delete_geofence_list_with_ids': 'deleteGeofenceListWithIds',
      'geofence_unique_id': 'Geofence UniqueId',
      'geofences': 'Geofences',
      'request_high_precision_location': 'Request High Precision Location',
      'remove_high_precision_location': 'Remove High Precision Location',
      'geocoder_screen': 'Geocoder Screen',
      'reverse_geocoding_request': 'Reverse geocoding request',
      'forward_geocoding_request': 'Forward geocoding request information',
      'get_from_location': 'Get From Location',
      'get_from_location_name': 'Get From Location Name',
      'from_location_screen': 'From Location Screen',
      'from_location_name_screen': 'From Location Name Screen',
      'get': 'GET',
      'location_updates_screen': 'Location Updates',
      'request_location_updates': 'Request Location Updates',
      'remove_location_updates': 'Remove Location Updates',
      'location_updates_with_cb': 'Location Updates with CB',
      'location_updates_ex_with_cb': 'Location Updates Ex with CB',
      'add_geofence_screen': 'Add Geofence Screen',
      'get_current_location': 'Get Current Location',
      'location_utils_screen': 'Location Utils Screen',
      'convert_coordinate_screen': 'Convert Coordinate Screen',
      'convert_coordinate': 'convertCoordinate',
      'get_navigation_context_state': 'getNavigationContextState',
      'request_activity_identification_updates': 'Request Activity Identification Updates',
      'remove_activity_identification_updates': 'Remove Activity Identification Updates',
      'request_activity_conversion_updates': 'Request Activity Conversion Updates',
      'remove_activity_conversion_updates': 'Remove Activity Conversion Updates',
      'location_permission_status': 'Location Permission Status',
      'granted': 'Granted',
      'denied': 'Denied',
      'request_location_permission': 'Request Location Permission',
      'permission_granted': 'Permission Granted',
      'permission_denied': 'Permission Denied',
      'please_grant_permission': 'Please grant location permission in settings',
    },
    'zh': {
      'app_title': 'HMS 定位服务 Flutter 示例',
      'about_permissions': '关于权限',
      'permissions_message': '华为定位服务需要一些权限才能正常工作。\n\n'
          '您需要处理这些权限才能使用华为定位演示。',
      'fused_location_service': '融合定位服务',
      'activity_identification_service': '活动识别服务',
      'geofence_service': '地理围栏服务',
      'high_precision_location_service': '高精度定位服务',
      'geocoder_service': '地理编码服务',
      'location_utils': '定位工具',
      'activity_identification_conversion': '活动识别和转换',
      'activity_identification': '活动识别',
      'activity_conversion': '活动转换',
      'language': '语言',
      'chinese': '中文',
      'english': 'English',
      'init_fused_location': '初始化融合定位',
      'check_location_settings': '检查定位设置',
      'get_last_location': '获取最后位置',
      'get_last_location_with_address': '获取最后位置\n（含地址）',
      'get_location_availability': '获取定位可用性',
      'set_mock_mode_true': '开启模拟模式',
      'set_mock_mode_false': '关闭模拟模式',
      'set_mock_location': '设置模拟位置',
      'location_updates': '位置更新',
      'location_updates_with_callback': '位置更新（回调）',
      'location_updates_ex_with_callback': '位置更新扩展（回调）',
      'location_enhance_service': '位置增强服务',
      'enable_bg_location': '启用后台定位',
      'disable_bg_location': '禁用后台定位',
      'set_log_config': '设置日志配置',
      'get_log_config': '获取日志配置',
      'geofence_screen': '地理围栏页面',
      'add_geofence': '添加地理围栏',
      'remove_geofence': '移除地理围栏',
      'create_geofence_list': '创建地理围栏列表',
      'delete_geofence_list': '删除地理围栏列表',
      'delete_geofence_list_with_ids': '按ID删除地理围栏列表',
      'geofence_unique_id': '地理围栏唯一ID',
      'geofences': '地理围栏',
      'request_high_precision_location': '请求高精度定位',
      'remove_high_precision_location': '移除高精度定位',
      'geocoder_screen': '地理编码页面',
      'reverse_geocoding_request': '逆地理编码请求',
      'forward_geocoding_request': '正向地理编码请求信息',
      'get_from_location': '从位置获取',
      'get_from_location_name': '从位置名称获取',
      'from_location_screen': '从位置页面',
      'from_location_name_screen': '从位置名称页面',
      'get': '获取',
      'location_updates_screen': '位置更新',
      'request_location_updates': '请求位置更新',
      'remove_location_updates': '移除位置更新',
      'location_updates_with_cb': '位置更新（回调）',
      'location_updates_ex_with_cb': '位置更新扩展（回调）',
      'add_geofence_screen': '添加地理围栏页面',
      'get_current_location': '获取当前位置',
      'location_utils_screen': '定位工具页面',
      'convert_coordinate_screen': '坐标转换页面',
      'convert_coordinate': '转换坐标',
      'get_navigation_context_state': '获取导航上下文状态',
      'request_activity_identification_updates': '请求活动识别更新',
      'remove_activity_identification_updates': '移除活动识别更新',
      'request_activity_conversion_updates': '请求活动转换更新',
      'remove_activity_conversion_updates': '移除活动转换更新',
      'location_permission_status': '定位权限状态',
      'granted': '已授权',
      'denied': '未授权',
      'request_location_permission': '请求定位权限',
      'permission_granted': '权限已授予',
      'permission_denied': '权限被拒绝',
      'please_grant_permission': '请在设置中授予定位权限',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get aboutPermissions => translate('about_permissions');
  String get permissionsMessage => translate('permissions_message');
  String get fusedLocationService => translate('fused_location_service');
  String get activityIdentificationService =>
      translate('activity_identification_service');
  String get geofenceService => translate('geofence_service');
  String get highPrecisionLocationService =>
      translate('high_precision_location_service');
  String get geocoderService => translate('geocoder_service');
  String get locationUtils => translate('location_utils');
  String get activityIdentificationConversion =>
      translate('activity_identification_conversion');
  String get activityIdentification => translate('activity_identification');
  String get activityConversion => translate('activity_conversion');
  String get language => translate('language');
  String get chinese => translate('chinese');
  String get english => translate('english');
  String get initFusedLocation => translate('init_fused_location');
  String get checkLocationSettings => translate('check_location_settings');
  String get getLastLocation => translate('get_last_location');
  String get getLastLocationWithAddress => translate('get_last_location_with_address');
  String get getLocationAvailability => translate('get_location_availability');
  String get setMockModeTrue => translate('set_mock_mode_true');
  String get setMockModeFalse => translate('set_mock_mode_false');
  String get setMockLocation => translate('set_mock_location');
  String get locationUpdates => translate('location_updates');
  String get locationUpdatesWithCallback => translate('location_updates_with_callback');
  String get locationUpdatesExWithCallback => translate('location_updates_ex_with_callback');
  String get locationEnhanceService => translate('location_enhance_service');
  String get enableBgLocation => translate('enable_bg_location');
  String get disableBgLocation => translate('disable_bg_location');
  String get setLogConfig => translate('set_log_config');
  String get getLogConfig => translate('get_log_config');
  String get geofenceScreen => translate('geofence_screen');
  String get addGeofence => translate('add_geofence');
  String get removeGeofence => translate('remove_geofence');
  String get createGeofenceList => translate('create_geofence_list');
  String get deleteGeofenceList => translate('delete_geofence_list');
  String get deleteGeofenceListWithIds => translate('delete_geofence_list_with_ids');
  String get geofenceUniqueId => translate('geofence_unique_id');
  String get geofences => translate('geofences');
  String get requestHighPrecisionLocation => translate('request_high_precision_location');
  String get removeHighPrecisionLocation => translate('remove_high_precision_location');
  String get geocoderScreen => translate('geocoder_screen');
  String get reverseGeocodingRequest => translate('reverse_geocoding_request');
  String get forwardGeocodingRequest => translate('forward_geocoding_request');
  String get getFromLocation => translate('get_from_location');
  String get getFromLocationName => translate('get_from_location_name');
  String get fromLocationScreen => translate('from_location_screen');
  String get fromLocationNameScreen => translate('from_location_name_screen');
  String get get => translate('get');
  String get locationUpdatesScreen => translate('location_updates_screen');
  String get requestLocationUpdates => translate('request_location_updates');
  String get removeLocationUpdates => translate('remove_location_updates');
  String get locationUpdatesWithCb => translate('location_updates_with_cb');
  String get locationUpdatesExWithCb => translate('location_updates_ex_with_cb');
  String get addGeofenceScreen => translate('add_geofence_screen');
  String get getCurrentLocation => translate('get_current_location');
  String get locationUtilsScreen => translate('location_utils_screen');
  String get convertCoordinateScreen => translate('convert_coordinate_screen');
  String get convertCoordinate => translate('convert_coordinate');
  String get getNavigationContextState => translate('get_navigation_context_state');
  String get requestActivityIdentificationUpdates => translate('request_activity_identification_updates');
  String get removeActivityIdentificationUpdates => translate('remove_activity_identification_updates');
  String get requestActivityConversionUpdates => translate('request_activity_conversion_updates');
  String get removeActivityConversionUpdates => translate('remove_activity_conversion_updates');
  String get locationPermissionStatus => translate('location_permission_status');
  String get granted => translate('granted');
  String get denied => translate('denied');
  String get requestLocationPermission => translate('request_location_permission');
  String get permissionGranted => translate('permission_granted');
  String get permissionDenied => translate('permission_denied');
  String get pleaseGrantPermission => translate('please_grant_permission');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
