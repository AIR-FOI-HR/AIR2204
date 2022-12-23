enum MyProvider { email, social }

extension MyProviderX on MyProvider {
  static MyProvider fromString(String string) {
    if (string == 'google.com') {
      return MyProvider.social;
    }
    if (string == 'password') {
      return MyProvider.email;
    }
    return MyProvider.email;
  }
}
