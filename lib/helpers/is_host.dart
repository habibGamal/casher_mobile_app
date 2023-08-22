bool isValidHost(String url) {
  const pattern = r'^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(url);
}
