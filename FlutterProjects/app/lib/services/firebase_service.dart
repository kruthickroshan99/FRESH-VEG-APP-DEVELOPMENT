import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // Get user stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== EMAIL/PASSWORD AUTHENTICATION ====================

  /// Sign up with email and password
  static Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print('📧 Starting email sign up for: $email');
      
      // Create user account
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ User account created: ${userCredential.user?.uid}');

      // Update display name
      await userCredential.user?.updateDisplayName(name);
      print('✅ Display name updated: $name');

      // Create user document in Firestore
      if (userCredential.user != null) {
        await _createUserDocument(
          userId: userCredential.user!.uid,
          email: email,
          displayName: name,
          photoURL: null,
        );
        print('✅ User document created in Firestore');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('🔴 FirebaseAuthException during sign up: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('🔴 Error during sign up: $e');
      throw 'Registration failed: ${e.toString()}';
    }
  }

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('📧 Starting email sign in for: $email');
      
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ Email sign in successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('🔴 FirebaseAuthException during sign in: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('🔴 Error during sign in: $e');
      throw 'Login failed: ${e.toString()}';
    }
  }

  // ==================== GOOGLE SIGN-IN ====================

  /// Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔵 ========== GOOGLE SIGN-IN STARTED ==========');
      print('🔵 Step 1: Signing out from previous Google session...');
      
      // Sign out from previous session to force account picker
      await _googleSignIn.signOut();
      
      print('🔵 Step 2: Triggering Google account picker...');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        print('⚠️ User cancelled Google Sign-In');
        return null;
      }

      print('✅ Step 3: Google account selected');
      print('   - Email: ${googleUser.email}');
      print('   - Display Name: ${googleUser.displayName}');
      print('   - ID: ${googleUser.id}');

      print('🔵 Step 4: Getting authentication tokens...');
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('✅ Step 5: Got authentication tokens');
      print('   - Access Token: ${googleAuth.accessToken?.substring(0, 20)}...');
      print('   - ID Token: ${googleAuth.idToken?.substring(0, 20)}...');

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('🔴 ERROR: Missing tokens!');
        print('   - Access Token: ${googleAuth.accessToken}');
        print('   - ID Token: ${googleAuth.idToken}');
        throw 'Failed to get Google authentication tokens';
      }

      print('🔵 Step 6: Creating Firebase credential...');
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('✅ Step 7: Firebase credential created');
      print('🔵 Step 8: Signing in to Firebase...');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      print('✅ ========== GOOGLE SIGN-IN SUCCESSFUL ==========');
      print('   - User ID: ${userCredential.user?.uid}');
      print('   - Email: ${userCredential.user?.email}');
      print('   - Display Name: ${userCredential.user?.displayName}');
      print('   - Photo URL: ${userCredential.user?.photoURL}');

      // Create or update user document in Firestore
      if (userCredential.user != null) {
        print('🔵 Step 9: Creating/updating user document in Firestore...');
        await _createUserDocument(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName ?? 'User',
          photoURL: userCredential.user!.photoURL,
        );
        print('✅ Step 10: User document saved');
      }

      print('✅ ========== ALL STEPS COMPLETED ==========');
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      print('🔴 ========== FIREBASE AUTH ERROR ==========');
      print('🔴 Error Code: ${e.code}');
      print('🔴 Error Message: ${e.message}');
      print('🔴 Stack Trace: ${e.stackTrace}');
      throw _handleAuthException(e);
    } on Exception catch (e) {
      print('🔴 ========== GENERAL EXCEPTION ==========');
      print('🔴 Exception: $e');
      print('🔴 Type: ${e.runtimeType}');
      throw 'Google sign-in failed: ${e.toString()}';
    } catch (e) {
      print('🔴 ========== UNKNOWN ERROR ==========');
      print('🔴 Error: $e');
      print('🔴 Type: ${e.runtimeType}');
      throw 'Google sign-in failed: ${e.toString()}';
    }
  }

  // ==================== USER MANAGEMENT ====================

  /// Create user document in Firestore
  static Future<void> _createUserDocument({
    required String userId,
    required String email,
    required String displayName,
    String? photoURL,
  }) async {
    try {
      print('📝 Creating user document for: $userId');
      
      final userDoc = _firestore.collection('users').doc(userId);
      final docSnapshot = await userDoc.get();

      // Only create if document doesn't exist
      if (!docSnapshot.exists) {
        await userDoc.set({
          'email': email,
          'displayName': displayName,
          'photoURL': photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print('✅ New user document created');
      } else {
        // Update last login
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print('✅ User document updated (last login)');
      }
    } catch (e) {
      print('🔴 Error creating user document: $e');
      // Don't throw error - user is still authenticated even if Firestore fails
    }
  }

  /// Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print('🔴 Error getting user data: $e');
      return null;
    }
  }

  /// Update user profile
  static Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Update Firebase Auth profile
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      // Update Firestore document
      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName;
      if (photoURL != null) updates['photoURL'] = photoURL;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }
    } catch (e) {
      throw 'Failed to update profile: ${e.toString()}';
    }
  }

  // ==================== PASSWORD RESET ====================

  /// Send password reset email
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send reset email: ${e.toString()}';
    }
  }

  // ==================== SIGN OUT ====================

  /// Sign out
  static Future<void> signOut() async {
    try {
      print('🔵 Signing out...');
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('✅ Sign out successful');
    } catch (e) {
      print('🔴 Sign out error: $e');
      throw 'Sign out failed: ${e.toString()}';
    }
  }

  // ==================== ERROR HANDLING ====================

  static String _handleAuthException(FirebaseAuthException e) {
    print('🔴 Handling Firebase Auth Exception: ${e.code}');
    
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';
      case 'invalid-credential':
        return 'The credential is malformed or has expired.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}