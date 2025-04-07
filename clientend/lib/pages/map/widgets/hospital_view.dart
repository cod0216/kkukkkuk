import 'package:flutter/material.dart';

class HospitalView extends StatelessWidget {
  final Map<String, dynamic> location; // 아이템 데이터

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
                children: [
                  Row(
                    //  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10,),
                      Text(location['name'] ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(location['address'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(overflow: TextOverflow.visible)
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone_rounded, size: 15),
                      SizedBox(width: 5),
                      Text(location['phone_number'] ?? '', style: Theme.of(context).textTheme.bodyMedium),

                      const SizedBox(width: 10),

                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Text(location['type_name'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall),
                      ),

                      const SizedBox(width: 5,),

                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Text(location['medical_dept_name'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall),
                      )

                    ],
                  ),
                ],
              ),)
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }




}
