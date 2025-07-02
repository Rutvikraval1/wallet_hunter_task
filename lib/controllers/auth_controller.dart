import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _countdownTimer;

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
    print("updatePhoneNumber : $phone");
    phoneNumber.value = phone;
    errorMessage.value = '';
  }

  void updateOtp(String otpValue) {
    print("otpValue : $otpValue");
    otp.value = otpValue;
    errorMessage.value = '';
  }

  Future<void> sendOtp() async {
    print("phoneNumber.value ${phoneNumber.value}");
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
      await _auth.verifyPhoneNumber(
          timeout: const Duration(minutes: 2),
          phoneNumber: phoneNumber.value,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            print("FirebaseAuthException");
            print(e);
            errorMessage.value = 'Failed to send OTP. Please try again.';
          },
          codeSent: (String verif_Id, int? resendToken) async {
            isOtpSent.value = true;
            verificationId.value = verif_Id;
            resendTokenId.value = resendToken ?? 0;
            _startResendCountdown();
            isLoading.value = false;
          },
          codeAutoRetrievalTimeout: (String verifId) {
            verificationId.value = verifId;
          });
    } catch (e) {
      errorMessage.value = 'Failed to send OTP. Please try again.';
    }
  }

  RxString verificationId = "".obs;
  RxInt resendTokenId = 0.obs;

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
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp.value,
      );
      if(credential!=null){
        await _saveAuthState();
        isAuthenticated.value = true;
        Get.offAllNamed(AppRoutes.dashboardScreen);
      }

      // final result = await _auth.signInWithCredential(credential);
      // print("result : ${result.user}");
    } catch (e) {
      print("error : $e");
      errorMessage.value = 'Failed to verify OTP. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResendOtp.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    final phone =
        phoneNumber.value.replaceAll('+91', '').replaceAll(' ', '').trim();
    if (phone.length != 10) {
      errorMessage.value = 'Invalid phone number';
      isLoading.value = false;
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        timeout: const Duration(seconds: 60),
        forceResendingToken:
            resendTokenId.value == 0 ? null : resendTokenId.value,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-complete (optional)
        },
        verificationFailed: (FirebaseAuthException e) {
          errorMessage.value = 'Resend failed: ${e.message ?? 'Unknown error'}';
        },
        codeSent: (String verifId, int? token) {
          verificationId.value = verifId;
          resendTokenId.value = token ?? 0;
          _startResendCountdown();
        },
        codeAutoRetrievalTimeout: (String verifId) {
          verificationId.value = verifId;
        },
      );
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
