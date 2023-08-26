class Mutations {
  static const login = """
    mutation Login(\$email: String!, \$password: String!, \$deviceInfo: String!){
      login(email: \$email, password: \$password, deviceInfo: \$deviceInfo)
    }
  """;

  static const logout = """
    mutation Logout{
      logout
    }
  """;
}
