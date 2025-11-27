import 'dart:js_interop';

@JS('showInstallPrompt')
external void _jsShowInstallPrompt();

void showInstallPrompt() {
  _jsShowInstallPrompt();
}
