import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/family_head_model.dart';
import '../models/family_member_model.dart';

class FamilyController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<FamilyHeadModel?> familyHead = Rx<FamilyHeadModel?>(null);
  final RxList<FamilyMemberModel> familyMembers = <FamilyMemberModel>[].obs;

  // Auto-linking data
  final RxList<String> availableSamaj = <String>[
    'Brahmin Samaj',
    'Kshatriya Samaj',
    'Vaishya Samaj',
    'Shudra Samaj',
    'Arya Samaj',
    'Other'
  ].obs;

  final RxList<String> availableTemples = <String>[
    'Shree Krishna Temple',
    'Hanuman Mandir',
    'Shiva Temple',
    'Durga Mata Temple',
    'Ganesh Temple',
    'Other'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadFamilyData();
  }

  // Auto-linking logic for Samaj based on surname and region
  List<String> getRecommendedSamaj(String lastName, String address) {
    final List<String> recommended = [];

    // Simple logic based on common surnames
    if (lastName.toLowerCase().contains('sharma') ||
        lastName.toLowerCase().contains('mishra') ||
        lastName.toLowerCase().contains('tiwari')) {
      recommended.add('Brahmin Samaj');
    } else if (lastName.toLowerCase().contains('singh') ||
        lastName.toLowerCase().contains('rajput')) {
      recommended.add('Kshatriya Samaj');
    } else if (lastName.toLowerCase().contains('gupta') ||
        lastName.toLowerCase().contains('agarwal')) {
      recommended.add('Vaishya Samaj');
    }

    // Add regional recommendations
    if (address.toLowerCase().contains('gujarat')) {
      recommended.add('Arya Samaj');
    }

    return recommended.isEmpty ? ['Other'] : recommended;
  }

  // Auto-linking logic for Temples based on location
  List<String> getRecommendedTemples(String address, String samaj) {
    final List<String> recommended = [];

    // Location-based recommendations
    if (address.toLowerCase().contains('mumbai') ||
        address.toLowerCase().contains('maharashtra')) {
      recommended.addAll(['Shree Krishna Temple', 'Ganesh Temple']);
    } else if (address.toLowerCase().contains('delhi') ||
        address.toLowerCase().contains('rajasthan')) {
      recommended.addAll(['Hanuman Mandir', 'Shiva Temple']);
    }

    // Samaj-based recommendations
    if (samaj == 'Brahmin Samaj') {
      recommended.add('Shiva Temple');
    } else if (samaj == 'Kshatriya Samaj') {
      recommended.add('Hanuman Mandir');
    }

    return recommended.isEmpty ? ['Other'] : recommended;
  }

  Future<void> saveFamilyHead(Map<String, dynamic> formData) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final now = DateTime.now();
      final familyHeadData = FamilyHeadModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: formData['personalInfo']['firstName'] ?? '',
        middleName: formData['personalInfo']['middleName'] ?? '',
        lastName: formData['personalInfo']['lastName'] ?? '',
        age: int.tryParse(formData['personalInfo']['age'] ?? '0') ?? 0,
        gender: formData['personalInfo']['gender'] ?? '',
        maritalStatus: formData['personalInfo']['maritalStatus'] ?? '',
        occupation: formData['personalInfo']['occupation'] ?? '',
        qualification: formData['personalInfo']['qualification'] ?? '',
        phone: formData['contactInfo']['phone'] ?? '',
        email: formData['contactInfo']['email'] ?? '',
        address: formData['addressInfo']['fullAddress'] ?? '',
        samaj: formData['personalInfo']['samaj'] ?? '',
        temple: formData['personalInfo']['temple'],
        dateOfBirth:
            DateTime.tryParse(formData['personalInfo']['dateOfBirth'] ?? '') ??
                now,
        createdAt: now,
        updatedAt: now,
        isVerified: true,
      );

      familyHead.value = familyHeadData;
      await _saveFamilyDataToStorage();

      Get.snackbar(
        'Success',
        'Family Head Registration Completed Successfully!',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      errorMessage.value = 'Failed to save family head data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFamilyMember(Map<String, dynamic> memberData) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final now = DateTime.now();
      final member = FamilyMemberModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: memberData['firstName'] ?? '',
        middleName: memberData['middleName'] ?? '',
        lastName: memberData['lastName'] ?? '',
        age: int.tryParse(memberData['age']?.toString() ?? '0') ?? 0,
        gender: memberData['gender'] ?? '',
        maritalStatus: memberData['maritalStatus'] ?? '',
        relationship: memberData['relationship'] ?? '',
        occupation: memberData['occupation'] ?? '',
        qualification: memberData['qualification'] ?? '',
        phone: memberData['phone'] ?? '',
        email: memberData['email'] ?? '',
        bloodGroup: memberData['bloodGroup'],
        profilePhoto: memberData['profilePhoto'],
        address: memberData['address'],
        createdAt: now,
        updatedAt: now,
        generation: _calculateGeneration(memberData['relationship']),
        parentId: familyHead.value?.id,
      );

      familyMembers.add(member);
      await _saveFamilyDataToStorage();
    } catch (e) {
      errorMessage.value = 'Failed to add family member: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFamilyMember(
      String memberId, Map<String, dynamic> memberData) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final index = familyMembers.indexWhere((member) => member.id == memberId);
      if (index != -1) {
        final updatedMember = familyMembers[index].copyWith(
          firstName: memberData['firstName'],
          middleName: memberData['middleName'],
          lastName: memberData['lastName'],
          age: int.tryParse(memberData['age']?.toString() ?? '0'),
          gender: memberData['gender'],
          maritalStatus: memberData['maritalStatus'],
          relationship: memberData['relationship'],
          occupation: memberData['occupation'],
          qualification: memberData['qualification'],
          phone: memberData['phone'],
          email: memberData['email'],
          bloodGroup: memberData['bloodGroup'],
          profilePhoto: memberData['profilePhoto'],
          address: memberData['address'],
          updatedAt: DateTime.now(),
        );

        familyMembers[index] = updatedMember;
        await _saveFamilyDataToStorage();
      }
    } catch (e) {
      errorMessage.value = 'Failed to update family member: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFamilyMember(String memberId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      familyMembers.removeWhere((member) => member.id == memberId);
      await _saveFamilyDataToStorage();
    } catch (e) {
      errorMessage.value = 'Failed to delete family member: $e';
    } finally {
      isLoading.value = false;
    }
  }

  int _calculateGeneration(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'father':
      case 'mother':
      case 'parent':
        return -1;
      case 'spouse':
      case 'husband':
      case 'wife':
        return 0;
      case 'son':
      case 'daughter':
      case 'child':
        return 1;
      case 'grandson':
      case 'granddaughter':
      case 'grandchild':
        return 2;
      default:
        return 0;
    }
  }

  Future<void> loadFamilyData() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load family head
      final familyHeadJson = prefs.getString('familyHead');
      if (familyHeadJson != null) {
        familyHead.value = FamilyHeadModel.fromJson(familyHeadJson);
      }

      // Load family members
      final familyMembersJson = prefs.getString('familyMembers');
      if (familyMembersJson != null) {
        final List<dynamic> membersList = json.decode(familyMembersJson);
        familyMembers.value = membersList
            .map((member) => FamilyMemberModel.fromMap(member))
            .toList();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load family data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveFamilyDataToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save family head
      if (familyHead.value != null) {
        await prefs.setString('familyHead', familyHead.value!.toJson());
      }

      // Save family members
      final membersJson =
          json.encode(familyMembers.map((member) => member.toMap()).toList());
      await prefs.setString('familyMembers', membersJson);
    } catch (e) {
      throw Exception('Failed to save family data: $e');
    }
  }

  void clearErrorMessage() {
    errorMessage.value = '';
  }
}
