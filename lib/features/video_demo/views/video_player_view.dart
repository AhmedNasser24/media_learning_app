import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/video_cubit.dart';
import '../cubit/video_state.dart';
import '../widgets/video_controllers.dart';
import '../widgets/video_progress_bar.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    const url1 =
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
    // ignore: unused_local_variable
    const url2 =
        'https://cdn.pixabay.com/video/2017/12/05/13232-246463976_tiny.mp4';
    return BlocProvider(
      create: (context) => VideoCubit()..initializePlayer(url1),
      child: Scaffold(
        appBar: AppBar(title: const Text("Clean Video Player")),
        body: Center(
          child: BlocBuilder<VideoCubit, VideoState>(
            builder: (context, state) {
              if (state.status == VideoStatus.loading) {
                return const CircularProgressIndicator();
              } else if (state.status == VideoStatus.ready) {
                return GestureDetector(
                  onTap: () => context.read<VideoCubit>().toggleControls(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: state.controller!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            AnimatedOpacity(
                              opacity: state.showControls ? 0.9 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: VideoPlayer(state.controller!),
                            ),
                            state.showControls
                                ? const Center(
                                    child: VideoControls(),
                                  ) // أزرار التشغيل في المنتصف
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      state.showControls
                          ? const VideoProgressBar()
                          : const SizedBox(), // شريط التقدم بالأسفل
                    ],
                  ),
                );
              } else if (state.status == VideoStatus.error) {
                return const Text("حدث خطأ أثناء تحميل الفيديو");
              }
              return const Text("ابدأ التشغيل");
            },
          ),
        ),
      ),
    );
  }
}
