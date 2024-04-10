class UserController {
  // singleton
  UserController._hiddenConstructor();
  static final UserController _singleton = UserController._hiddenConstructor();
  factory UserController() => _singleton;

  // user account data
  String? _username;
  String get username {
    return _username ?? 'guest';
  }
  set username(String v) {
    _username=v;
  }

  String? _sessionID;

  // user data
  int? _userscore;
}

class _UserData {
  final String username;

  _UserData(this.username);
}
