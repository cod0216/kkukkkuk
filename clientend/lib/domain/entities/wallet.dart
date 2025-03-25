class Wallet {
  final int id;
  final String address;
  final String did;
  final String publicKey;
  final DateTime createdAt;

  Wallet({
    required this.id,
    required this.address,
    required this.did,
    required this.publicKey,
    required this.createdAt,
  });
}