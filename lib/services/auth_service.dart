import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  SupabaseClient get _supabase => Supabase.instance.client;
  
  AuthService() {
    _fetchInitialProfile();
  }

  bool _isLoading = false;
  Map<String, dynamic>? _currentCompany;
  Map<String, dynamic>? _currentUserProfile;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get currentCompany => _currentCompany;
  Map<String, dynamic>? get currentUserProfile => _currentUserProfile;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _supabase.auth.signInWithPassword(email: email, password: password);
      
      // Fetch user profile and company info
      if (response.user != null) {
        final profile = await _supabase
            .from('profiles')
            .select('*, companies(*)')
            .eq('id', response.user!.id)
            .single();
        _currentUserProfile = profile;
        _currentCompany = profile['companies'];
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerFace(String userId, List<int> faceBytes) async {
    // 1. Upload face profile to Supabase Storage
    // 2. Update profiles table set face_registered = true
    try {
      final path = 'faces/$userId/profile.jpg';
      await _supabase.storage.from('identity').uploadBinary(path, Uint8List.fromList(faceBytes));
      await _supabase.from('profiles').update({'face_registered': true}).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<bool> verifyFace(String userId, List<int> capturedBytes) async {
    _setLoading(true);
    try {
      // 1. Upload captured image to a temporary path
      final tempPath = 'temp/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage.from('identity').uploadBinary(tempPath, Uint8List.fromList(capturedBytes));

      // 2. Call Edge Function
      final response = await _supabase.functions.invoke(
        'face-match',
        body: {'userId': userId, 'capturedImagePath': tempPath},
      );

      return response.data['verified'] == true;
    } catch (e) {
      debugPrint('Face verification error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _fetchInitialProfile() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final profile = await _supabase
            .from('profiles')
            .select('*, companies(*)')
            .eq('id', user.id)
            .single();
        _currentUserProfile = profile;
        _currentCompany = profile['companies'];
        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching initial profile: $e');
      }
    }
  }
}
