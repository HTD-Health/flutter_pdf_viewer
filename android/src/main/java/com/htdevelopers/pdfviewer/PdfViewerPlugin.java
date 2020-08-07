package com.htdevelopers.pdfviewer;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * PdfViewerPlugin
 */
public class PdfViewerPlugin {
    static MethodChannel channel;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        registrar
        .platformViewRegistry()
        .registerViewFactory(
                "pdf_platform_view/view", new PdfViewFactory(registrar.messenger()));
    }
}
