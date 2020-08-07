part of 'pdf_platform_view.dart';

class PdfView extends StatelessWidget {
  final File file;
  final PdfViewController controller;

  const PdfView({
    Key key,
    @required this.file,
    @required this.controller,
  })  : assert(file != null, 'file is required'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget pdfView;

    if (defaultTargetPlatform == TargetPlatform.android) {
      pdfView = AndroidView(
        viewType: 'pdf_platform_view/view',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      pdfView = UiKitView(
        viewType: 'pdf_platform_view/view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      pdfView = Center(
        child: Text("NOT IMPLEMENTED"),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFdcdcdc),
      ),
      child: pdfView,
    );
  }

  void _onPlatformViewCreated(int id) {
    controller
      .._initialize(id)
      .._openPdf(file);
  }
}
