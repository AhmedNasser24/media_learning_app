part of 'recorder_cubit.dart';

enum RecorderStatus { initial, recording, paused, stopped, error }

class RecorderState extends Equatable {
  final RecorderStatus status;
  final Duration duration; // مدة التسجيل الحالية
  final String? path; // مسار الملف المسجل بعد الانتهاء
  final String? errorMessage;

  const RecorderState({
    this.status = RecorderStatus.initial,
    this.duration = Duration.zero,
    this.path,
    this.errorMessage,
  });

  RecorderState copyWith({
    RecorderStatus? status,
    Duration? duration,
    String? path,
    String? errorMessage,
  }) {
    return RecorderState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
      path: path ?? this.path,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, duration, path, errorMessage];
}
