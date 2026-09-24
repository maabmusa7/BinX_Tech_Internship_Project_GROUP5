import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dailyReminder = true;
  bool _soundEffects = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ELIO',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    )),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.iconCircle,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Icons.person,
                      color: AppColors.primary, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                children: [
                  const _UserRow(
                    name: 'KAREMAN ABUBAKER',
                    subtitle: 'elio user',
                  ),
                  const SizedBox(height: 14),
                  _SettingsCard(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    children: [
                      _ToggleRow(
                        title: 'Daily Speaking Reminder',
                        subtitle: 'Gentle audio practice prompt',
                        trailingTime: '8:30 AM',
                        value: _dailyReminder,
                        onChanged: (v) => setState(() => _dailyReminder = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    icon: Icons.volume_up_outlined,
                    title: 'Sound',
                    children: [
                      _ToggleRow(
                        title: 'Sound Effects',
                        subtitle: 'Play sounds for correct pronunciation',
                        value: _soundEffects,
                        onChanged: (v) => setState(() => _soundEffects = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    icon: Icons.mic_none_rounded,
                    title: 'Microphone & Audio',
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Microphone Permission',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    )),
                                SizedBox(height: 2),
                                Text('Manage in system settings',
                                    style: TextStyle(
                                        fontSize: 10.5,
                                        color: AppColors.primary)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Granted',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    children: [
                      _LinkRow(
                          label: 'Privacy Policy',
                          onTap: () {
                            // TODO
                          }),
                      const Divider(height: 20, color: AppColors.cardBorder),
                      _LinkRow(
                          label: 'Terms of Service',
                          onTap: () {
                            // TODO
                          }),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lock_outline_rounded,
                              size: 13, color: AppColors.textGrey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Your conversations are used only to '
                              'improve your feedback. Not shared with '
                              'third parties.',
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textGrey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _UserRow extends StatelessWidget {
  final String name;
  final String subtitle;

  const _UserRow({required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 10.5, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.iconCircle,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right,
                size: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SettingsCard({
    required this.icon,
    required this.title,
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
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailingTime;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    this.trailingTime,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  )),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 10.5, color: AppColors.textGrey)),
            ],
          ),
        ),
        if (trailingTime != null) ...[
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 12, color: AppColors.textGrey),
              const SizedBox(width: 3),
              Text(trailingTime!,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(width: 10),
        ],
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: AppColors.hintText,
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              )),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.textGrey),
        ],
      ),
    );
  }
}