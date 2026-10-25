import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlString(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}

// Forces the system browser instead of an in-app webview. Required on iOS so
// account creation happens outside the app (App Store guideline 3.1.1).
Future<void> launchExternalUrlString(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
