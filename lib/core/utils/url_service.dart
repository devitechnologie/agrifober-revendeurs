import 'url_service/base_url_service.dart'
    if (dart.library.io) 'url_service/mobile_url_service.dart'
    if (dart.library.html) 'url_service/web_url_service.dart'
    as url_service;

class UrlService {
  static Future<void> launchUrlString(String url) async {
    await url_service.launchUrlString(url);
  }

  static Future<void> launchExternalUrlString(String url) async {
    await url_service.launchExternalUrlString(url);
  }
}
