import 'dart:async';

class UserProfile {
  final String uid;
  final String name;
  final String email;

  UserProfile({required this.uid, required this.name, required this.email});
}

abstract class AuthService {
  Future<UserProfile?> signInWithEmail(String email, String password);
  Future<void> signOut();
  Stream<UserProfile?> authStateChanges();
}

/// Fake implementation
class FakeAuthService implements AuthService {
  final StreamController<UserProfile?> _ctrl = StreamController.broadcast();
  UserProfile? _user;

  @override
  Future<UserProfile?> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _user = UserProfile(uid: 'u123', name: 'Test User', email: email);
    _ctrl.add(_user);
    return _user;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _ctrl.add(null);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Stream<UserProfile?> authStateChanges() => _ctrl.stream;
}
