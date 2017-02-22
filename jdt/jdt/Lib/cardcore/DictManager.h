//
//  DictManager.h
//  EXOCR
//
//  Created by mac on 16/5/29.
//  Copyright © 2016年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "excards.h"

@interface DictManager : NSObject

+(void)InitDict;
+(void)FinishDict;

+(BOOL)hasInit;

@end
