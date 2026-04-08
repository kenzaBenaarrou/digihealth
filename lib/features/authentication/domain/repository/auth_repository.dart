import 'package:digihealth/features/authentication/data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String login, String password);
}
