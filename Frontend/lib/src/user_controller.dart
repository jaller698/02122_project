class UserController {
  // singleton
  UserController._hiddenConstructor() : _carbonScore = 0;
  static final UserController _singleton = UserController._hiddenConstructor();
  factory UserController() => _singleton;

  // user account data
  String? _username;
  String get username {
    return _username ?? 'guest';
  }

  set username(String v) {
    _username = v;
  }
  int _carbonScore;
  int get carbonScore {
    return _carbonScore;
  }

  set carbonScore(int v) {
    _carbonScore = v;
  }

  String? _sessionID;
}

class _UserData {
  final String username;
  int carbonScore;

  _UserData(this.username, {this.carbonScore = 0});
}
