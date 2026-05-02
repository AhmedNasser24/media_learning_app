import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recorder_cubit.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecorderCubit, RecorderState>(
      builder: (context, state) {
        final bool isRecording = state.status == RecorderStatus.recording;

        return GestureDetector(
          onTap: () {
            if (isRecording) {
              context.read<RecorderCubit>().stopRecording();
            } else {
              context.read<RecorderCubit>().startRecording();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isRecording ? Colors.red : Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isRecording ? Colors.red : Colors.blue).withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              size: 40,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}