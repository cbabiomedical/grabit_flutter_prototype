class MockApiService {
  Future<bool> mockRegister(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> mockVerify(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return code == '123456';
  }

  Future<bool> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
