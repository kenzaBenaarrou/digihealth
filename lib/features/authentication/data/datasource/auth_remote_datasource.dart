import 'package:digihealth/core/network/dio_client.dart';
import 'package:digihealth/features/authentication/data/models/login_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasourceImpl(ref.read(dioProvider));
});

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(String login, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;
  AuthRemoteDatasourceImpl(this.dio);

  @override
  Future<LoginResponseModel> login(String login, String password) async {
    final response = await dio
        .post('auth/login', data: {'login': login, 'password': password});
    return LoginResponseModel.fromJson(response.data);
  }
}
