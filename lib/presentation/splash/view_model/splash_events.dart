sealed class SplashEvents {}

/// Fires exactly once when the splash mounts. Kept as an explicit event so
/// the view can re-trigger initialization if needed (e.g. after a
/// hot-restart) without recreating the ViewModel.
class StartSplashEvent extends SplashEvents {}
