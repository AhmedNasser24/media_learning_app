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
      child: BlocBuilder<VideoCubit, VideoState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: state.isFullScreen
                ? null
                : AppBar(title: const Text("Clean Video Player"), elevation: 0),
            body: OrientationBuilder(
              builder: (context, orientation) {
                // Sync orientation with cubit
                context.read<VideoCubit>().updateOrientation(orientation);

                return Center(child: _buildPlayerContent(context, state));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerContent(BuildContext context, VideoState state) {
    if (state.status == VideoStatus.loading) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    if (state.status == VideoStatus.error) {
      return const Text(
        "حدث خطأ أثناء تحميل الفيديو",
        style: TextStyle(color: Colors.white),
      );
    }

    if (state.status == VideoStatus.ready) {
      return GestureDetector(
        onTap: () => context.read<VideoCubit>().toggleControls(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Video Layer
            AspectRatio(
              aspectRatio: state.controller!.value.aspectRatio,
              child: VideoPlayer(state.controller!),
            ),

            // 2. Controls Overlay Layer
            if (state.showControls) ...[
              // Dimmed Background
              Positioned.fill(child: Container(color: Colors.black26)),

              // Center Controls (Play/Pause/Seek)
              const VideoControls(),

              // Bottom Progress Bar & Actions
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressBar(),
              ),
            ],
          ],
        ),
      );
    }

    return const Text("ابدأ التشغيل", style: TextStyle(color: Colors.white));
  }
}
