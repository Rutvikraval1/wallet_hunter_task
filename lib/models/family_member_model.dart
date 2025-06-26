import 'dart:convert';

class FamilyMemberModel {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final int age;
  final String gender;
  final String maritalStatus;
  final String relationship;
  final String occupation;
  final String qualification;
  final String phone;
  final String email;
  final String? bloodGroup;
  final String? profilePhoto;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, double>? treePosition;
  final int generation;
  final String? parentId;

  FamilyMemberModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.relationship,
    required this.occupation,
    required this.qualification,
    required this.phone,
    required this.email,
    this.bloodGroup,
    this.profilePhoto,
    this.address,
    required this.createdAt,
    required this.updatedAt,
    this.treePosition,
    this.generation = 1,
    this.parentId,
  });

  String get fullName => '$firstName $middleName $lastName'.trim();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'relationship': relationship,
      'occupation': occupation,
      'qualification': qualification,
      'phone': phone,
      'email': email,
      'bloodGroup': bloodGroup,
      'profilePhoto': profilePhoto,
      'address': address,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'treePosition': treePosition,
      'generation': generation,
      'parentId': parentId,
    };
  }

  factory FamilyMemberModel.fromMap(Map<String, dynamic> map) {
    return FamilyMemberModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      relationship: map['relationship'] ?? '',
      occupation: map['occupation'] ?? '',
      qualification: map['qualification'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      bloodGroup: map['bloodGroup'],
      profilePhoto: map['profilePhoto'],
      address: map['address'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      treePosition: map['treePosition'] != null
          ? Map<String, double>.from(map['treePosition'])
          : null,
      generation: map['generation']?.toInt() ?? 1,
      parentId: map['parentId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyMemberModel.fromJson(String source) =>
      FamilyMemberModel.fromMap(json.decode(source));

  FamilyMemberModel copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    int? age,
    String? gender,
    String? maritalStatus,
    String? relationship,
    String? occupation,
    String? qualification,
    String? phone,
    String? email,
    String? bloodGroup,
    String? profilePhoto,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, double>? treePosition,
    int? generation,
    String? parentId,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      relationship: relationship ?? this.relationship,
      occupation: occupation ?? this.occupation,
      qualification: qualification ?? this.qualification,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      treePosition: treePosition ?? this.treePosition,
      generation: generation ?? this.generation,
      parentId: parentId ?? this.parentId,
    );
  }
}
