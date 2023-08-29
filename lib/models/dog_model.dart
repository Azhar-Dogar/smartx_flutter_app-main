class DogModel {
  final String name;
  final String size;
  final String id;
  final String userId;
  final String gender;
  final bool isGoodWithDogs;
  final bool isGoodWithKids;
  final bool isNeutered;
   bool isSelected;
  final String? imagePath;

  DogModel(
      {required this.name,
        required this.size,
        required this.isSelected,
        required this.id,
        required this.userId,
        required this.isGoodWithDogs,
        required this.isGoodWithKids,
        required this.isNeutered,
        required this.gender,
        this.imagePath});

  factory DogModel.fromJson(Map<String, dynamic> json) {
    final String name = json.containsKey('name') ? json['name'] : '';
    final String gender = json.containsKey('gender') ? json['gender'] : '';
    final String size = json.containsKey('size') ? json['size'] : '';
    final String imagePath =
    json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';

    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final String userId =
    json.containsKey('userId') ? json['userId'] ?? '' : '';
    final bool isGoodWithDogs = json.containsKey('isGoodWithDogs')
        ? json['isGoodWithDogs'] ?? false
        : false;
    final bool isGoodWithKids = json.containsKey('isGoodWithKids')
        ? json['isGoodWithKids'] ?? false
        : false;
    final bool isSelected = json.containsKey('isSelected')
        ? json['isSelected'] ?? false
        : false;
    final bool isNeutered =
    json.containsKey('isNeutered') ? json['isNeutered'] ?? false : false;

    return DogModel(
        name: name,
        userId: userId,
        size: size,
        gender: gender,
        isGoodWithDogs: isGoodWithDogs,
        isGoodWithKids: isGoodWithKids,
        isNeutered: isNeutered,
        id: id,
        isSelected: isSelected,
        imagePath: imagePath);
  }

  DogModel copyWith(
      {String? name, String? imagePath, String? size, String? id}) =>
      DogModel(
          name: name ?? this.name,
          imagePath: imagePath ?? this.imagePath,
          size: size ?? this.size,
          isNeutered: isNeutered,
          userId: userId,
          isGoodWithKids: isGoodWithKids,
          isGoodWithDogs: isGoodWithDogs,
          gender: gender,
          id: id ?? this.id, isSelected: isSelected);

  Map<String, dynamic> toJson() => {
    'name': name,
    'size': size,
    'gender': gender,
    'isNeutered': isNeutered,
    'isGoodWithKids': isGoodWithKids,
    'isGoodWithDogs': isGoodWithDogs,
    'id': id,
    'userId': userId,
    'imagePath': imagePath
  };

  @override
  String toString() {
    return 'DogModelResponse{firstName: $name,  email: $size, id: $id,imagePath :$imagePath}';
  }
}