import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_me.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  final _authService = AuthService();

  UserMe? _me;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final me = await _userService.getMe();
      setState(() => _me = me);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editName() async {
    if (_me == null) return;
    final controller = TextEditingController(text: _me!.fullName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Full Name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (newName == null || newName.isEmpty || newName == _me!.fullName) {
      return;
    }
    try {
      await _userService.updateProfile(userId: _me!.id, fullName: newName);
      await _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update your name.')),
      );
    }
  }

  Future<void> _changePassword() async {
    if (_me == null) return;
    final currentController = TextEditingController();
    final newController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current password'),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'New password (min 8 chars)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
    );

    if (confirmed != true) return;
    if (newController.text.length < 8) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('New password must be at least 8 characters')),
      );
      return;
    }

    try {
      await _userService.changePassword(
        userId: _me!.id,
        currentPassword: currentController.text,
        newPassword: newController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not change password.')),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _ProfileHeaderCard(me: _me),
            const SizedBox(height: 20),
            _InfoCard(
              icon: Icons.person_outline,
              title: 'Personal Information',
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.primary),
                onPressed: _editName,
              ),
              children: [
                _InfoLine(label: 'Full Name', value: _me?.fullName ?? '-'),
                _InfoLine(
                    label: 'Email Address',
                    value: _me?.email ?? '-',
                    valueColor: AppColors.primary),
              ],
            ),
            const SizedBox(height: 14),
            _InfoCard(
              icon: Icons.school_outlined,
              title: 'English Level',
              trailingBadge: _me?.level,
              children: [
                _InfoLine(label: 'CEFR Level', value: _me?.cefrLevel ?? '-'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _changePassword,
                icon: const Icon(Icons.lock_outline, size: 16),
                label: const Text('Change Password'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded,
                    size: 16, color: Color(0xFFE53935)),
                label: const Text('Log Out of ELIO',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE53935),
                    )),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE53935).withValues(alpha: 0.08),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ProfileHeaderCard extends StatelessWidget {
  final UserMe? me;
  const _ProfileHeaderCard({required this.me});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 10),
          Text(me?.fullName ?? '-',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 2),
          Text(me?.email ?? '-',
              style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(me?.level ?? '-',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 12, color: Color(0xFFB4790B)),
                    const SizedBox(width: 3),
                    Text('${me?.currentStreak ?? 0} Day Streak',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB4790B),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingBadge;
  final Widget? trailing;
  final List<Widget> children;

  const _InfoCard({
    required this.icon,
    required this.title,
    this.trailingBadge,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 15, color: AppColors.primary),
                  const SizedBox(width: 7),
                  Text(title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      )),
                ],
              ),
              if (trailing != null) trailing!,
              if (trailingBadge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.iconCircle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(trailingBadge!,
                      style: const TextStyle(
                          fontSize: 9.5, color: AppColors.primary)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoLine({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey)),
          Text(value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textDark,
              )),
        ],
      ),
    );
  }
}