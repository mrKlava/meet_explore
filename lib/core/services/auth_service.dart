import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current Firebase user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Sign in with email & password
  Future<User?> signIn(String email, String password) async {
    final credential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  // Register with email & password
  Future<User?> signUp(String email, String password) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Listen to auth changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
