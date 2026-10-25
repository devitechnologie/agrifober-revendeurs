import 'package:web/web.dart' as web;

Future<void> launchUrlString(String url) async {
  web.window.open(url, '_blank');
}

Future<void> launchExternalUrlString(String url) async {
  web.window.open(url, '_blank');
}
