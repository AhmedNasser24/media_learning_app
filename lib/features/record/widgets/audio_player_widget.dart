import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/audio_player_cubit.dart';
import '../cubit/audio_player_state.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String path;

  const AudioPlayerWidget({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        final cubit = context.read<AudioPlayerCubit>();
        final isPlaying = state.status == AudioPlayerStatus.playing;
        final duration = state.duration;
        final position = state.position;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          cubit.pause();
                        } else {
                          cubit.play(path);
                        }
                      },
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Slider(
                            value: position.inMilliseconds.toDouble(),
                            max: duration.inMilliseconds.toDouble() > 0 
                                ? duration.inMilliseconds.toDouble() 
                                : 1.0,
                            onChanged: (value) {
                              cubit.seek(Duration(milliseconds: value.toInt()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(position)),
                                Text(_formatDuration(duration)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () => cubit.stop(),
                    ),
                  ],
                ),
                if (state.status == AudioPlayerStatus.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorMessage ?? "An error occurred",
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
