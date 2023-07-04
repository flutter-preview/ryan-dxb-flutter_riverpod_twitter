import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);

  return AuthApi(account: account);
});

abstract class IAuthApi {
  FutureEither<model.User> signup({
    required String email,
    required String password,
  });

  FutureEither<model.Session> login({
    required String email,
    required String password,
  });
}

class AuthApi implements IAuthApi {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  @override
  FutureEither<model.User> signup({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: 'unique()',
        email: email,
        password: password,
      );

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(
        message: e.message ?? 'Something went wrong',
        stackTrace: stackTrace,
      ));
    } catch (e, stackTrace) {
      return left(Failure(
        message: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  FutureEither<model.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );

      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(
        message: e.message ?? 'Something went wrong',
        stackTrace: stackTrace,
      ));
    } catch (e, stackTrace) {
      return left(Failure(
        message: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }
}
