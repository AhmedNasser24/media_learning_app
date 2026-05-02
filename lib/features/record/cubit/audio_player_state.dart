import 'package:equatable/equatable.dart';

enum AudioPlayerStatus { initial, loading, playing, paused, completed, error }

class AudioPlayerState extends Equatable {
  final AudioPlayerStatus status;
  final String? path;
  final Duration duration;
  final Duration position;
  final String? errorMessage;

  const AudioPlayerState({
    this.status = AudioPlayerStatus.initial,
    this.path,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.errorMessage,
  });

  AudioPlayerState copyWith({
    AudioPlayerStatus? status,
    String? path,
    Duration? duration,
    Duration? position,
    String? errorMessage,
  }) {
    return AudioPlayerState(
      status: status ?? this.status,
      path: path ?? this.path,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, path, duration, position, errorMessage];
}
