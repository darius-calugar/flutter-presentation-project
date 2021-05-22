import 'dart:typed_data';

class CategoryModel {
  final int id;
  final String name;
  final Uint8List imageBytes;

  CategoryModel(
    this.id,
    this.name,
    this.imageBytes,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageBytes': imageBytes,
    }..removeWhere((key, value) => value == null);
  }

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      json['id'],
      json['name'],
      json['imageBytes'],
    );
  }
}
