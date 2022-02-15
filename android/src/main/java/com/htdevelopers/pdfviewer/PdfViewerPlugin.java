package com.htdevelopers.pdfviewer;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * PdfViewerPlugin
 */
public class PdfViewerPlugin implements FlutterPlugin {
    static MethodChannel channel;

    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "pdf_platform_view/view", new PdfViewFactory(registrar.messenger()));
    }

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