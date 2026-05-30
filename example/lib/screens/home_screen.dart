/*
 * Copyright 2020-2024. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:huawei_location_example/l10n/app_localizations.dart';
import 'package:huawei_location_example/providers/locale_provider.dart';
import 'package:huawei_location_example/screens/geocoder_screen.dart';
import 'package:huawei_location_example/screens/high_precision_location_screen.dart';

import 'package:huawei_location_example/widgets/custom_button.dart';
import 'package:huawei_location_example/screens/activity_screen.dart';
import 'package:huawei_location_example/screens/fusedlocation_screen.dart';
import 'package:huawei_location_example/screens/geofence_screen.dart';
import 'package:huawei_location_example/screens/location_utils_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasLocationPermission = false;
  
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPermissions();
    });
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      _hasLocationPermission = status.isGranted;
    });
  }

  Future<void> _requestLocationPermission() async {
    final localizations = AppLocalizations.of(context);
    final status = await Permission.location.request();
    
    setState(() {
      _hasLocationPermission = status.isGranted;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status.isGranted
                ? localizations.permissionGranted 
                : localizations.permissionDenied,
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      if (status.isDenied || status.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.permissionDenied),
            content: Text(localizations.pleaseGrantPermission),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  void requestPermissions() async {
    final localizations = AppLocalizations.of(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.aboutPermissions,
          ),
          content: Text(
            localizations.permissionsMessage,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              localeProvider.toggleLocale();
            },
            tooltip: localizations.language,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _hasLocationPermission ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _hasLocationPermission ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _hasLocationPermission ? Icons.check_circle : Icons.cancel,
                        color: _hasLocationPermission ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${localizations.locationPermissionStatus}: ${_hasLocationPermission ? localizations.granted : localizations.denied}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _hasLocationPermission ? Colors.green.shade900 : Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _requestLocationPermission,
                    icon: const Icon(Icons.location_on),
                    label: Text(localizations.requestLocationPermission),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasLocationPermission ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  Btn(localizations.fusedLocationService, () {
                    Navigator.pushNamed(
                      context,
                      FusedLocationScreen.ROUTE_NAME,
                    );
                  }),
                  Btn(localizations.activityIdentificationService, () {
                    Navigator.pushNamed(
                      context,
                      ActivityScreen.ROUTE_NAME,
                    );
                  }),
                  Btn(localizations.geofenceService, () {
                    Navigator.pushNamed(
                      context,
                      GeofenceScreen.ROUTE_NAME,
                    );
                  }),
                  Btn(localizations.highPrecisionLocationService, () {
                    Navigator.pushNamed(
                      context,
                      HighPrecisionLocationScreen.ROUTE_NAME,
                    );
                  }),
                  Btn(localizations.geocoderService, () {
                    Navigator.pushNamed(
                      context,
                      GeocoderScreen.ROUTE_NAME,
                    );
                  }),
                  Btn(localizations.locationUtils, () {
                    Navigator.pushNamed(
                      context,
                      LocationUtilsScreen.ROUTE_NAME,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
