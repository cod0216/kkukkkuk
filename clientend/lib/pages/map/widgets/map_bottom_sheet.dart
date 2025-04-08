import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/features/hospital/api/dto/hospital_info_response.dart';
import 'package:kkuk_kkuk/pages/map/widgets/hospital_view.dart';

class MapBottomSheet extends StatelessWidget {
  final List<HospitalInfo> locationList;
  final DraggableScrollableController controller;
  final void Function(HospitalInfo location) onItemTap;

  const MapBottomSheet({
    super.key,
    required this.locationList,
    required this.controller,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      maxChildSize: 0.8,
      minChildSize: 0.1,
      controller: controller,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
          child: Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final HospitalInfo location = locationList[index];
                        return GestureDetector(
                          onTap: () => onItemTap(location),
                          child: HospitalView(location: location),
                        );
                      },
                      childCount: locationList.length,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey[400],
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(top: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
