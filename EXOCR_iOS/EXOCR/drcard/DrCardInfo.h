//
//  DrCardInfo.h
//  drcard
//
//  Created by z on 15/6/29.
//  Copyright (c) 2015年 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//是否获取整个驾驶证图片
#define GET_FULLIMAGE 1
//是否展示logo
#define DISPLAY_LOGO_DR 1

@interface DrCardInfo : NSObject
{
}

@property (copy, nonatomic) NSString *name; //姓名
@property (copy, nonatomic) NSString *sex; //性别
@property (copy, nonatomic) NSString *nation; //国籍
@property (copy, nonatomic) NSString *cardId; //证号(身份证号)
@property (copy, nonatomic) NSString *address; //住址
@property (copy, nonatomic) NSString *birth; //出生日期
@property (copy, nonatomic) NSString *issueDate; //初次领证时间
@property (copy, nonatomic) NSString *driveType; //准驾车型
@property (copy, nonatomic) NSString *validDate; //有效期至日期

@property UIImage* fullImg;
//是否显示结果页
+(BOOL) getNoShowDRResultView;
+(void) setNoShowDRResultView:(BOOL)bShow;
//是否显示姓名
+(BOOL) getNoShowDRname;
+(void) setNoShowDRname:(BOOL)bShow;
//是否显示性别
+(BOOL) getNoShowDRsex;
+(void) setNoShowDRsex:(BOOL)bShow;
//是否显示国籍
+(BOOL) getNoShowDRnation;
+(void) setNoShowDRnation:(BOOL)bShow;
//是否显示证号(身份证号)
+(BOOL) getNoShowDRcardId;
+(void) setNoShowDRcardId:(BOOL)bShow;
//是否显示住址
+(BOOL) getNoShowDRaddress;
+(void) setNoShowDRaddress:(BOOL)bShow;
//是否显示出生日期
+(BOOL) getNoShowDRbirth;
+(void) setNoShowDRbirth:(BOOL)bShow;
//是否显示初次领证时间
+(BOOL) getNoShowDRissueDate;
+(void) setNoShowDRissueDate:(BOOL)bShow;
//是否显示准驾车型
+(BOOL) getNoShowDRdriveType;
+(void) setNoShowDRdriveType:(BOOL)bShow;
//是否显示有效期至日期
+(BOOL) getNoShowDRvalidDate;
+(void) setNoShowDRvalidDate:(BOOL)bShow;

-(NSString *)toString;
-(BOOL)isOK;
@end
