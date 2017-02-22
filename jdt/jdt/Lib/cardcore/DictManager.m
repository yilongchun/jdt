//
//  DictManager.m
//  EXOCR
//
//  Created by mac on 16/5/29.
//  Copyright © 2016年 z. All rights reserved.
//

#import "DictManager.h"

static BOOL hasInit = NO;

@implementation DictManager

+(void)InitDict {
    const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
    int ret = EXCARDS_Init(thePath);
    if (ret != 0)
    {
        hasInit = NO;
        NSLog(@"Init Failed!ret=[%d]", ret);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"识别核心初始化失败，请检查授权并重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        hasInit = YES;
        NSLog(@"识别核心初始化成功");
    }
}

+(void)FinishDict {
    hasInit = NO;
    EXCARDS_Done();
}

+(BOOL)hasInit {
    return hasInit;
}

@end
