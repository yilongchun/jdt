//
//  IdInfo.h
//  exid
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//是否获取整个身份证图片
#define GET_FULLIMAGE 1

//是否展示logo
#define DISPLAY_LOGO_ID 0

@interface IdInfo : NSObject
{
    
}
@property (nonatomic) int type; //1:正面  2:反面
@property (strong, nonatomic) NSString *code; //身份证号
@property (strong, nonatomic) NSString *name; //姓名
@property (strong, nonatomic) NSString *gender; //性别
@property (strong, nonatomic) NSString *nation; //民族
@property (strong, nonatomic) NSString *address; //地址
@property (strong, nonatomic) NSString *issue; //签发机关
@property (strong, nonatomic) NSString *valid; //有效期
@property (strong, nonatomic) NSString *birth; //出生

@property UIImage* frontFullImg;
@property UIImage* backFullImg;

@property UIImage* faceImg;
@property UIImage* nameImg;
@property UIImage* sexImg;
@property UIImage* noImg;
@property UIImage* addressImg;
@property UIImage* issueImg;
@property UIImage* validImg;

//是否开启double-check
+(BOOL)shouldEnableDoubleCheck;
//是否显示头像
+(BOOL) getNoShowIDFaceImg;
+(void) setNoShowIDFaceImg:(BOOL)bShow;
//是否显示姓名
+(BOOL) getNoShowIDName;
+(void) setNoShowIDName:(BOOL)bShow;
//是否显示性别
+(BOOL) getNoShowIDSex;
+(void) setNoShowIDSex:(BOOL)bShow;
//是否显示民族
+(BOOL) getNoShowIDNation;
+(void) setNoShowIDNation:(BOOL)bShow;
//是否显示出生
+(BOOL) getNoShowIDBirth;
+(void) setNoShowIDBirth:(BOOL)bShow;
//是否显示住址
+(BOOL) getNoShowIDAddress;
+(void) setNoShowIDAddress:(BOOL)bShow;
//是否显示证件号
+(BOOL) getNoShowIDCode;
+(void) setNoShowIDCode:(BOOL)bShow;
//是否显示签发机关
+(BOOL) getNoShowIDOffice;
+(void) setNoShowIDOffice:(BOOL)bShow;
//是否显示有效期限
+(BOOL) getNoShowIDValid;
+(void) setNoShowIDValid:(BOOL)bShow;
//是否显示正面全图
+(BOOL) getNoShowIDFrontFullImg;
+(void) setNoShowIDFrontFullImg:(BOOL)bShow;
//是否显示背面全图
+(BOOL) getNoShowIDBackFullImg;
+(void) setNoShowIDBackFullImg:(BOOL)bShow;

-(NSString *)toString;
-(BOOL)isOK;
@end
