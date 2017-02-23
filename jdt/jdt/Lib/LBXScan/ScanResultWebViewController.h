//
//  ScanResultWebViewController.h
//  jqdl
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mywebview;
@property (strong, nonatomic) NSString *url;

@end
