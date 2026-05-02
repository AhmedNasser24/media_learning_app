import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateSubscription;

  AudioPlayerCubit() : super(const AudioPlayerState()) {
    _initListeners();
  }

  void _initListeners() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      emit(state.copyWith(duration: duration));
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      emit(state.copyWith(position: position));
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      emit(
        state.copyWith(
          status: AudioPlayerStatus.completed,
          position: state.duration,
        ),
      );
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      playerState,
    ) {
      switch (playerState) {
        case PlayerState.playing:
          emit(state.copyWith(status: AudioPlayerStatus.playing));
          break;
        case PlayerState.paused:
          emit(state.copyWith(status: AudioPlayerStatus.paused));
          break;
        case PlayerState.stopped:
        case PlayerState.completed:
          // Handled by onPlayerComplete or direct stop
          break;
        case PlayerState.disposed:
          break;
      }
    });
  }

  Future<void> play(String path) async {
    try {
      if (state.path != path) {
        emit(
          state.copyWith(
            status: AudioPlayerStatus.loading,
            path: path,
            position: Duration.zero,
          ),
        );
        await _audioPlayer.play(DeviceFileSource(path));
      } else if (state.status == AudioPlayerStatus.paused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(DeviceFileSource(path));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AudioPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    emit(
      state.copyWith(
        status: AudioPlayerStatus.initial,
        position: Duration.zero,
      ),
    );
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> close() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
