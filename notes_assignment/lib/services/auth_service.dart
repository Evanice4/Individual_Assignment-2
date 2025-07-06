import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // CREATE new user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result; // Return successful user creation
    } on FirebaseAuthException catch (e) {
      // Handle specific authentication errors
      switch (e.code) {
        case 'weak-password':
          throw 'The password provided is too weak.';
        case 'email-already-in-use':
          throw 'The account already exists for that email.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        default:
          throw 'An error occurred during registration.';
      }
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  // Sign in existing user with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result; // Return successful sign in
    } on FirebaseAuthException catch (e) {
      // Handle specific authentication errors
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        default:
          throw 'An error occurred during sign in.';
      }
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  // Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Sign out from Firebase
    } catch (e) {
      throw 'An error occurred during sign out.';
    }
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate password strength
  bool isValidPassword(String password) {
    return password.length >= 6; // Firebase minimum requirement
  }
}