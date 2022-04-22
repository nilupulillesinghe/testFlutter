class UserModel{
  String _test_user_user_name;
  String _test_user_email;
  String _test_user_password;

  UserModel(this._test_user_user_name, this._test_user_email,
      this._test_user_password);

  factory UserModel.fromMap(Map<String,dynamic> data){
    return(UserModel(
        data['test_user_user_name'],
        data['test_user_email'],
        data['test_user_password']
    ));
  }

  Map<String, dynamic> toMap()=>{
    "test_user_user_name": test_user_user_name,
    "test_user_email": test_user_email,
    "test_user_password": test_user_password
  };

  String get test_user_password => _test_user_password;

  set test_user_password(String value) {
    _test_user_password = value;
  }

  String get test_user_email => _test_user_email;

  set test_user_email(String value) {
    _test_user_email = value;
  }

  String get test_user_user_name => _test_user_user_name;

  set test_user_user_name(String value) {
    _test_user_user_name = value;
  }
}