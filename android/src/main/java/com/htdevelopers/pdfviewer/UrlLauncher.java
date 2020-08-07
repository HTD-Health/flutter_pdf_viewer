package com.htdevelopers.pdfviewer;

import com.github.barteksc.pdfviewer.PDFView;
import com.github.barteksc.pdfviewer.link.DefaultLinkHandler;
import com.github.barteksc.pdfviewer.link.LinkHandler;
import com.github.barteksc.pdfviewer.model.LinkTapEvent;

import io.flutter.plugin.common.MethodChannel;

class UrlLauncher implements LinkHandler {

    private static final String TAG = DefaultLinkHandler.class.getSimpleName();

    private PDFView pdfView;
    MethodChannel channel;

    public UrlLauncher(PDFView pdfView, MethodChannel channel) {
        this.pdfView = pdfView;
        this.channel = channel;
    }

    @Override
    public void handleLinkEvent(LinkTapEvent event) {
        String uri = event.getLink().getUri();
        Integer page = event.getLink().getDestPageIdx();
        if (uri != null && !uri.isEmpty()) {
            handleUri(uri);
        } else if (page != null) {
            handlePage(page);
        }
    }

    private void handleUri(String uri) {
        channel.invokeMethod("handleUri", uri);
    }

    private void handlePage(int page) {
        pdfView.jumpTo(page);
    }
}