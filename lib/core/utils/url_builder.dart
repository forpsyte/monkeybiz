class UrlBuilder {
  Uri build(String authority, String unencodedPath, bool secure,
          [Map<String, String> queryParameters]) =>
      secure
          ? Uri.https(authority, unencodedPath, queryParameters)
          : Uri.http(authority, unencodedPath, queryParameters);
}
