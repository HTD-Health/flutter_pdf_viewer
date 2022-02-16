part of 'pdf_platform_view.dart';

class PdfView extends StatefulWidget {
  final File file;
  final PdfViewController controller;

  const PdfView({
    Key? key,
    required this.file,
    required this.controller,
  }) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  NativeDeviceOrientation? _orientation;

  Widget buildPdfView() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return NativeDeviceOrientationReader(builder: (context) {
        final orientation = NativeDeviceOrientationReader.orientation(context);
        final prevOrientation = _orientation;
        _orientation = orientation;

        if (orientation != prevOrientation) {
          SchedulerBinding.instance
              !.addPostFrameCallback((timeStamp) => setState(() {}));

          return SizedBox();
        }
        return AndroidView(
          viewType: 'pdf_platform_view/view',
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      });
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'pdf_platform_view/view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Center(
        child: Text('NOT IMPLEMENTED'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFdcdcdc),
      ),
      child: buildPdfView(),
    );
  }

  void _onPlatformViewCreated(int id) {
    widget.controller
      .._initialize(id)
      .._openPdf(widget.file);
  }
}
