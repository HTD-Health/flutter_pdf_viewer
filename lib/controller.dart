part of 'pdf_platform_view.dart';

class PagePosition {
  final Offset currentPosition;
  final double zoom;
  final double progress;
  final int page;

  PagePosition({
    @required this.currentPosition,
    @required this.zoom,
    @required this.page,
    @required this.progress,
  });

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'offsetX': currentPosition.dx,
        'offsetY': currentPosition.dy,
        'zoom': zoom,
        'page': page,
        'progress': progress,
      };
}

class PdfViewController {
  MethodChannel _channel;
  bool get initialized => _channel != null;
  bool _rendered = false;
  bool get rendered => _rendered;

  Completer<bool> _onRender;

  int _numberOfPages;
  int get numberOfPages => _numberOfPages;

  PdfViewController({this.onUriPressed});

  final ValueChanged<String> onUriPressed;
  final pagePosition = ValueNotifier<PagePosition>(null);

  void _initialize(int id) {
    _rendered = false;
    _channel = new MethodChannel('pdf_platform_view/view_$id')
      ..setMethodCallHandler(_handleMessages);

    if (_onRender?.isCompleted == false) {
      _onRender.complete(false);
    }
    _onRender = new Completer();
    setPagePosition(pagePosition.value);
  }

  Future<void> setPagePosition(PagePosition position) async {
    if (position == null) return;
    final rendered = await _onRender.future;
    if (rendered) {
      await _channel.invokeMethod("setPagePosition", position.toMap());
    }
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

      /// only android event
      case "onInitiallyRendered":
        _rendered = true;
        _numberOfPages = call.arguments;
        if (!_onRender.isCompleted) {
          _onRender.complete(true);
        }
        break;

      /// only android event
      case "onPageScrolled":
        try {
          final args = call.arguments;

          final event = PagePosition(
            currentPosition: Offset(
              args['offsetX'],
              args['offsetY'],
            ),
            zoom: args['zoom'],
            page: args['page'],
            progress: args['progress'],
          );

          pagePosition.value = event;
        } catch (err) {
          print("onPageScrolled event error: $err");
        }
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
