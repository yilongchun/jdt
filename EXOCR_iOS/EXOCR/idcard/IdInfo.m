//
//  IdInfo.m
//  exid
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//

#import "IdInfo.h"

#import "sys/sysctl.h"

static BOOL bNoShowIDFaceImg = NO;
static BOOL bNoShowIDName = NO;
static BOOL bNoShowIDSex = NO;
static BOOL bNoShowIDNation = NO;
static BOOL bNoShowIDBirth = NO;
static BOOL bNoShowIDAddress = NO;
static BOOL bNoShowIDCode = NO;
static BOOL bNoShowIDOffice = NO;
static BOOL bNoShowIDValid = NO;
static BOOL bNoShowIDFrontFullImg = NO;
static BOOL bNoShowIDBackFullImg = NO;

@implementation IdInfo

+(void)setNoShowIDFaceImg:(BOOL)bShow
{
    bNoShowIDFaceImg = bShow;
}
+(BOOL)getNoShowIDFaceImg
{
    return bNoShowIDFaceImg;
}
+ (void)setNoShowIDName:(BOOL)bShow
{
    bNoShowIDName = bShow;
}
+(BOOL)getNoShowIDName
{
    return bNoShowIDName;
}
+ (void)setNoShowIDSex:(BOOL)bShow
{
    bNoShowIDSex = bShow;
}
+(BOOL)getNoShowIDSex
{
    return bNoShowIDSex;
}
+ (void)setNoShowIDNation:(BOOL)bShow
{
    bNoShowIDNation = bShow;
}
+(BOOL)getNoShowIDNation
{
    return bNoShowIDNation;
}
+ (void)setNoShowIDBirth:(BOOL)bShow
{
    bNoShowIDBirth = bShow;
}
+(BOOL)getNoShowIDBirth
{
    return bNoShowIDBirth;
}
+ (void)setNoShowIDAddress:(BOOL)bShow
{
    bNoShowIDAddress = bShow;
}
+(BOOL)getNoShowIDAddress
{
    return bNoShowIDAddress;
}
+ (void)setNoShowIDCode:(BOOL)bShow
{
    bNoShowIDCode = bShow;
}
+(BOOL)getNoShowIDCode
{
    return bNoShowIDCode;
}
+ (void)setNoShowIDOffice:(BOOL)bShow
{
    bNoShowIDOffice = bShow;
}
+(BOOL)getNoShowIDOffice
{
    return bNoShowIDOffice;
}
+ (void)setNoShowIDValid:(BOOL)bShow
{
    bNoShowIDValid = bShow;
}
+(BOOL)getNoShowIDValid
{
    return bNoShowIDValid;
}
+ (void)setNoShowIDFrontFullImg:(BOOL)bShow
{
    bNoShowIDFrontFullImg = bShow;
}
+(BOOL)getNoShowIDFrontFullImg
{
    return bNoShowIDFrontFullImg;
}
+ (void)setNoShowIDBackFullImg:(BOOL)bShow
{
    bNoShowIDBackFullImg = bShow;
}
+(BOOL)getNoShowIDBackFullImg
{
    return bNoShowIDBackFullImg;
}
-(NSString *)toString
{
    return [NSString stringWithFormat:@"身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@",
            _code, _name, _gender, _nation, _address];
}

-(BOOL)isOK
{
    if (_code !=nil && _name!=nil && _gender!=nil && _nation!=nil && _address!=nil)
    {
        if (_code.length>0 && _name.length >0 && _gender.length>0 && _nation.length>0 && _address.length>0)
        {
            return true;
        }
    }
    else if (_issue !=nil && _valid!=nil)
    {
        if (_issue.length>0 && _valid.length >0)
        {
            return true;
        }
    }
    return false;
}



-(BOOL)isEqual:(IdInfo *)idInfo
{
    if (idInfo == nil)
        return false;
    
    if ((_type == idInfo.type) &&
        [_code isEqualToString:idInfo.code] &&
        [_name isEqualToString:idInfo.name] &&
        [_gender isEqualToString:idInfo.gender] &&
        [_nation isEqualToString:idInfo.nation] &&
        [_address isEqualToString:idInfo.address] &&
        [_issue isEqualToString:idInfo.issue] &&
        [_valid isEqualToString:idInfo.valid])
        return true;
    
    return false;
}

+ (BOOL)shouldEnableDoubleCheck
{
    NSString *platform = [IdInfo getDeviceVersion];
    if([[platform substringWithRange:NSMakeRange(0, 6)]isEqualToString:@"iPhone"]) {
        int version = [[platform substringWithRange:NSMakeRange(6, 1)]intValue];
        if (version >= 7) { //NOT less than ip6
            return true;
        }
    }
    if([[platform substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"iPad"]) {
        int version = [[platform substringWithRange:NSMakeRange(4, 1)]intValue];
        if (version >= 4) { //NOT less than cpu A7
            return true;
        }
    }
    return false;
}
#pragma mark 获得设备型号
+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
/*
+ (NSString *)getCurrentDeviceModel
{
    NSString *platform = [self getDeviceVersion];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
*/
@end
