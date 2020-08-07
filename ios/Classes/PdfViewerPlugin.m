@import UIKit;
@import WebKit;

#import "PdfViewerPlugin.h"
#import "FlutterPdfViewerFactory.h"

@interface PdfViewerPlugin () 
@end

@implementation PdfViewerPlugin {}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterPdfViewFactory* webviewFactory =
    [[FlutterPdfViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:webviewFactory withId:@"pdf_platform_view/view"];
}

@end
