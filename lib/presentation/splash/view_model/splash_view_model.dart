import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'splash_events.dart';
import 'splash_state.dart';

@injectable
class SplashViewModel extends Cubit<SplashState> {
  // Minimum time the splash stays on screen even if the app is ready
  // sooner — otherwise a fast device would flash it and disappear.
  static const _minDisplay = Duration(milliseconds: 1200);

  SplashViewModel() : super(const SplashState()) {
    _init();
  }

  void doIntent(SplashEvents event) {
    switch (event) {
      case StartSplashEvent():
        _init();
    }
  }

  Future<void> _init() async {
    // ObjectBox + all @preResolve DI ran before `runApp`, so by the time
    // splash is on screen the app is functionally ready. This delay is
    // purely brand-visibility.
    await Future.delayed(_minDisplay);
    if (isClosed) return;
    emit(state.copyWith(ready: true));
  }
}
