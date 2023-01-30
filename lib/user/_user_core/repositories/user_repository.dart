import 'package:job_me/_shared/local_storage/secure_shared_prefs.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/_user_core/models/user.dart';

class UserRepository {
  // MARK : singleton

  late SecureSharedPrefs _sharedPrefs;
  static UserRepository? _repository;

  UserRepository._() : _sharedPrefs = SecureSharedPrefs();

  static Future<void> initRepo() async {
    await UserRepository()._readUserData();
  }

  factory UserRepository() {
    _repository ??= UserRepository._();
    return _repository!;
  }

  // MARK: saving, reading and getting user data

  User? _user;
  Roles? role;

  Future<void> _readUserData() async {
    var usersMap = await _sharedPrefs.getMap('user');
    if (usersMap != null) {
      _user = User.fromJson(usersMap);
    }
  }

  Future<void> saveUser(User user) async {
    await _sharedPrefs.saveMap('user', user.toJson());
    _user = user;
  }

  Future<void> removeUser() async {
    await _sharedPrefs.removeMap('user');
    _user = null;
  }

  // CAUTION: use this function only when you are sure that there is a user in the local storage
  User getUser() {
    return _user!;
  }

  String? getUserToken() {
    return _user?.token;
  }

  bool isUserLoggedIn() {
    return _user != null;
  }

  void setVisitorUserRole(Roles role) {
    this.role = role;
  }

  bool isEmployee() {
    if (_user != null) {
      return _user!.role == Roles.searcherForJob;
    }
    return role == Roles.searcherForJob;
  }

  /*
  this app has tow users type
   1. employee
   2. company
   and most of the logic is the same and there is no difference except two major difference
   1. each user should tell the api what type of user he is, and to do that you need to add a query parameter to the url got calling // toRawString()
   2. employee when browsing jobs he will receive jobs posted by companies and vice versa, so when job card got clicked each user will go to the appropriate screen
  */

  String toQueryParameter() {
    return isEmployee() ? 'type=f' : 'type=e';
  }
}
