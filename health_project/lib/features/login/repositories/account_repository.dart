import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/models/account_dto.dart';
import 'package:health_project/models/account_token_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountRepository extends BaseApiClient {
  final http.Client httpClient;

  const AccountRepository({required this.httpClient});

  //
  Future<bool> checkLogin(AccountDTO dto) async {
    final url = '/accounts';
    bool check = false;
    final request = await postLoginApi(url, dto.toJson());
    if (request.statusCode == 200) {
      String token = request.body;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      AccountTokenDTO accountTokenDTO = AccountTokenDTO.fromJson(decodedToken);
      AuthenticateHelper.instance.updateAuthentication(
        isAuthen: true,
        accountId: accountTokenDTO.accountId,
        tokenAccount: token,
        firstName: accountTokenDTO.firstName,
        lastName: accountTokenDTO.lastName,
        avatar: accountTokenDTO.avatar,
      );
      check = true;
    }
    return check;
  }
}
