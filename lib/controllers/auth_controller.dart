import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_export.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isOtpSent = false.obs;
  final RxBool canResendOtp = false.obs;
  final RxInt resendCountdown = 30.obs;
  final RxString errorMessage = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString otp = ''.obs;
  final RxBool isAuthenticated = false.obs;

  Timer? _countdownTimer;

  // Mock credentials for testing
  final String _mockPhoneNumber = '9876543210';
  final String _mockOtp = '123456';

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isAuthenticated.value = prefs.getBool('isAuthenticated') ?? false;
  }

  void updatePhoneNumber(String phone) {
    phoneNumber.value = phone;
    errorMessage.value = '';
  }

  void updateOtp(String otpValue) {
    otp.value = otpValue;
    errorMessage.value = '';
  }

  Future<void> sendOtp() async {
    final phone = phoneNumber.value.replaceAll('+91 ', '').trim();

    if (phone.length != 10) {
      errorMessage.value = 'Please enter a valid 10-digit mobile number';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (phone == _mockPhoneNumber) {
        isOtpSent.value = true;
        _startResendCountdown();
      } else {
        errorMessage.value =
            'Phone number not registered. Please use $_mockPhoneNumber for testing.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to send OTP. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != 6) {
      errorMessage.value = 'Please enter the complete 6-digit OTP';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (otp.value == _mockOtp) {
        await _saveAuthState();
        isAuthenticated.value = true;
        Get.offAllNamed(AppRoutes.familyHeadRegistrationScreen);
      } else {
        errorMessage.value = 'Invalid OTP. Please use $_mockOtp for testing.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResendOtp.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _startResendCountdown();
    } catch (e) {
      errorMessage.value = 'Failed to resend OTP. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendCountdown() {
    canResendOtp.value = false;
    resendCountdown.value = 30;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResendOtp.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userPhone', phoneNumber.value);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isAuthenticated.value = false;
    isOtpSent.value = false;
    phoneNumber.value = '';
    otp.value = '';
    errorMessage.value = '';
    _countdownTimer?.cancel();
    Get.offAllNamed(AppRoutes.splashScreen);
  }

  void resetToPhoneInput() {
    isOtpSent.value = false;
    otp.value = '';
    errorMessage.value = '';
    _countdownTimer?.cancel();
  }
}
