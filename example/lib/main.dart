import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_platform_view/pdf_platform_view.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    title: 'Plugin example app',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: RaisedButton(
          child: Text("Open PDF"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen()),
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  File file;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        file = f;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    final url = "http://www.pdf995.com/samples/pdf.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  final _controller = PdfViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: file != null
          ? PdfView(
              file: file,
              controller: _controller,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
