import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:prop_info/vo/wfs_vo.dart';

class Utils{

  /// ###,###,### or #.#억 포맷 getter 메서드
  /// 파라미터로 int가 오면 #.# 억 포맷
  /// 파라미터로 String이 오면 ###,###,### 포맷
  String getFormattedNum(var num) {
    if (num is int) {
      int div = 10000000;
      if (num.toString().length > 8) {
        div = 100000000;
      }
      double temp = num / div;
      final formatCurrency = NumberFormat('###.0억');
      return formatCurrency.format(temp);
    }
    final numberFormat = NumberFormat.simpleCurrency(
        locale: "ko_KR", name: "", decimalDigits: 0);
    return numberFormat.format(int.parse(num));
  }

  /// 도로명 주소나 지번 주소 getter
  Future<String> getAddress(WfsVo wfs) async {
    String gpsUrl =
        'http://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&point=${wfs.posY},${wfs.posX}&format=json&type=both&zipcode=true&simple=false&key=2848041C-72F2-3A57-A772-707471AD56B3';

    final responseGps = await http.get(Uri.parse(gpsUrl));
    var json = jsonDecode(responseGps.body);
    var result = json['response']['result'];
    var address = result.length > 1
        ? json['response']['result'][1]['text']
        : json['response']['result'][0]['text'];

    return address;
  }

  /// bounds안에 latLng이 들어가는지 확인
  bool contain(LatLngBounds bounds, LatLng latLng) {
    bool isContain = false;
    if (bounds.southwest.latitude < latLng.latitude &&
        bounds.southwest.longitude < latLng.longitude &&
        bounds.northeast.latitude > latLng.latitude &&
        bounds.northeast.longitude > latLng.longitude) isContain = true;
    return isContain;
  }
}