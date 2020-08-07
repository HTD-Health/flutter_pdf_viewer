part of 'pdf_platform_view.dart';

class PdfViewController {
  MethodChannel _channel;
  bool get initialized => _channel != null;

  PdfViewController({this.onUriPressed});

  final ValueChanged<String> onUriPressed;

  void _initialize(int id) {
    _channel = new MethodChannel('pdf_platform_view/view_$id')
      ..setMethodCallHandler(_handleMessages);
  }

  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case "handleUri":
        assert((() {
          /// this message will appear only in dev mode
          print("PDF URL pressed: ${call.arguments}");
          return true;
        })());

        onUriPressed?.call(call.arguments);
        break;
    }
  }

  Future<void> _openPdf(File file) async {
    assert(file != null, 'file cannot be null');
    if (!initialized) throw StateError('$runtimeType is not initialized.');

    final args = <String, dynamic>{'path': file.path};
    await _channel.invokeMethod('launch', args);
  }
}
