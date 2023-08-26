class Queries {
  static const autocompleteProductName = """
    query Products(\$modelName: String!) {
      autocomplete(model:"product",modelName: \$modelName) {
        id
        name
      }
    }
  """;

  static const testConnection = """
    query{
      testConnection
    }
  """;

  static const me = """
    query{
      me{
        id
      }
    }
  """;
}
