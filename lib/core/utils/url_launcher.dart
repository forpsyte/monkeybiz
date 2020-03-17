import 'dart:ui';

import 'package:url_launcher/url_launcher.dart' as url;

class UrlLauncher {
  Future<void> launch(
    String urlString, {
    bool forceSafariVC,
    bool forceWebView,
    bool enableJavaScript,
    bool enableDomStorage,
    bool universalLinksOnly,
    Map<String, String> headers,
    Brightness statusBarBrightness,
  }) {
    return url.launch(
      urlString,
      forceSafariVC: forceSafariVC,
      forceWebView: forceWebView,
      enableJavaScript: enableJavaScript,
      enableDomStorage: enableDomStorage,
      universalLinksOnly: universalLinksOnly,
      headers: headers,
      statusBarBrightness: statusBarBrightness
    );
  }

  Future<bool> canLaunch(String urlString) {
    return url.canLaunch(urlString);
  }

  Future<void> closeWebView() {
    return url.closeWebView();
  }
}
