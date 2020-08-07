//
//  FlutterPdfViewerFactory.m
//  pdf_platform_view
//
//  Created by Kamil Klyta on 07/08/2020.
//

#import "FlutterPdfViewerFactory.h"

@implementation FlutterPdfViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    
    FlutterPdfViewController* webviewController = [[FlutterPdfViewController alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    
    return webviewController;
}

@end

// ___ CONTROLLER ___

@implementation FlutterPdfViewController {
    int64_t _viewId;
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _viewId = viewId;
        self.webView = [[WKWebView alloc] initWithFrame:frame];
        self.webView.navigationDelegate = self;
        if (@available(iOS 9.0, *)) {
            /// disbale 3d touch previewe in IOS 9 and newer
            self.webView.allowsLinkPreview = false;
        }
        NSString* channelName = [NSString stringWithFormat:@"pdf_platform_view/view_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
}

- (UIView*)view {
    return self.webView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"launch"]) {
        [self onLoadUrl:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)onLoadUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* url = [call arguments][@"path"];
    
    if (![self loadUrl:url]) {
        result([FlutterError errorWithCode:@"launch_failed"
                                   message:@"Failed parsing the URL"
                                   details:[NSString stringWithFormat:@"URL was: '%@'", url]]);
    } else {
        result(nil);
    }
}

- (bool)loadUrl:(NSString*)url {
    
    NSURL *targetURL = [NSURL fileURLWithPath:url];
    
    // url parsing failed
    if (!targetURL) {
        return false;
    }
    
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:targetURL allowingReadAccessToURL:targetURL];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.webView loadRequest:request];
    }
    
    return true;
}

// listen for navigation changes
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    // Navigate only to file urls (current pdf, pdf pages etc.)
    // knwon issue -> it is possible to navigate to file url that is embed into the pdf file
    // (but placing such url in a pdf file makes no sence)
    if(navigationAction.request.URL.fileURL) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        // Send message/url to flutter app.
        [_channel invokeMethod:@"handleUri" arguments:navigationAction.request.URL.absoluteString];
    }
}

@end
