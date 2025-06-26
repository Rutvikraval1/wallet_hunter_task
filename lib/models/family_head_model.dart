import 'dart:convert';

class FamilyHeadModel {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final int age;
  final String gender;
  final String maritalStatus;
  final String occupation;
  final String qualification;
  final String phone;
  final String email;
  final String address;
  final String samaj;
  final String? temple;
  final String? profilePhoto;
  final String? bloodGroup;
  final DateTime dateOfBirth;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final List<String> familyMemberIds;

  FamilyHeadModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.occupation,
    required this.qualification,
    required this.phone,
    required this.email,
    required this.address,
    required this.samaj,
    this.temple,
    this.profilePhoto,
    this.bloodGroup,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.familyMemberIds = const [],
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
      'occupation': occupation,
      'qualification': qualification,
      'phone': phone,
      'email': email,
      'address': address,
      'samaj': samaj,
      'temple': temple,
      'profilePhoto': profilePhoto,
      'bloodGroup': bloodGroup,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isVerified': isVerified,
      'familyMemberIds': familyMemberIds,
    };
  }

  factory FamilyHeadModel.fromMap(Map<String, dynamic> map) {
    return FamilyHeadModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      occupation: map['occupation'] ?? '',
      qualification: map['qualification'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      samaj: map['samaj'] ?? '',
      temple: map['temple'],
      profilePhoto: map['profilePhoto'],
      bloodGroup: map['bloodGroup'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      isVerified: map['isVerified'] ?? false,
      familyMemberIds: List<String>.from(map['familyMemberIds'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyHeadModel.fromJson(String source) =>
      FamilyHeadModel.fromMap(json.decode(source));

  FamilyHeadModel copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    int? age,
    String? gender,
    String? maritalStatus,
    String? occupation,
    String? qualification,
    String? phone,
    String? email,
    String? address,
    String? samaj,
    String? temple,
    String? profilePhoto,
    String? bloodGroup,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    List<String>? familyMemberIds,
  }) {
    return FamilyHeadModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
      qualification: qualification ?? this.qualification,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      samaj: samaj ?? this.samaj,
      temple: temple ?? this.temple,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      familyMemberIds: familyMemberIds ?? this.familyMemberIds,
    );
  }
}
