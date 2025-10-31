package com.htdevelopers.pdfviewer;

import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * PdfViewerPlugin
 */
public class PdfViewerPlugin implements FlutterPlugin {
    static MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        flutterPluginBinding
                .getPlatformViewRegistry()
                .registerViewFactory(
                        "pdf_platform_view/view", new PdfViewFactory(flutterPluginBinding.getBinaryMessenger()));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}
}