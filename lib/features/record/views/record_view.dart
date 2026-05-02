import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recorder_cubit.dart';
import '../widgets/recorder_button.dart';
import '../widgets/recorder_timer.dart';

class RecorderView extends StatelessWidget {
  const RecorderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecorderCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Voice Recorder")),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RecorderTimer(),
              const SizedBox(height: 40),
              const RecordButton(),
              const SizedBox(height: 20),

              // عرض رسالة الخطأ إن وجدت
              BlocBuilder<RecorderCubit, RecorderState>(
                builder: (context, state) {
                  if (state.errorMessage != null) {
                    return Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  if (state.status == RecorderStatus.stopped &&
                      state.path != null) {
                    return Text(
                      "تم الحفظ في: ${state.path!.split('/').last}",
                      style: const TextStyle(color: Colors.green),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
