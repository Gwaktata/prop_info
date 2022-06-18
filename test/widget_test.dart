import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:math' as Math;

import 'package:intl/intl.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:prop_info/vo/wfs_vo.dart';
import 'package:xml/xml.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('API 테스트', () async {
    var url = Uri.http(
      'openapi.nsdi.go.kr',
      '/nsdi/ApartHousingPriceService/wfs/getApartHousingPriceWFS',
      {
        'authkey': 'a6de215dbcaef512bb6916',
        'typename': 'F163',
        'bbox':
            '36.30991366201103,127.41686303168535,36.33903488740005,127.43597075343132,EPSG:4326',
        'maxFeatures': '100',
        'resultType': 'results',
        'srsName': 'EPSG:4326',
      },
    );

    final response = await http.get(url);
    final xml = convert.Utf8Codec().decode(response.bodyBytes);

    final document = XmlDocument.parse(xml);
    print(document.toString());
    //print(document.toXmlString(pretty: true, indent: '\t'));
    final items = document.findAllElements('NSDI:F163');
    var wfsModels = <WfsVo>[];
    items.forEach((node) {
      //wfsModels.add(WfsModel.fromXml(node));
    });
    print(wfsModels.length);
    /*wfsModels.forEach((wfs) {
      print(wfs.dongNm);
    });*/
  });

  degrees2meters(lon, lat) {
    var x = lon * 20037508.34 / 180;
    var y = Math.log(Math.tan((90 + lat) * Math.pi / 360)) / (Math.pi / 180);
    y = y * 20037508.34 / 180;
    return [x, y];
  }

  final tuple = ProjectionTuple(
    fromProj: Projection.get('EPSG:4326')!,
    toProj: Projection.get('EPSG:3857')!,
  );

  gTo5174(lat, lng) {
    var pointSrc = Point(x: lat, y: lng);
    var pointForward = tuple.forward(pointSrc);
    return pointForward;
  }

  List<double> latlngTo3857 (lat, lng) {
    var x = lng * 20037508.34 / 180;
    var y = Math.log(Math.tan((90 + lat) * Math.pi / 360)) / (Math.pi / 180);
    y = y * 20037508.34 / 180;
    return [x, y];
  }

  List<double> fromPointToLatLng(y, x) {
    var lat = (2 * Math.atan(Math.exp((y - 128) / -(256 / (2 * Math.pi)))) -
        Math.pi / 2) /
        (Math.pi / 180);
    var lng = (x - 128) / (256 / 360);
    return [lat, lng];
  }

  List<double> fromLatLngToPoint(lat, lng) {
    var siny =
    Math.min(Math.max(Math.sin(lat * (Math.pi / 180)), -.9999), .9999);
    var x = 128 + lng * (256 / 360);
    var y =
        128 + 0.5 * Math.log((1 + siny) / (1 - siny)) * -(256 / (2 * Math.pi));
    return [x as double, y];
  }

  test('좌표', () {
    var point = Point(x: 36.31743710915124, y: 127.42205914109944);
    var forwart = tuple.forward(point);
    print(forwart.toArray());
  });

  test('넘버포맷', () {
    int c = 714800000.0.toInt();
    print(c);
    int a = 94871871225;
    String b = '$a';
    int div = 10000000;
    if(b.length > 8){
      div = 100000000;
    }
    double tempA = a / div;
    final formatCurrency = NumberFormat('###.0억');
    print(formatCurrency.format(tempA));
  });

  test('주소', () async {
      // 좌표로 주소 구하기
      String gpsUrl =
          'http://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&point=127.40957221926641,36.343248519711366&format=json&type=both&zipcode=true&simple=false&key=2848041C-72F2-3A57-A772-707471AD56B3';

      final responseGps = await http.get(Uri.parse(gpsUrl));
      var json = jsonDecode(responseGps.body);
      List<dynamic> result = json['response']['result'];
      print('-------------------------------');
      print(result.length);
      var address = result.length > 1
          ? json['response']['result'][1]['text']
          : json['response']['result'][0]['text'];
      print(address);
  });

/*  test('json', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    String jsonString = await rootBundle.loadString('assets/json/daejeon.json');
    final jsonResponse = json.decode(jsonString);
    var j = jsonResponse['features'];
    List<WfsModel> models = [];
    j.forEach((json)  {
      WfsModel wfs = WfsModel.fromJson(json['properties']);
      models.add(wfs);
    });
    models.forEach((element) {
      print(element.getAvrgPblntfPc());
      print(element.getFormattedAvrgPblntfPc());
      print(element.getFormattedunitArPc());
    });
    //print(jsonResponse['features'][0]);
  });*/
}

/*final Xml2JsonData = Xml2Json()..parse(element.toString()); //json으로 변환
      final jsonData = Xml2JsonData.toParker(); //그냥 령식 옵션
      print(jsonData);  //json데이터로 잘 변환되었나 확인.*/

/*convertCoordinates(lon, lat) {
  var x = (lon * 20037508.34) / 180;
  var y = Math.log(Math.tan(((90 + lat) * Math.PI) / 360)) / (Math.PI / 180);
  y = (y * 20037508.34) / 180;
  return [x, y];
}*/

