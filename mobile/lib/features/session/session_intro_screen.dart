import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/session_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/topic.dart';

class SessionIntroScreen extends StatefulWidget {
  final Topic topic;

  const SessionIntroScreen({super.key, required this.topic});

  @override
  State<SessionIntroScreen> createState() => _SessionIntroScreenState();
}

class _SessionIntroScreenState extends State<SessionIntroScreen> {
  final _sessionService = SessionService();
  bool _voiceOn = true;
  bool _voiceMode = false; // بنبدأ بـ Text Hybrid لأنو هو الشغال حاليًا
  bool _isStarting = false;

  Future<void> _startConversation() async {
    setState(() => _isStarting = true);
    try {
      final result = await _sessionService.startSession(widget.topic.id);
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.sessionPractice,
        arguments: result,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start the session. Retry.')),
      );
    } finally {
      if (mounted) setState(() => _isStarting = false);
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _TopBar(
                  topicTitle: widget.topic.name,
                  levelLabel: widget.topic.difficulty,
                  voiceOn: _voiceOn,
                  onBack: () => Navigator.maybePop(context),
                  onToggleVoice: () => setState(() => _voiceOn = !_voiceOn),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const _MascotThinking(),
                        const SizedBox(height: 18),
                        const Text('Ready to speak?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            )),
                        const SizedBox(height: 8),
                        const Text(
                          'Take a relaxed breath. ELIO is tuned to your '
                          'tempo and ready for a cozy chat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _SessionInfoCard(
                          topicName: widget.topic.name,
                          missionText: widget.topic.sessionMission,
                        ),
                        const SizedBox(height: 20),
                        _ModeToggle(
                          voiceMode: _voiceMode,
                          onChanged: (v) => setState(() => _voiceMode = v),
                        ),
                        if (_voiceMode)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Voice mode is coming soon — please use Text '
                              'Hybrid for now.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.5, color: AppColors.textGrey),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isStarting ? null : _startConversation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: AppColors.buttonShadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: _isStarting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.headset_mic_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Start Conversation',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final String topicTitle;
  final String levelLabel;
  final bool voiceOn;
  final VoidCallback onBack;
  final VoidCallback onToggleVoice;

  const _TopBar({
    required this.topicTitle,
    required this.levelLabel,
    required this.voiceOn,
    required this.onBack,
    required this.onToggleVoice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.pill,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back,
                size: 17, color: AppColors.textDark),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.pill,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_cafe_outlined,
                    size: 13, color: AppColors.primary),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(topicTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      )),
                ),
                const SizedBox(width: 6),
                const Text('•',
                    style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                const SizedBox(width: 6),
                Text(levelLabel,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onToggleVoice,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.pill,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  voiceOn
                      ? Icons.volume_up_outlined
                      : Icons.volume_off_outlined,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(voiceOn ? 'Voice On' : 'Voice Off',
                    style: const TextStyle(
                        fontSize: 10.5, color: AppColors.textDark)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MascotThinking extends StatelessWidget {
  const _MascotThinking();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: Image.asset(
              'assets/images/mascot_thinking.png',
              errorBuilder: (_, __, ___) => const Icon(
                Icons.headset_mic_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionInfoCard extends StatelessWidget {
  final String topicName;
  final String missionText;

  const _SessionInfoCard(
      {required this.topicName, required this.missionText});

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
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_cafe_outlined,
                    size: 15, color: Color(0xFFB4790B)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(topicName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.flag_outlined,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Session Mission',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 3),
                    Text(missionText,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: AppColors.textGrey,
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

class _ModeToggle extends StatelessWidget {
  final bool voiceMode;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({required this.voiceMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              icon: Icons.mic_none_rounded,
              label: 'Voice Dialogue',
              selected: voiceMode,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ModeButton(
              icon: Icons.keyboard_alt_outlined,
              label: 'Text Hybrid',
              selected: !voiceMode,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.button : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 14,
                color: selected ? Colors.white : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textMuted,
                )),
          ],
        ),
      ),
    );
  }
}