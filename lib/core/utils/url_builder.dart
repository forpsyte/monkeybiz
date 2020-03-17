class UrlBuilder {
  String build(String authority, String unencodedPath, bool secure,
          [Map<String, String> queryParameters]) =>
      secure
          ? Uri.https(authority, unencodedPath, queryParameters).toString()
          : Uri.http(authority, unencodedPath, queryParameters).toString();
}
