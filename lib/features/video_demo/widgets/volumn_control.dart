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
                color: Colors.deepPurpleAccent,
              ),
              onTap: () => context.read<VideoCubit>().toggleMute(),
            ),

            // شريط التحكم في الدرجة
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                padding: EdgeInsets.symmetric(horizontal: 8),
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: SizedBox(
                width: 80, // عرض صغير ليتناسب مع الزاوية
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
