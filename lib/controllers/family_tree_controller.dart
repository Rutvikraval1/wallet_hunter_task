import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

import '../models/family_member_model.dart';
import './family_controller.dart';

class FamilyTreeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isExporting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedMemberId = ''.obs;
  final RxDouble currentZoom = 1.0.obs;
  final RxBool showExportOptions = false.obs;

  final FamilyController _familyController = Get.find<FamilyController>();
  final GlobalKey familyTreeKey = GlobalKey();

  List<Map<String, dynamic>> get treeData {
    final List<Map<String, dynamic>> members = [];

    // Add family head
    if (_familyController.familyHead.value != null) {
      final head = _familyController.familyHead.value!;
      members.add({
        'id': head.id,
        'firstName': head.firstName,
        'middleName': head.middleName,
        'lastName': head.lastName,
        'relation': 'Family Head',
        'age': head.age,
        'gender': head.gender,
        'profilePhoto': head.profilePhoto,
        'position': {'x': 0.0, 'y': 0.0},
        'generation': 0,
        'parentId': null,
        'occupation': head.occupation,
        'maritalStatus': head.maritalStatus,
      });
    }

    // Add family members
    for (var member in _familyController.familyMembers) {
      members.add({
        'id': member.id,
        'firstName': member.firstName,
        'middleName': member.middleName,
        'lastName': member.lastName,
        'relation': member.relationship,
        'age': member.age,
        'gender': member.gender,
        'profilePhoto': member.profilePhoto,
        'position': member.treePosition ?? _calculatePosition(member),
        'generation': member.generation,
        'parentId': member.parentId,
        'occupation': member.occupation,
        'maritalStatus': member.maritalStatus,
      });
    }

    return members;
  }

  Map<String, double> _calculatePosition(FamilyMemberModel member) {
    double x = 0.0;
    double y = 0.0;

    switch (member.generation) {
      case -1: // Parents
        x = member.gender == 'Male' ? -120.0 : 120.0;
        y = -100.0;
        break;
      case 0: // Spouse
        x = 150.0;
        y = 0.0;
        break;
      case 1: // Children
        final childIndex = _familyController.familyMembers
            .where((m) => m.generation == 1)
            .toList()
            .indexOf(member);
        x = (childIndex * 100.0) - 50.0;
        y = 120.0;
        break;
      case 2: // Grandchildren
        final grandChildIndex = _familyController.familyMembers
            .where((m) => m.generation == 2)
            .toList()
            .indexOf(member);
        x = (grandChildIndex * 80.0) - 40.0;
        y = 220.0;
        break;
    }

    return {'x': x, 'y': y};
  }

  void selectMember(String memberId) {
    selectedMemberId.value = selectedMemberId.value == memberId ? '' : memberId;
  }

  void updateZoom(double zoom) {
    currentZoom.value = zoom;
  }

  void toggleExportOptions() {
    showExportOptions.value = !showExportOptions.value;
  }

  Future<void> exportToPDF() async {
    if (await _requestStoragePermission()) {
      isExporting.value = true;
      errorMessage.value = '';

      try {
        final pdf = pw.Document();

        // Add family tree page
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text(
                      'Family Tree - ${_familyController.familyHead.value?.fullName ?? "Unknown"}',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Generated on: ${DateTime.now().toString().split('.')[0]}',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 30),
                  _buildPDFFamilyTree(),
                ],
              );
            },
          ),
        );

        // Save PDF
        final output = await getApplicationDocumentsDirectory();
        final file = File('${output.path}/family_tree.pdf');
        await file.writeAsBytes(await pdf.save());

        Get.snackbar(
          'Success',
          'Family tree exported to PDF successfully!',
          snackPosition: SnackPosition.TOP,
        );

        // Open PDF
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save());
      } catch (e) {
        errorMessage.value = 'Failed to export PDF: $e';
        Get.snackbar(
          'Error',
          'Failed to export PDF',
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isExporting.value = false;
        showExportOptions.value = false;
      }
    }
  }

  Future<void> exportToImage() async {
    if (await _requestStoragePermission()) {
      isExporting.value = true;
      errorMessage.value = '';

      try {
        // Capture widget as image
        RenderRepaintBoundary boundary = familyTreeKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Save image
        final output = await getApplicationDocumentsDirectory();
        final file = File('${output.path}/family_tree.png');
        await file.writeAsBytes(pngBytes);

        Get.snackbar(
          'Success',
          'Family tree exported to image successfully!',
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        errorMessage.value = 'Failed to export image: $e';
        Get.snackbar(
          'Error',
          'Failed to export image',
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isExporting.value = false;
        showExportOptions.value = false;
      }
    }
  }

  pw.Widget _buildPDFFamilyTree() {
    return pw.Container(
      width: double.infinity,
      height: 400,
      child: pw.Stack(
        children: treeData.map((member) {
          final position = member['position'] as Map<String, dynamic>;
          return pw.Positioned(
            left: 200 + (position['x'] as double),
            top: 100 + (position['y'] as double),
            child: pw.Container(
              width: 100,
              height: 120,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 40,
                    height: 40,
                    decoration: pw.BoxDecoration(
                      color: member['gender'] == 'Male'
                          ? PdfColors.blue100
                          : PdfColors.pink100,
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        '${member['firstName']}'.substring(0, 1).toUpperCase(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    '${member['firstName']} ${member['lastName']}',
                    style: pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    '${member['relation']}',
                    style: pw.TextStyle(fontSize: 6),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit storage permission for app documents
  }

  void clearErrorMessage() {
    errorMessage.value = '';
  }
}
