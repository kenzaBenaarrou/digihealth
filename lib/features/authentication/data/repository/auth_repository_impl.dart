import 'package:digihealth/features/authentication/data/datasource/auth_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authLocalDataSourceProvider),
    ref.read(authRemoteDatasourceProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDatasource remoteDataSource;
  AuthRepositoryImpl(this.localDataSource, this.remoteDataSource);
  @override
  Future<LoginResponseModel> login(String login, String password) async {
    final response = await remoteDataSource.login(login, password);
    localDataSource.saveToken(response.accessToken ?? '');
    localDataSource.saveRefreshToken(response.refreshToken ?? '');
    if (response.user != null) {
      localDataSource.saveUser(UserModel.fromJson(response.user!));
    }
    return response;
  }
}
