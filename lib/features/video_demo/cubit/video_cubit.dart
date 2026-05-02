import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(const VideoState());
  double _lastVolume = 1.0;
  // أضف هذه الدالة داخل VideoCubit لتحديث موضع الفيديو
  void _listenToPosition() {
    final controller = state.controller;
    if (controller == null) return;

    controller.addListener(() {
      // نحدث الحالة فقط إذا تغير الثواني لتقليل إعادة البناء (Rebuilds)
      if (state.position.inSeconds != controller.value.position.inSeconds) {
        emit(state.copyWith(position: controller.value.position));
      }
    });
  }

  // تهيئة الفيديو
  Future<void> initializePlayer(String url) async {
    emit(state.copyWith(status: VideoStatus.loading));

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await controller.initialize();
      emit(
        state.copyWith(
          controller: controller,
          status: VideoStatus.ready,
          isPlaying: controller.value.isPlaying,
        ),
      );
      // should be after controller is ready
      _listenToPosition();
    } catch (e) {
      emit(state.copyWith(status: VideoStatus.error));
    }
  }
  // أضف هذه الدوال داخل كلاس VideoCubit

  // تشغيل أو إيقاف مؤقت
  void togglePlay() {
    if (state.controller == null) return;

    if (state.controller!.value.isPlaying) {
      state.controller!.pause();
      emit(state.copyWith(isPlaying: false));
    } else {
      state.controller!.play();
      emit(state.copyWith(isPlaying: true));
    }
  }

  // دالة لتغيير موضع الفيديو يدويًا (لشريط التقدم)
  void seekTo(double value) {
    if (state.controller == null) return;

    final newPosition = Duration(seconds: value.toInt());
    state.controller!.seekTo(newPosition);
    emit(state.copyWith(position: newPosition));
  }

  // تقديم الفيديو 10 ثوانٍ
  void seekForward() {
    if (state.controller == null) return;

    Duration newPosition =
        state.controller!.value.position + const Duration(seconds: 10);

    if (newPosition > state.controller!.value.duration) {
      newPosition = state.controller!.value.duration;
    }
    state.controller!.seekTo(newPosition);
    emit(state.copyWith(position: newPosition));
  }

  // تأخير الفيديو 10 ثوانٍ
  void seekBackward() {
    if (state.controller == null) return;

    Duration newPosition =
        state.controller!.value.position - const Duration(seconds: 10);
    if (newPosition.inSeconds < 0) {
      newPosition = Duration.zero;
    }
    state.controller!.seekTo(newPosition);
    emit(state.copyWith(position: newPosition));
  }

  void toggleControls() {
    emit(state.copyWith(showControls: !state.showControls));

    // إذا أصبحت الأدوات ظاهرة، سنقوم بإخفائها تلقائياً بعد 3 ثوانٍ
    if (state.showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        // نتأكد أن الـ Cubit لم يتم إغلاقه وأن المستخدم لم يغلقها يدوياً بالفعل
        if (state.showControls) {
          emit(state.copyWith(showControls: false));
        }
      });
    }
  }

  void setVolume(double value) {
    if (state.controller == null) return;

    state.controller!.setVolume(value);
    emit(state.copyWith(volume: value, isMuted: value == 0));
  }

  void toggleMute() {
    if (state.controller == null) return;

    if (state.isMuted) {
      // إعادة الصوت للقيمة السابقة
      setVolume(_lastVolume > 0 ? _lastVolume : 0.5);
    } else {
      // حفظ القيمة الحالية ثم الكتم
      _lastVolume = state.volume;
      setVolume(0.0);
    }
  }

  void toggleFullScreen() {
    final bool newFullScreen = !state.isFullScreen;

    if (newFullScreen) {
      // دخول وضع ملء الشاشة
      // 1. تغيير اتجاه الشاشة إلى العرض (Landscape)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // 2. إخفاء أشرطة النظام (Status Bar & Navigation Bar)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // الخروج من وضع ملء الشاشة
      // 1. العودة للوضع الطولي (Portrait)
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      // 2. إظهار أشرطة النظام مرة أخرى
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    emit(state.copyWith(isFullScreen: newFullScreen));
  }

  void updateOrientation(Orientation orientation) {
    final bool isLandscape = orientation == Orientation.landscape;

    if (isLandscape != state.isFullScreen) {
      if (isLandscape) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
      emit(state.copyWith(isFullScreen: isLandscape));
    }
  }

  @override
  Future<void> close() {
    // إعادة الشاشة للوضع الطبيعي عند الخروج
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    state.controller?.dispose(); // تنظيف الذاكرة
    return super.close();
  }

  @override
  void emit(VideoState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
