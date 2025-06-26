
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/number_pad_widget.dart';
import './widgets/otp_input_widget.dart';
import './widgets/phone_input_widget.dart';

class OtpAuthenticationScreen extends StatelessWidget {
  const OtpAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController phoneController =
        TextEditingController(text: '+91 ');
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      // App Logo/Branding
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'family_restroom',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 10.w,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Wallet Hunter',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'समुदाय परिवार पंजीकरण',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.9),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        authController.isOtpSent.value
                            ? 'Enter Verification Code'
                            : 'Welcome to Community Registration',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Input or OTP Input
                        authController.isOtpSent.value
                            ? OtpInputWidget(
                                controller: otpController,
                                onChanged: (value) {
                                  authController.updateOtp(value);
                                },
                              )
                            : PhoneInputWidget(
                                controller: phoneController,
                                onChanged: (value) {
                                  authController.updatePhoneNumber(value);
                                },
                              ),

                        SizedBox(height: 2.h),

                        // Error Message
                        if (authController.errorMessage.value.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(4.w),
                            margin: EdgeInsets.only(bottom: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'error_outline',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 5.w,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    authController.errorMessage.value,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 7.h,
                          child: ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : () {
                                    if (authController.isOtpSent.value) {
                                      authController.verifyOtp();
                                    } else {
                                      authController.updatePhoneNumber(
                                          phoneController.text);
                                      authController.sendOtp();
                                    }
                                  },
                            child: authController.isLoading.value
                                ? SizedBox(
                                    width: 6.w,
                                    height: 6.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Text(
                                    authController.isOtpSent.value
                                        ? 'Verify OTP'
                                        : 'Send OTP',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        // Resend OTP Section
                        if (authController.isOtpSent.value) ...[
                          SizedBox(height: 3.h),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Didn\'t receive the code?',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                TextButton(
                                  onPressed:
                                      authController.canResendOtp.value &&
                                              !authController.isLoading.value
                                          ? authController.resendOtp
                                          : null,
                                  child: Text(
                                    authController.canResendOtp.value
                                        ? 'Resend OTP'
                                        : 'Resend in ${authController.resendCountdown.value}s',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: authController.canResendOtp.value
                                          ? AppTheme.lightTheme.primaryColor
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Back Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: TextButton.icon(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (authController.isOtpSent.value) {
                              authController.resetToPhoneInput();
                              otpController.clear();
                              phoneController.text = '+91 ';
                            } else {
                              Get.offAllNamed(AppRoutes.splashScreen);
                            }
                          },
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    ),
                    label: Text(
                      authController.isOtpSent.value
                          ? 'Change Phone Number'
                          : 'Back to Home',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
