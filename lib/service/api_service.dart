import 'dart:convert' as convert;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../vo/wfs_vo.dart';
import 'package:xml/xml.dart';

import 'package:http/http.dart' as http;

class ApiService {
  Future<Set<WfsVo>> callAPI(LatLngBounds bounds) async {
    Set<WfsVo> WfsVos = {};
    double startX = bounds.southwest.latitude;
    double startY = bounds.southwest.longitude;

    // API 요청 한번에 최대 100개
    // 반복문으로 영역을 바꿔가면서 호출
    while (true) {
      var url = Uri.http(
        'openapi.nsdi.go.kr',
        '/nsdi/ApartHousingPriceService/wfs/getApartHousingPriceWFS',
        {
          'authkey': 'a6de215dbcaef512bb6916',
          'typename': 'F163',
          'bbox':
              '$startX,$startY,${bounds.northeast.latitude},${bounds.northeast.longitude},EPSG:4326',
          'maxFeatures': '100',
          'resultType': 'results',
          'srsName': 'EPSG:4326',
        },
      );

      var response = await http.get(url);
      var xml = const convert.Utf8Codec().decode(response.bodyBytes);

      var document = XmlDocument.parse(xml);
      var items = document.findAllElements('NSDI:F163');

      items.forEach((node) {
        WfsVo wfs = WfsVo.fromXml(node);

        reduceBounds(wfs, startY, startX);

        WfsVos.add(wfs);
      });

      // 영역 안에 정보가 100개 미만일 때 탈출
      if (items.length < 100) {
        break;
      }
    }

    return WfsVos;
  }

  /// 결과 중 가장 가장 경도가 큰 위치를 기준으로 화면 좌하단 변경
  void reduceBounds(WfsVo wfs, double startY, double startX) {
    if (wfs.posY > startY) {
      startX = wfs.posX;
      startY = wfs.posY;
    }
  } // callAPI

}
