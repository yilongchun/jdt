//
//  ViewController.h
//  EXOCR
//
//  Created by z on 15/7/14.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

#define DISPLAY_LOGO_MAIN 1

@interface ViewController : UIViewController


@end

