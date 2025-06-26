import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = true;
  bool _showRetry = false;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Simulate checking authentication status
      await _updateLoadingText('Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate loading community configurations
      await _updateLoadingText('Loading community data...');
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulate syncing temple associations
      await _updateLoadingText('Syncing temple associations...');
      await Future.delayed(const Duration(milliseconds: 700));

      // Simulate preparing cached family data
      await _updateLoadingText('Preparing family data...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Check authentication status and navigate accordingly
      await _checkAuthenticationAndNavigate();
    } catch (e) {
      _handleInitializationError();
    }
  }

  Future<void> _updateLoadingText(String text) async {
    if (mounted) {
      setState(() {
        _loadingText = text;
      });
    }
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    // Mock authentication check
    final bool isAuthenticated = await _mockAuthenticationCheck();
    final bool isNewUser = await _mockNewUserCheck();

    if (mounted) {
      if (isAuthenticated) {
        // Navigate to dashboard for authenticated family heads
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
      } else if (isNewUser) {
        // Navigate to registration flow for new users
        Navigator.pushReplacementNamed(
            context, '/family-head-registration-screen');
      } else {
        // Navigate to OTP verification for returning users
        Navigator.pushReplacementNamed(context, '/otp-authentication-screen');
      }
    }
  }

  Future<bool> _mockAuthenticationCheck() async {
    // Simulate network call with potential timeout
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock: 30% chance user is authenticated
    return DateTime.now().millisecond % 10 < 3;
  }

  Future<bool> _mockNewUserCheck() async {
    // Simulate checking if user is new
    await Future.delayed(const Duration(milliseconds: 200));
    // Mock: 40% chance user is new
    return DateTime.now().millisecond % 10 < 4;
  }

  void _handleInitializationError() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _showRetry = true;
        _loadingText = 'Connection failed';
      });

      // Auto-retry after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _showRetry) {
          _retryInitialization();
        }
      });
    }
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _showRetry = false;
      _loadingText = 'Retrying...';
    });
    _startInitialization();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppTheme.primaryLight,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryLight,
                AppTheme.primaryVariantLight,
                AppTheme.secondaryLight.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildLogoSection(),
                ),
                Expanded(
                  flex: 1,
                  child: _buildLoadingSection(),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppLogo(),
                  SizedBox(height: 3.h),
                  _buildAppTitle(),
                  SizedBox(height: 1.h),
                  _buildAppSubtitle(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'account_tree',
          color: Colors.white,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      'Wallet Hunter',
      style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAppSubtitle() {
    return Text(
      'Family Heritage & Community Connection',
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: Colors.white.withValues(alpha: 0.9),
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _showRetry ? _buildRetrySection() : _buildLoadingIndicator(),
        SizedBox(height: 2.h),
        _buildLoadingText(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return _isLoading
        ? SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.8),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildRetrySection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'refresh',
          color: Colors.white.withValues(alpha: 0.8),
          size: 8.w,
        ),
        SizedBox(height: 1.h),
        TextButton(
          onPressed: _retryInitialization,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _loadingText,
        key: ValueKey(_loadingText),
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
