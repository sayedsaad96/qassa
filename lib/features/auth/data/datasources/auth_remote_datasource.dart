import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>?> getCurrentUserData();
  Future<void> signOut();

  Future<void> upsertUserProfile({
    required String userId,
    required String email,
    required String name,
    required String role,
    String? brandName,
  });

  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;
  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> upsertUserProfile({
    required String userId,
    required String email,
    required String name,
    required String role,
    String? brandName,
  }) async {
    final userData = {
      'id': userId,
      'email': email,
      'name': name,
      'role': role,
      'brand_name': ?brandName,
    };

    await _client.from('users').upsert(userData);
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    // Call the server-side function that handles complete account deletion
    await _client.rpc('delete_user_account');
    await _client.auth.signOut();
  }
}
