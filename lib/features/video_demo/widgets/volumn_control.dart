import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_learning_app/features/video_demo/cubit/video_cubit.dart';
import 'package:media_learning_app/features/video_demo/cubit/video_state.dart';

class VolumeControl extends StatelessWidget {
  const VolumeControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زر الكتم/التشغيل
            GestureDetector(
              child: Icon(
                state.isMuted || state.volume == 0
                    ? Icons.volume_off
                    : Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
              onTap: () => context.read<VideoCubit>().toggleMute(),
            ),

            // شريط التحكم في الدرجة
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                trackHeight: 2,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              ),
              child: SizedBox(
                width: 60,
                child: Slider(
                  value: state.volume,
                  onChanged: (value) =>
                      context.read<VideoCubit>().setVolume(value),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
