import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  /// Flipped to `true` once the splash minimum-display window has elapsed
  /// AND any startup work (currently just the built-in DI init that already
  /// ran before `runApp`) is confirmed ready. The view listens for this and
  /// routes on to the dashboard.
  final bool ready;

  const SplashState({this.ready = false});

  SplashState copyWith({bool? ready}) {
    return SplashState(ready: ready ?? this.ready);
  }

  @override
  List<Object?> get props => [ready];
}
