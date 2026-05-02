import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'recorder_state.dart';

class RecorderCubit extends Cubit<RecorderState> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer; // لتحديث العداد ثانية بثانية

  RecorderCubit() : super(const RecorderState());

  // التحقق من الصلاحيات والبدء
  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // تحديد مسار الحفظ (في مجلد المستندات المؤقتة)
        final directory = await getApplicationDocumentsDirectory();
        final String filePath =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        const config = RecordConfig(); // الإعدادات الافتراضية

        await _audioRecorder.start(config, path: filePath);

        emit(
          state.copyWith(
            status: RecorderStatus.recording,
            duration: Duration.zero,
          ),
        );
        _startTimer();
      } else {
        emit(state.copyWith(errorMessage: "لم يتم منح صلاحية الميكروفون"));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: RecorderStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // إيقاف التسجيل
  Future<void> stopRecording() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();
    emit(state.copyWith(status: RecorderStatus.stopped, path: path));
  }

  // تحديث العداد
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(
        state.copyWith(
          duration: Duration(seconds: state.duration.inSeconds + 1),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _audioRecorder.dispose();
    return super.close();
  }
}
