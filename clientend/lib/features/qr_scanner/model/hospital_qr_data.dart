import 'dart:convert';

class HospitalQRData {
  final String type;
  final String name;
  final String address;
  final String did;

  HospitalQRData({
    required this.type,
    required this.name,
    required this.address,
    required this.did,
  });

  factory HospitalQRData.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'hospital') {
      throw FormatException('Invalid QR code type: ${json['type']}');
    }

    return HospitalQRData(
      type: json['type'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      did: json['did'] as String,
    );
  }

  factory HospitalQRData.fromQRData(String qrData) {
    try {
      final Map<String, dynamic> json = jsonDecode(qrData);
      return HospitalQRData.fromJson(json);
    } catch (e) {
      throw FormatException('Invalid QR code data format');
    }
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    'address': address,
    'did': did,
  };
}
