/// Thrown when a 401/403 response indicates the user's session has expired
/// and cannot be refreshed. Used by SyncManager to abort sync cycles.
class AuthExpiredException implements Exception {
  final String message;

  const AuthExpiredException([this.message = 'Session expired']);

  @override
  String toString() => 'AuthExpiredException: $message';
}
