import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/features/hospital/api/dto/hospital_info_response.dart';

class HospitalView extends StatelessWidget {
  final HospitalInfo location;

  const HospitalView({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Row(
                    children: [
                      Text(location.name ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  Text(location.address ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(overflow: TextOverflow.visible)
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone_rounded, size: 15),
                      const SizedBox(width: 5),
                      Text(location.phoneNumber ?? '정보 없음', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),)
            ],
          ),
        ],
      ),
    );
  }




}
