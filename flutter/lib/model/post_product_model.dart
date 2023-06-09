class PostProduct {
  String? name;
  String? category;
  String? quantity;

  PostProduct({
    this.name,
    this.category,
    this.quantity,
  });

  PostProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['category'] = category;
    data['quantity'] = quantity;
    return data;
  }
}
