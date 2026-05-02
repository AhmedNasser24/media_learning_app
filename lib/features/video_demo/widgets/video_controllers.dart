import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/video_cubit.dart';
import '../cubit/video_state.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر الرجوع 10 ثوانٍ
            IconButton(
              icon: const Icon(Icons.replay_10, size: 40, color: Colors.white),
              onPressed: () => context.read<VideoCubit>().seekBackward(),
            ),

            // زر التشغيل والإيقاف
            IconButton(
              icon: Icon(
                state.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                size: 60,
                color: Colors.white,
              ),
              onPressed: () => context.read<VideoCubit>().togglePlay(),
            ),

            // زر التقديم 10 ثوانٍ
            IconButton(
              icon: const Icon(Icons.forward_10, size: 40, color: Colors.white),
              onPressed: () => context.read<VideoCubit>().seekForward(),
            ),
          ],
        );
      },
    );
  }
}
