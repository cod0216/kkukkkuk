import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kkuk_kkuk/features/hospital/usecase/get_hospital_info_usecase.dart';
import 'package:kkuk_kkuk/pages/map/widgets/map_floating_buttons.dart';
import 'package:kkuk_kkuk/pages/map/widgets/map_bottom_sheet.dart';
import 'package:kkuk_kkuk/shared/lib/permission/permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kkuk_kkuk/pages/map/widgets/hospital_view.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {
  final DraggableScrollableController sheetController = DraggableScrollableController();
  final _permissionManager = PermissionManager();
  late KakaoMapController mapController;
  late final GetHospitalInfoUseCase _getHospitalInfoUseCase;



  final String myLocationKey = "my_location";

  List<dynamic> locationList = [];
  Set<Marker> markers = {};

  double latitude = 37;
  double longitude = 126;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }


  Future<void> _initializeData() async {
    await _getGeoData();
    await _getNearHospitals();
  }


  Widget _getItemBuilder(dynamic location) {
    return GestureDetector(
        onTap: () {
          mapController.setCenter(
              LatLng(location["latitude"], location["longitude"]));
        },
        child: HospitalView(location: location));
  }

  // 병원 정보 요청
  Future<void> _getNearHospitals() async {
    LatLng latLng = await mapController.getCenter();




  }

  // 현재 위치로 맵 이동
  void goCenter() {
    mapController.setCenter(LatLng(latitude, longitude));
  }

  // 현재 위치 가져오기
  Future<void> _getGeoData() async {
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      Permission.location,
    );

    if (!hasPermission || !context.mounted) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('위치 접근 권한이 필요합니다.')));
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;

        // 기존 내 위치 마커 제거 후 다시 추가
        markers.removeWhere((marker) => marker.markerId == myLocationKey);
        markers.add(Marker(
          markerId: myLocationKey,
          latLng: LatLng(latitude, longitude),
        ));
      });

      mapController.setCenter(LatLng(latitude, longitude));
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> makeMarkers(List<dynamic> list) async {
    mapController.clearMarker();

    Set<Marker> newMarkers = {
      // 내 위치 마커 유지
      Marker(
        markerId: myLocationKey,
        latLng: LatLng(latitude, longitude),
      )
    };

    for (int i = 0; i < list.length; i++) {
      // newMarkers.add(
      //     // Marker(
      //     // markerId: '${list[i]["id"]}',
      //     // latLng: LatLng(list[i]["latitude"], list[i]["longitude"])
      //     // markerImageSrc: )
      //
      // );
    }

    mapController.addMarker(markers: newMarkers.toList());

    setState(() {
      markers = newMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
       child: Scaffold(
            body: Stack(
              children: [
                KakaoMap(
                  onMapCreated: ((controller) async {
                    mapController = controller;
                  }),
                  markers: markers.toList(),
                  center: LatLng(latitude, longitude),
                ),

                FloatingButtons(
                  onRefresh: _getNearHospitals,
                  onCenter: goCenter,
                ),

                MapBottomSheet(
                  locationList: locationList,
                  controller: sheetController,
                  onItemTap: (location) {
                    mapController.setCenter(
                        LatLng(location["latitude"], location["longitude"]));
                  },
                ),
              ],
            ),
          ));

  }
}
