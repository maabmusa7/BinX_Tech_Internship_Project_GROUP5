import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreed = false;

  // ✅ منطق إنشاء الحساب
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ✅ دالة إنشاء الحساب (استبدلت _onCreateAccount)
  Future<void> _handleCreateAccount() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service and Privacy Policy'),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }
    if (password.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        fullName: name,
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.placementQuiz);
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.loginBackground, AppColors.background],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const _Logo(),
                    const SizedBox(height: 28),
                    _buildCard(),
                    const SizedBox(height: 24),
                    _buildLoginRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Full Name'),
          const SizedBox(height: 8),
          _InputField(
            controller: _nameController,
            hint: 'Alex Morgan',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          _label('Email Address'),
          const SizedBox(height: 8),
          _InputField(
            controller: _emailController,
            hint: 'alex@example.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _label('Password'),
          const SizedBox(height: 8),
          _InputField(
            controller: _passwordController,
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.hintText,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                'Must be at least 8 characters',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _label('Confirm Password'),
          const SizedBox(height: 8),
          _InputField(
            controller: _confirmController,
            hint: '••••••••',
            icon: Icons.verified_user_outlined,
            obscure: _obscureConfirm,
            suffix: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.hintText,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 18),
          _buildAgreementRow(),
          const SizedBox(height: 20),

          // ✅ رسالة الخطأ فوق الزر
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12.5),
                textAlign: TextAlign.center,
              ),
            ),

          // ✅ زر Create Account (بعد التعديل)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleCreateAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: AppColors.buttonShadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Create Account',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            activeColor: AppColors.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: AppColors.textMuted,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: افتحي صفحة الـ Terms
                    },
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: افتحي صفحة الـ Privacy Policy
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      );

  Widget _buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?  ',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Log In',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/elio_logo.png',
      height: 90,
      errorBuilder: (_, __, ___) => Text(
        'ELIO',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 52,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.iconCircle,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.hintText,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}