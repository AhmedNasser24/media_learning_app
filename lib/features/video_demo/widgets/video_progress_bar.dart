import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/video_cubit.dart';
import '../cubit/video_state.dart';
import 'volumn_control.dart';

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({super.key});

  // دالة مساعدة لتنسيق الوقت (00:00)
  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state.controller == null) return const SizedBox();

        final totalDuration = state.controller!.value.duration;
        final currentPosition = state.position;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Slider Row with Premium Theme
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  trackHeight: 2,

                  thumbColor: Colors.redAccent,
                  activeTrackColor: Colors.redAccent,
                  inactiveTrackColor: Colors.white24,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6.0,
                  ),
                  overlayColor: Colors.redAccent.withOpacity(0.2),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 12.0,
                  ),
                ),
                child: Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) =>
                      context.read<VideoCubit>().seekTo(value),
                ),
              ),
              const SizedBox(height: 4),
              // 2. Control & Info Row
              Row(
                children: [
                  Text(
                    _formatDuration(currentPosition),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const Text(
                    " / ",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(totalDuration),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const Spacer(),
                  const VolumeControl(),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.read<VideoCubit>().toggleFullScreen(),
                    child: Icon(
                      state.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
