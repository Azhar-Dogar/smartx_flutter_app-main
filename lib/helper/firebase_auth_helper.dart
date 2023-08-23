import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartx_flutter_app/helper/data.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';

class FirebaseAuthHelper {
  static const WEAK_PASSWORD = 'weak-password';
  static const _ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL =
      'account-exists-with-different-credential';

  static const EMAIL_ALREADY_IN_USE = 'email-already-in-use';
  static const INVALID_EMAIL = 'invalid-email';
  static const USER_NOT_FOUND = 'user-not-found';
  static const WRONG_PASSWORD = 'wrong-password';
  static const _WEB_CONTEXT_CANCELLED = 'web-context-cancelled';
  static const _EMAIL_ALREADY_IN_USE = 'email-already-in-use';
  static const _NETWORK_REQUEST_FAILED = 'network-request-failed';

  static FirebaseAuthHelper? _instance;

  FirebaseAuthHelper._();

  static FirebaseAuthHelper instance() {
    _instance ??= FirebaseAuthHelper._();
    return _instance!;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User> googleSignIn() async {
    final credential = await _getGoogleAuthCredential();
    try {
      return (await _firebaseAuth.signInWithCredential(credential)).user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == _ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL) {
        final email = e.email;
        if (email == null) throw const NoInternetConnectException();
        final userSignInMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        throw UserAlreadyExistsWithDifferentCredential(
            authProviders: userSignInMethods, email: email);
      }
      final String errorMessage = getErrorMessage(e) ?? '';
      throw CustomFirebaseAuthException(message: errorMessage);
    } catch (e) {
      throw const NoInternetConnectException();
    }
  }

  Future<OAuthCredential> _getGoogleAuthCredential() async {
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount == null) throw UserCancelledOnGoingAuthException();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;
    return GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);
  }

  Future<void> signout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteProfile() async {
    final password = await SharedPreferenceHelper.instance.getPassword;
    if (password == null) return;
    AuthCredential credentials = EmailAuthProvider.credential(
        email: _firebaseAuth.currentUser?.email ?? '', password: password);
    _firebaseAuth.currentUser
        ?.reauthenticateWithCredential(credentials)
        .then((value) {
      value.user?.delete();
    });
  }

  Future<void> updateEmail(String email) async {
    final password = await SharedPreferenceHelper.instance.getPassword;
    if (password == null) return;

    AuthCredential credentials = EmailAuthProvider.credential(
        email: _firebaseAuth.currentUser?.email ?? '', password: password);
    _firebaseAuth.currentUser
        ?.reauthenticateWithCredential(credentials)
        .then((value) {
      value.user?.updateEmail(email);
    });
  }

  String? getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case USER_NOT_FOUND:
        return 'No User found with this email';
      case WRONG_PASSWORD:
        return 'Invalid password';
      case INVALID_EMAIL:
        return 'Invalid email';
      case WEAK_PASSWORD:
        return 'Password must be greater than 8 characters';
      case EMAIL_ALREADY_IN_USE:
        return 'Email is already used by another user';
      case _EMAIL_ALREADY_IN_USE:
        return 'Email is already in use try to login with different email.';
      case _NETWORK_REQUEST_FAILED:
        return 'Too many request has been made recently ';
      case _WEB_CONTEXT_CANCELLED:
        return 'The interaction was cancelled by the user.';
      default:
        return 'Please try again after some-time.';
    }
  }

  String? getDatabaseErrorMessage(FirebaseException e) => e.message;
}
