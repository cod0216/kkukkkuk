class Wallet {
  final int id;
  final String address;
  final String name;
  final List<Owner>? owners;

  Wallet({
    required this.id,
    required this.address,
    required this.name,
    this.owners,
  });
}

class Owner {
  final int id;
  final String name;
  final String? image;

  Owner({required this.id, required this.name, this.image});
}
