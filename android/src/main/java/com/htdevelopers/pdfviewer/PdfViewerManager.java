package com.htdevelopers.pdfviewer;

import android.content.Context;
import android.view.View;
import com.github.barteksc.pdfviewer.PDFView;
import com.github.barteksc.pdfviewer.listener.OnPageScrollListener;
import com.github.barteksc.pdfviewer.listener.OnRenderListener;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

class PdfViewerManager implements PlatformView, MethodChannel.MethodCallHandler  {

    PDFView pdfView;
    Context context;
    private final MethodChannel methodChannel;


    PdfViewerManager(Context context, BinaryMessenger messenger, int id) {
        this.pdfView = new PDFView(context, null);
        this.context = context;
        methodChannel = new MethodChannel(messenger, "pdf_platform_view/view_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    void openPdf(String path) {
        File file = new File(path);
        pdfView.fromFile(file)
                .enableSwipe(true)
                .linkHandler(new UrlLauncher(this.pdfView, this.methodChannel))
                .swipeHorizontal(false)
                .onPageScroll(new OnPageScrollListener() {
                    @Override
                    public void onPageScrolled(int page, float positionOffset) {

                        HashMap args = new HashMap();
                        args.put("page", page);
                        args.put("offsetX", pdfView.getCurrentXOffset());
                        args.put("offsetY", pdfView.getCurrentYOffset());
                        args.put("zoom", pdfView.getZoom());
                        args.put("progress", positionOffset);
                        methodChannel.invokeMethod("onPageScrolled", args);
                    }
                })
                .onRender(new OnRenderListener() {
                    @Override
                    public void onInitiallyRendered(int nbPages) {
                        methodChannel.invokeMethod("onInitiallyRendered", nbPages);
                    }
                })
                .enableDoubletap(true)
                .spacing(8)
                .defaultPage(0)
                .load();

        pdfView.setMaxZoom(5);
        pdfView.setBackgroundColor(0xdcdcdc);
    }

    void close() {
        pdfView = null;
        methodChannel.invokeMethod("onDestroy", null);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "launch":
                handleOpenPdf(call, result);
                break;
            case "setPagePosition":
                if(pdfView != null) {
                    HashMap args = (HashMap) call.arguments;
                    double progress = (double) args.get("progress");
                    pdfView.setPositionOffset((float)progress);
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleOpenPdf(MethodCall call, MethodChannel.Result result) {
        String path = call.argument("path");
        openPdf(path);
        result.success(null);
    }

    @Override
    public View getView() {
        return pdfView;
    }

    @Override
    public void dispose() {

        close();
    }
}



