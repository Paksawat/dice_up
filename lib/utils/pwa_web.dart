import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('showInstallPrompt')
external void _jsShowInstallPrompt();

void showInstallPrompt() {
  _jsShowInstallPrompt();
}

bool isStandalone() {
  return web.window.matchMedia('(display-mode: standalone)').matches;
}
