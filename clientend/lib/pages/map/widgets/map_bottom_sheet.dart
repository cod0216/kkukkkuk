import 'package:flutter/material.dart';
import 'hospital_view.dart';

class MapBottomSheet extends StatelessWidget {
  final List<dynamic> locationList;
  final DraggableScrollableController controller;
  final void Function(dynamic location) onItemTap;

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
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey[400],
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(top: 18, bottom: 16),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final location = locationList[index];
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
        );
      },
    );
  }
}
