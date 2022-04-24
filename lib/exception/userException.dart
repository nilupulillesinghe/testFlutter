class UserException implements Exception{
  final String _message;
  UserException(this._message);

  @override
  String toString() {
    return message;
  }

  String get message => _message;
}