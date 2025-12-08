import 'api_service.dart';

class MockApiService implements ApiService {
  @override
  Future<bool> mockLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
