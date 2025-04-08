import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kkuk_kkuk/pages/map/widgets/map_floating_buttons.dart';
import 'package:kkuk_kkuk/pages/map/widgets/map_bottom_sheet.dart';
import 'package:kkuk_kkuk/shared/lib/permission/permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/hospital/api/dto/hospital_info_response.dart';
import 'package:kkuk_kkuk/features/hospital/usecase/hospital_usecase_providers.dart';
import 'package:kkuk_kkuk/shared/config/s3_icon.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}


class _MapScreenState extends ConsumerState<MapScreen> {
  final DraggableScrollableController sheetController = DraggableScrollableController();
  final _permissionManager = PermissionManager();
  late KakaoMapController mapController;

  static const String _myLocationKey = "my_location";
  static String authMarker = S3Icon.mapAuthMarker;
  static String normalMarker = S3Icon.mapNormalMarker;


  List<HospitalInfo> locationList = [];
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

  // 병원 정보 요청
  Future<void> _getNearHospitals() async {
    LatLng latLng = await mapController.getCenter();

    final getHospitalUseCase = ref.read(getHospitalUseCaseProvider);

    try {
      final response = await getHospitalUseCase.getNearHospitals(
        latLng.longitude,
        latLng.latitude,
        500,
      );

      setState(() {
        locationList = response.data;
      });

      await makeMarkers(locationList);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('병원 정보를 불러오는데 실패했습니다.')),
        );
      }
      debugPrint("병원 정보 요청 실패: $e");
    }
  }

  // 현재 위치로 맵 이동
  void _goCenter() {
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

        markers.removeWhere((marker) => marker.markerId == _myLocationKey);
        markers.add(Marker(
          markerId: _myLocationKey,
          latLng: LatLng(latitude, longitude),

        ));
      });

      mapController.setCenter(LatLng(latitude, longitude));
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> makeMarkers(List<HospitalInfo> list) async {
    mapController.clearMarker();

    Set<Marker> newMarkers = {
      Marker(
        markerId: _myLocationKey,
        latLng: LatLng(latitude, longitude),
      )
    };

    for (int i = 0; i < list.length; i++) {
      newMarkers.add(
          Marker(
              markerId: '${list[i].id}',
              latLng: LatLng(list[i].yAxis, list[i].xAxis),
              markerImageSrc: list[i].flagCertified ? authMarker : normalMarker
            
          )

      );
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
            appBar: CustomAppBar(),

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
                  onCenter: _goCenter,
                ),

                MapBottomSheet(
                  locationList: locationList,
                  controller: sheetController,
                  onItemTap: (location) {
                    mapController.setCenter(
                        LatLng(location.yAxis, location.xAxis));
                  },
                ),
              ],
            ),
          ));

  }
}
