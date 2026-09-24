import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/token_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../models/session_models.dart';

class ConversationTurnUi {
  final String speaker;
  final String text;
  final String? meta;

  const ConversationTurnUi(
      {required this.speaker, required this.text, this.meta});
}

class ConversationScreen extends StatefulWidget {
  final SessionStartResult session;

  const ConversationScreen({super.key, required this.session});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _sessionService = SessionService();
  final _textController = TextEditingController();

  // ✅ منطق تسجيل الصوت
  final _audioService = AudioService();
  final _tokenStorage = TokenStorage();
  bool _isRecording = false;
  bool _isUploading = false;

  late int _currentTurn = 0;
  bool _isSending = false;
  bool _isEnding = false;

  final List<ConversationTurnUi> _messages = [];
  SessionTurnResult? _lastFeedback;

  @override
  void initState() {
    super.initState();
    _messages.add(ConversationTurnUi(
      speaker: 'ELIO AI',
      text: widget.session.openingLine,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _sendTurn() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(ConversationTurnUi(speaker: 'You (Typed)', text: text));
      _isSending = true;
      _lastFeedback = null;
    });
    _textController.clear();

    try {
      final result = await _sessionService.sendTurn(
        sessionId: widget.session.id,
        textInput: text,
      );
      setState(() {
        _currentTurn = result.turnNumber;
        _messages.add(ConversationTurnUi(
          speaker: 'ELIO AI',
          text: result.aiReplyText,
        ));
        _lastFeedback = result;
      });

      if (_currentTurn >= widget.session.maxTurns) {
        await _endSession();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send your message. Retry.')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  // ✅ تسجيل الصوت / إيقافه
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // إيقاف التسجيل ورفعه
      setState(() => _isRecording = false);
      final path = await _audioService.stopRecording();
      if (path == null) return;

      setState(() => _isUploading = true);
      try {
        final userId = await _tokenStorage.getUserId();
        final audioUrl =
            await _audioService.uploadAndGetUrl(path, userId: userId ?? 0);

        if (audioUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not upload your recording.')),
          );
          return;
        }

        await _sendAudioTurn(audioUrl);
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    } else {
      final started = await _audioService.startRecording();
      if (!started) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Microphone permission is needed to record.')),
        );
        return;
      }
      setState(() => _isRecording = true);
    }
  }

  // ✅ إرسال الجولة الصوتية
  Future<void> _sendAudioTurn(String audioUrl) async {
    setState(() {
      _messages.add(const ConversationTurnUi(
          speaker: 'You (Spoken)', text: '🎤 Voice message sent'));
      _isSending = true;
      _lastFeedback = null;
    });

    try {
      final result = await _sessionService.sendTurn(
        sessionId: widget.session.id,
        audioUrl: audioUrl,
      );
      setState(() {
        _currentTurn = result.turnNumber;
        _messages.add(ConversationTurnUi(
          speaker: 'ELIO AI',
          text: result.aiReplyText,
        ));
        _lastFeedback = result;
      });

      if (_currentTurn >= widget.session.maxTurns) {
        await _endSession();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send your recording. Retry.')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _endSession() async {
    setState(() => _isEnding = true);
    try {
      final result = await _sessionService.endSession(widget.session.id);
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.sessionComplete,
        arguments: {
          'result': result,
          'topicName': widget.session.topicName,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not end the session.')),
      );
    } finally {
      if (mounted) setState(() => _isEnding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              topicTitle: widget.session.topicName,
              currentTurn: _currentTurn,
              totalTurns: widget.session.maxTurns,
              onBack: () => Navigator.maybePop(context),
              onEnd: _isEnding ? null : _endSession,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final m in _messages) ...[
                      m.speaker == 'ELIO AI'
                          ? _AiBubble(turn: m)
                          : _UserBubble(turn: m),
                      const SizedBox(height: 10),
                    ],
                    if (_lastFeedback != null)
                      _FeedbackCard(feedback: _lastFeedback!),
                    if (_isSending)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                            child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )),
                      ),
                  ],
                ),
              ),
            ),
            // ✅ شريط الإدخال الجديد (ميكروفون + كتابة)
            _InputBar(
              controller: _textController,
              isSending: _isSending,
              isRecording: _isRecording,
              isUploading: _isUploading,
              onSend: _sendTurn,
              onToggleRecording: _toggleRecording,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final String topicTitle;
  final int currentTurn;
  final int totalTurns;
  final VoidCallback onBack;
  final VoidCallback? onEnd;

  const _TopBar({
    required this.topicTitle,
    required this.currentTurn,
    required this.totalTurns,
    required this.onBack,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 14),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.iconCircle,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  size: 16, color: AppColors.textDark),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(topicTitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                )),
          ),
          Text('TURN $currentTurn OF $totalTurns',
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              )),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onEnd,
            child: const Text('End',
                style: TextStyle(fontSize: 12, color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  final ConversationTurnUi turn;
  const _AiBubble({required this.turn});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 11, color: Colors.white),
            ),
            const SizedBox(width: 6),
            Text(turn.speaker,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                )),
          ],
        ),
        const SizedBox(height: 6),
        Container(
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
          child: Text(turn.text,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: AppColors.textDark,
              )),
        ),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  final ConversationTurnUi turn;
  const _UserBubble({required this.turn});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(turn.speaker,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.button,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(turn.text,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final SessionTurnResult feedback;
  const _FeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Chip(
                  icon: Icons.record_voice_over_outlined,
                  label:
                      'Pronunciation ${feedback.pronunciationScore.clamp(0, 100).round()}%'),
              const SizedBox(width: 8),
              _Chip(
                  icon: Icons.bolt_rounded,
                  label:
                      'Fluency ${feedback.fluencyScore.clamp(0, 100).round()}%'),
            ],
          ),
          if (feedback.feedbackText.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(feedback.feedbackText,
                style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600)),
          ],
          if (feedback.phonemeFocusSound != null &&
              feedback.phonemeFocusSound!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('PHONEME FOCUS  ${feedback.phonemeFocusSound}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC0392B),
                )),
          ],
          if (feedback.phonemeTip != null &&
              feedback.phonemeTip!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(feedback.phonemeTip!,
                style: const TextStyle(
                    fontSize: 11.5, height: 1.4, color: AppColors.textGrey)),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(height: 3),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

// ✅ شريط الإدخال الجديد (ميكروفون + كتابة)
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final bool isRecording;
  final bool isUploading;
  final VoidCallback onSend;
  final VoidCallback onToggleRecording;

  const _InputBar({
    required this.controller,
    required this.isSending,
    required this.isRecording,
    required this.isUploading,
    required this.onSend,
    required this.onToggleRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecording)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Recording... tap the mic to stop',
                  style: TextStyle(fontSize: 11.5, color: Colors.red)),
            ),
          if (isUploading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Uploading your recording...',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textGrey)),
            ),
          Row(
            children: [
              InkWell(
                onTap: isSending || isUploading ? null : onToggleRecording,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.red : AppColors.background,
                  ),
                  child: Icon(
                    isRecording ? Icons.stop_rounded : Icons.mic_none_rounded,
                    color: isRecording ? Colors.white : AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: controller,
                    enabled: !isRecording && !isUploading,
                    minLines: 1,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13.5),
                    decoration: const InputDecoration(
                      hintText: 'Type your reply...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: (isSending || isRecording || isUploading)
                    ? null
                    : onSend,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                  ),
                  child: (isSending || isUploading)
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}