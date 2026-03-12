import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get currentUser => _supabase.auth.currentUser;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Placeholder for Face Registration logic
  Future<void> registerFaceProfile(String userId, List<int> faceBytes) async {
    // 1. Upload bytes to Supabase Storage
    // 2. Update profiles table set face_registered = true
    try {
      final path = 'faces/$userId/profile.jpg';
      await _supabase.storage.from('identity').uploadBinary(path, faceBytes);
      await _supabase.from('profiles').update({'face_registered': true}).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
