//
//  DrCardInfo.m
//  drcard
//
//  Created by z on 15/6/29.
//  Copyright (c) 2015年 hxg. All rights reserved.
//

#import "DrCardInfo.h"

static BOOL bNoShowDRResultView = NO;
static BOOL bNoShowDRname = NO;
static BOOL bNoShowDRsex = NO;
static BOOL bNoShowDRnation = NO;
static BOOL bNoShowDRcardId = NO;
static BOOL bNoShowDRaddress = NO;
static BOOL bNoShowDRbirth = NO;
static BOOL bNoShowDRissueDate = NO;
static BOOL bNoShowDRdriveType = NO;
static BOOL bNoShowDRvalidDate = NO;
//static BOOL bNoShowVEFullImg = NO;

@implementation DrCardInfo
//是否显示结果页
+(BOOL) getNoShowDRResultView
{
    return bNoShowDRResultView;
}
+(void) setNoShowDRResultView:(BOOL)bShow
{
    bNoShowDRResultView = bShow;
}
//是否显示姓名
+(BOOL) getNoShowDRname
{
    return bNoShowDRname;
}
+(void) setNoShowDRname:(BOOL)bShow
{
    bNoShowDRname = bShow;
}
//是否显示性别
+(BOOL) getNoShowDRsex
{
    return bNoShowDRsex;
}
+(void) setNoShowDRsex:(BOOL)bShow
{
    bNoShowDRsex = bShow;
}
//是否显示国籍
+(BOOL) getNoShowDRnation
{
    return bNoShowDRnation;
}
+(void) setNoShowDRnation:(BOOL)bShow
{
    bNoShowDRnation = bShow;
}
//是否显示证号
+(BOOL) getNoShowDRcardId
{
    return bNoShowDRcardId;
}
+(void) setNoShowDRcardId:(BOOL)bShow
{
    bNoShowDRcardId = bShow;
}
//是否显示住址
+(BOOL) getNoShowDRaddress
{
    return bNoShowDRaddress;
}
+(void) setNoShowDRaddress:(BOOL)bShow
{
    bNoShowDRaddress = bShow;
}
//是否显示出生日期
+(BOOL) getNoShowDRbirth
{
    return bNoShowDRbirth;
}
+(void) setNoShowDRbirth:(BOOL)bShow
{
    bNoShowDRbirth = bShow;
}
//是否显示初次领证日期
+(BOOL) getNoShowDRissueDate
{
    return bNoShowDRissueDate;
}
+(void) setNoShowDRissueDate:(BOOL)bShow
{
    bNoShowDRissueDate = bShow;
}
//是否显示准驾车型
+(BOOL) getNoShowDRdriveType
{
    return bNoShowDRdriveType;
}
+(void) setNoShowDRdriveType:(BOOL)bShow
{
    bNoShowDRdriveType = bShow;
}
//是否显示有效日期
+(BOOL) getNoShowDRvalidDate
{
    return bNoShowDRvalidDate;
}
+(void) setNoShowDRvalidDate:(BOOL)bShow
{
    bNoShowDRvalidDate = bShow;
}

-(NSString *)toString
{
    /*
     @property (copy, nonatomic) NSString *name; //姓名
     @property (copy, nonatomic) NSString *sex; //性别
     @property (copy, nonatomic) NSString *nation; //国籍
     @property (copy, nonatomic) NSString *cardId; //证号(身份证号)
     @property (copy, nonatomic) NSString *address; //住址
     @property (copy, nonatomic) NSString *birth; //出生日期
     @property (copy, nonatomic) NSString *issueDate; //初次领证时间
     @property (copy, nonatomic) NSString *driveType; //准驾车型
     @property (copy, nonatomic) NSString *validDate; //有效期至日期
    */
    
    return [NSString stringWithFormat:@"姓名:%@\n性别:%@\n国籍:%@\n证号:%@\n住址:%@\n出生日期:%@\n初次领证日期:%@\n准驾车型:%@\n有效日期:%@",
            _name, _sex, _nation, _cardId, _address, _birth, _issueDate, _driveType, _validDate];
}
- (BOOL)isOK
{
    if (_name !=nil && _sex!=nil && _nation!=nil && _cardId!=nil && _address!=nil && _birth!=nil && _issueDate!=nil && _driveType!=nil && _validDate!=nil)
    {
        if (_name.length>0 && _sex.length >0 && _nation.length>0 && _cardId.length>0 && _birth.length>0 && _issueDate.length>0 && _driveType.length>0 && _validDate.length>0)   //不考虑住址
        {
            return true;
        }
    }
    return false;
}
@end
