class ServerResponse{
  bool _isSuccess;
  String _message;


  ServerResponse(this._isSuccess, this._message);

  bool get isSuccess => _isSuccess;

  set isSuccess(bool value) {
    _isSuccess = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }
}