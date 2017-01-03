//
//  ViewController.m
//  WTF
//
//  Created by D_Ryu on 17/1/3.
//  Copyright © 2017年 dongqiudi. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<NSTabViewDelegate,WebFrameLoadDelegate>

//@property (nonatomic,strong) WKWebView *mainWebView;


@property (nonatomic,strong) NSTableView *mainTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MainTabView.delegate = self;
    
    [self.view addSubview:self.mainTableView];
    
//    self.mainWebView.frameLoadDelegate = self;
    
//    WebFrame *mainFrame = [self.mainWebView mainFrame];
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//    [mainFrame loadRequest:[NSURLRequest requestWithURL:url]];

    // Do any additional setup after loading the view.
}


- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    
}

- (NSTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[NSTableView alloc] initWithFrame:self.view.bounds];
        _mainTableView.backgroundColor = [NSColor blueColor];
    }
    return _mainTableView;
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {

}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {

}

- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame {

}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {

}

//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//
//}
//
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//
//}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//
//}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
