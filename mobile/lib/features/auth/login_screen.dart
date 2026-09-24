import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../core/constants/app_routes.dart';

/// ألوان التصميم (قيمها تقريبية من الصورة، عدّلها من Figma Dev Mode)
class AppColors {
  static const primary = Color(0xFF3B2A7A);
  static const accent = Color(0xFF7B55D6);
  static const fieldBg = Color(0xFFF1EEFB);
  static const hint = Color(0xFFA9A6B8);
  static const text = Color(0xFF2B2450);
  static const orange = Color(0xFFE8961E);
  static const bgTop = Color(0xFFDCD3FA);
  static const bgBottom = Color(0xFFF6F0FF);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  // ✅ منطق تسجيل الدخول
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ دالة تسجيل الدخول
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email and password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(email: email, password: password);
      if (!mounted) return;
      // ✅ بعد التعديل: mainShell بدل home
      Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
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
                    const SizedBox(height: 40),
                    const _Logo(),
                    const SizedBox(height: 40),
                    _buildCard(textTheme),
                    const SizedBox(height: 28),
                    _buildSignUpRow(textTheme),
                    const SizedBox(height: 28),
                    const _DidYouKnowCard(),
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

  Widget _buildCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Email Address'),
          const SizedBox(height: 8),
          _InputField(
            controller: _emailController,
            hint: 'alex@example.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          _label('Password'),
          const SizedBox(height: 8),
          _InputField(
            controller: _passwordController,
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: _obscure,
            suffix: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.hint,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {/* TODO: نسيت كلمة المرور */},
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12.5),
                textAlign: TextAlign.center,
              ),
            ),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: AppColors.primary.withValues(alpha: 0.4),
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
                        Text('Log In',
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
          const SizedBox(height: 18),
          _buildDivider(),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  label: 'Google',
                  iconAsset: 'assets/icons/google.png',
                  fallbackIcon: Icons.g_mobiledata_rounded,
                  onTap: () {/* TODO: Google */},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SocialButton(
                  label: 'Apple',
                  fallbackIcon: Icons.apple,
                  onTap: () {/* TODO: Apple */},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      );

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(color: AppColors.hint.withOpacity(0.3)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'OR CONTINUE WITH',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              color: AppColors.text.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpRow(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?  ",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.text.withOpacity(0.8),
          ),
        ),
        GestureDetector(
          onTap: () {/* TODO: التسجيل */},
          child: Text(
            'Sign Up',
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

/// اللوغو: بيقرأ الصورة المصدّرة، وإذا مش موجودة بيعرض نص مؤقت
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/elio_logo.png',
      height: 100,
      errorBuilder: (_, __, ___) => Text(
        'ELIO',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 56,
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
        color: AppColors.fieldBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE6DFFA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.hint,
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

class _SocialButton extends StatelessWidget {
  final String label;
  final String? iconAsset;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.fallbackIcon,
    required this.onTap,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(fallbackIcon, size: 22, color: AppColors.text);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 1.5,
      shadowColor: AppColors.primary.withOpacity(0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconAsset != null)
                Image.asset(
                  iconAsset!,
                  width: 18,
                  height: 18,
                  errorBuilder: (_, __, ___) => fallback,
                )
              else
                fallback,
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DidYouKnowCard extends StatelessWidget {
  const _DidYouKnowCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE9C2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline_rounded,
                size: 18, color: AppColors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DID YOU KNOW?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Practicing for just 4 minutes right after waking up '
                  'anchors fluency memory 2.4× faster.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.text.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}