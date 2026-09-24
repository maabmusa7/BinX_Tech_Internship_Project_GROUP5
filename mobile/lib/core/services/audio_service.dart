import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  Future<bool> startRecording() async {
    try {
      if (!await _recorder.hasPermission()) return false;
      final dir = await getApplicationDocumentsDirectory();
      _currentPath =
          '${dir.path}/elio_turn_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
        path: _currentPath!,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      return await _recorder.stop();
    } catch (_) {
      return null;
    }
  }

  Future<void> cancelRecording() async {
    await _recorder.stop();
    if (_currentPath != null) {
      final file = File(_currentPath!);
      if (await file.exists()) await file.delete();
    }
  }

  /// بترفع الملف المحلي لـ Firebase Storage وترجع الرابط العام (download URL)
  Future<String?> uploadAndGetUrl(String localPath, {required int userId}) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) return null;

      final fileName =
          'audio_turns/$userId/${DateTime.now().millisecondsSinceEpoch}.m4a';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'audio/m4a'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  void dispose() => _recorder.dispose();
}