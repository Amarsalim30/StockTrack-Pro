import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/error/exceptions.dart';
import '../../models/auth/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String username, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> resetPassword(String email);
  Future<String?> getAuthToken();
  Future<void> refreshToken();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw ServerException('Login failed: No user returned');
      }

      return _mapFirebaseUserToUserModel(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(String username, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw ServerException('Registration failed: No user returned');
      }

      // Update display name with username
      await credential.user!.updateDisplayName(username);
      await credential.user!.reload();

      return _mapFirebaseUserToUserModel(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw ServerException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return _mapFirebaseUserToUserModel(user);
    } catch (e) {
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException('No user logged in');
      }

      // Re-authenticate user with old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw ServerException('Password change failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw ServerException('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return await user.getIdToken();
    } catch (e) {
      throw ServerException('Failed to get auth token: ${e.toString()}');
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException('No user logged in');
      }
      await user.getIdToken(true); // Force refresh
    } catch (e) {
      throw ServerException('Token refresh failed: ${e.toString()}');
    }
  }

  UserModel _mapFirebaseUserToUserModel(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      username: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      isEmailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: firebaseUser.metadata.lastSignInTime,
    );
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'requires-recent-login':
        return 'Please log in again to perform this action.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}