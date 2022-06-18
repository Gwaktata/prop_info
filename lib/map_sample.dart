import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prop_info/service/api_service.dart';
import 'package:prop_info/util/utils.dart';

import 'detail_page.dart';

import 'vo/wfs_vo.dart';

class MapSample extends StatefulWidget {
  late final String title;

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;
  // 카메라 위치
  late Position _initialPosition;
  // api 객체
  final ApiService _api = ApiService();
  // 마커 정보 set
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('남소유'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder<Position>(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(7, 18),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _initialPosition.latitude, _initialPosition.longitude),
                  zoom: 16,
                ),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                onCameraIdle: () async {
                  setState(() {
                    setMarkers();
                  });
                },
                markers: markers,
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toCurrentLocation();
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  /// 맵 생성시 실행
  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _controller = controller;
      setMarkers();
    });
  }

  /// 마커 셋팅
  Future<void> setMarkers() async {
    Set<WfsVo> WfsVos = {};
    double zoomLevel = await _controller.getZoomLevel();
    LatLngBounds bounds = await _controller.getVisibleRegion();
    int level = zoomLevel.floor();
    // 줌레벨 15 이상에서만 마커 셋팅
    if (level >= 15) {
      // api 호출
      WfsVos = await _api.callAPI(bounds);
      removeByBounds(bounds);
      markerFactory(WfsVos);
    } else {
      // 15레벨 보다 낮으면 마커 출력안함
      markers.clear();
    }
    setState(() {});
  }

  /// 마커 정보 셋팅
  void markerFactory(Set<WfsVo> WfsVos) {
    WfsVos.forEach((wfs) {
      markers.add(
        Marker(
          position: LatLng(wfs.posX, wfs.posY),
          markerId: MarkerId(wfs.id),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: wfs.aphusNm,
            snippet: '${Utils().getFormattedNum(wfs.avrgPblntfPc)}',
            onTap: () {
              clickMarker(wfs);
            },
          ),
        ),
      );
    });
  }

  /// 화면에 안들어오는 마커 삭제
  void removeByBounds(LatLngBounds bounds) {
    markers.removeWhere((e) => !Utils()
        .contain(bounds, LatLng(e.position.latitude, e.position.longitude)));
  }

  /// 마커 클릭 시 상세페이지 이동
  void clickMarker(WfsVo wfs) async {
    String address = await Utils().getAddress(wfs);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(wfs: wfs, address: address),
      ),
    );
  }

  /// 현재 위치 초기화
  Future<Position> getCurrentLocation() async {
    _initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return _initialPosition;
  }

  /// 현재 위치로 이동
  toCurrentLocation() async {
    _initialPosition = await getCurrentLocation();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 16,
        ),
      ),
    );
  }
}
