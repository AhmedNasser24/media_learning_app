import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/video_cubit.dart';
import '../cubit/video_state.dart';

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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(_formatDuration(currentPosition)), // الوقت الحالي
              // تحديث داخل Widget الـ VideoProgressBar أو إضافة زر مستقل
              IconButton(
                icon: Icon(
                  state.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.deepPurple,
                ),
                onPressed: () => context.read<VideoCubit>().toggleMute(),
              ),
              Expanded(
                child: Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) =>
                      context.read<VideoCubit>().seekTo(value),
                ),
              ),
              Text(_formatDuration(totalDuration)), // الوقت الإجمالي
            ],
          ),
        );
      },
    );
  }
}
