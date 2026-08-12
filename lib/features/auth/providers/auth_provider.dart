import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie_hup/features/auth/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      notifyListeners();
    });
  }
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmailPassword(email, password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseError(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage('An unexpected error occurred.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    try {
      await _authService.registerWithEmailPassword(email, password, name);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseError(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage('An unexpected error occurred.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    try {
      final user = await _authService.signInWithGoogle();
      _setLoading(false);
      return user != null;
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseError(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage('An unexpected error occurred during Google Sign-In.');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
