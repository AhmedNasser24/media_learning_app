import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

enum VideoStatus { initial, loading, ready, error }

class VideoState extends Equatable {
  final VideoPlayerController? controller;
  final VideoStatus status;
  final bool isPlaying;
  final Duration position;
  final bool showControls;
  final bool isMuted;
  const VideoState({
    this.controller,
    this.status = VideoStatus.initial,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.showControls = true,
    this.isMuted = false,
  });

  VideoState copyWith({
    VideoPlayerController? controller,
    VideoStatus? status,
    bool? isPlaying,
    Duration? position,
    bool? showControls,
    bool? isMuted,
  }) {
    return VideoState(
      controller: controller ?? this.controller,
      status: status ?? this.status,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      showControls: showControls ?? this.showControls,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    status,
    isPlaying,
    position,
    showControls,
    isMuted,
  ];
}
