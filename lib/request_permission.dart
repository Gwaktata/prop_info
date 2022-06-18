import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map_sample.dart';

// 권한 설정을 위한 페이지
class RequestPermission extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '남소유',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Container(
              height: 100,
            ),
            ElevatedButton(
              child: Text('시작'),
              style: ElevatedButton.styleFrom(
                fixedSize:Size(100, 60),
              ),
              onPressed: () async {
                if (await checkPermissions()) {
                  // 권한이 있으면 지도화면으로 보냄
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapSample()));
                } else {
                  // 권한이 없으면 권한 설정 화면으로 보냄
                  AppSettings.openLocationSettings();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 권한을 체크하는 메서드 (지도)
  Future<bool> checkPermissions() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.location].request();

    bool permitted = true;
    status.forEach((Permission, PermissionStatus) {
      if (!PermissionStatus.isGranted) permitted = false;
    });

    return permitted;
  }
}
