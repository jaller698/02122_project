// written by Martin
// singleton which handles general account data

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

  // user score
  int _carbonScore;
  int get carbonScore {
    return _carbonScore;
  }

  set carbonScore(int v) {
    _carbonScore = v;
  }

  // unimplementated session token
  String? _sessionID;
}
