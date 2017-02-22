//
//  AboutView.m
//  EXOCR
//
//  Created by z on 15/7/24.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"易道博识";
    
    int leftMargin = 10;
    CGFloat lastY = 30;
    UIFont * font = [UIFont systemFontOfSize:18];
    
//    if (veCardInfo.plateNo != nil)
//    {
//        [plateNoLabel setText:[NSString stringWithFormat:@"号牌号码:%@", veCardInfo.plateNo]];
//        CGSize size = [plateNoLabel.text sizeWithFont:plateNoLabel.font
//                                    constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
//                                        lineBreakMode:NSLineBreakByWordWrapping];
//        [plateNoLabel setFrame:CGRectMake(3, lastY, size.width, size.height)];
//        lastY += 3 + size.height;
//        plateNoLabel.numberOfLines = 0;
//    }
    
    //bs    1264 418
    CGRect bsRect = CGRectMake(leftMargin, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4 ,  (SCREEN_WIDTH / 4) * 418 / 1264  );
    UIImageView * bsImgView = [[UIImageView alloc] initWithFrame:bsRect];
    [bsImgView setImage:[UIImage imageNamed:@"exocr-bs.png"]];
    bsImgView.userInteractionEnabled = NO;
    [self.view addSubview:bsImgView];
    lastY = bsRect.origin.y + bsRect.size.height;
    
    //company name
    UILabel * labelCompany = [[UILabel alloc] init];
    [labelCompany setText:@"北京易道博识科技有限公司 版权所有"];
    CGSize labelCompanySize = [labelCompany.text sizeWithFont:font
                                            constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    [labelCompany setFrame:CGRectMake(leftMargin, lastY, labelCompanySize.width, labelCompanySize.height)];
    labelCompany.numberOfLines = 0;
    [self.view addSubview:labelCompany];
    lastY += 3 + labelCompanySize.height;
    
    
    UILabel * labelCompanyEn = [[UILabel alloc] init];
    [labelCompanyEn setText:@"Beijing Yidao Boshi Technology Co.Ltd."];
    CGSize labelCompanyEnSize = [labelCompanyEn.text sizeWithFont:font
                                            constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    [labelCompanyEn setFrame:CGRectMake(leftMargin, lastY, labelCompanyEnSize.width, labelCompanyEnSize.height)];
    labelCompanyEn.numberOfLines = 0;
    [self.view addSubview:labelCompanyEn];
    lastY += 3 + labelCompanyEnSize.height;
    
    UILabel * labelSite = [[UILabel alloc] init];
    [labelSite setText:@"网址: www.exocr.com"];
    CGSize labelSiteSize = [labelSite.text sizeWithFont:font
                                                constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                                    lineBreakMode:NSLineBreakByWordWrapping];
    [labelSite setFrame:CGRectMake(leftMargin, lastY, labelSiteSize.width, labelSiteSize.height)];
    labelSite.numberOfLines = 0;
    [self.view addSubview:labelSite];
    lastY += 3 + labelSiteSize.height;
    
    UILabel * labelAddress = [[UILabel alloc] init];
    [labelAddress setText:@"地址: 北京市海淀区农大南路1号硅谷亮城B座606室"];
    CGSize labelAddressSize = [labelAddress.text sizeWithFont:font
                                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                          lineBreakMode:NSLineBreakByWordWrapping];
    [labelAddress setFrame:CGRectMake(leftMargin, lastY, labelAddressSize.width, labelAddressSize.height)];
    labelAddress.numberOfLines = 0;
    [self.view addSubview:labelAddress];
    lastY += 3 + labelAddressSize.height;
    

    UILabel * labelPhone = [[UILabel alloc] init];
    [labelPhone setText:@"咨询热线: 010-82176659"];
    CGSize labelPhoneSize = [labelPhone.text sizeWithFont:font
                                            constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    [labelPhone setFrame:CGRectMake(leftMargin, lastY, labelPhoneSize.width, labelPhoneSize.height)];
    labelPhone.numberOfLines = 0;
    [self.view addSubview:labelPhone];
    lastY += 3 + labelPhoneSize.height;
    
    UILabel * labelMail = [[UILabel alloc] init];
    [labelMail setText:@"邮箱: hjy@exocr.com"];
    CGSize labelMailSize = [labelMail.text sizeWithFont:font
                                            constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    [labelMail setFrame:CGRectMake(leftMargin, lastY, labelMailSize.width, labelMailSize.height)];
    labelMail.numberOfLines = 0;
    [self.view addSubview:labelMail];
    lastY += 3 + labelMailSize.height;
    
    //qr
    CGRect siteQrRect = CGRectMake(leftMargin, lastY + 30, SCREEN_WIDTH / 4 ,  SCREEN_WIDTH / 4);
    UIImageView * siteQrImgView = [[UIImageView alloc] initWithFrame:siteQrRect];
    [siteQrImgView setImage:[UIImage imageNamed:@"exocr-siteqr.png"]];
    siteQrImgView.userInteractionEnabled = NO;
    [self.view addSubview:siteQrImgView];
    
    
}



@end
