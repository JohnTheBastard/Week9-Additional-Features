//
//  ViewController.m
//  WebViewAuthDemo
//
//  Created by John D Hearn on 12/13/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "ViewController.h"

@import WebKit;

NSString *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString *kClientID = @"8607";

@interface ViewController ()<WKNavigationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = self.view.frame;

    [self.view addSubview:webView];

    NSURL *authURL = [self createStackOverflowAuthURL];

    [webView loadRequest:[NSURLRequest requestWithURL:authURL]];

    webView.navigationDelegate = self;


}

-(NSURL *)createStackOverflowAuthURL{
    // We could use URL components, which I like better
    NSString *urlString =
        [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",
                                   kBaseURL, kClientID, kRedirectURI];
    return [[NSURL alloc] initWithString:urlString];
}


//MARK: WKNavigationDelegate Method

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    // Shouldn't we also check the base URL?
    if ([navigationAction.request.URL.path containsString:@"/oauth/login_success"]) {
        NSLog(@"%@ IS TOKEN IN STRING? : ", navigationAction.request.URL.absoluteString);

    }

    NSLog(@"\n\nREQUEST URL: %@ \n\n", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}



@end
