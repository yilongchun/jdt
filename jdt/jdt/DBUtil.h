//
//  DBUtil.h
//  jdt
//
//  Created by Stephen Chin on 17/2/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUtil : NSObject

+(NSNumber *)queryCount:(NSString *)userid;
+(BOOL)insertData:(NSDictionary *)param;
+(BOOL)deleteData:(NSDictionary *)param;
+(NSArray *)queryData:(NSString *)userid;

@end
