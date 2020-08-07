#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

@interface FlutterPdfViewController : NSObject <FlutterPlatformView, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end

@interface FlutterPdfViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
