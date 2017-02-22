//
//  IDCardViewController.h
//  idcard
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdInfo.h"

@protocol IDCamCotrllerDelegate <NSObject>
-(void)didEndRecIDWithResult:(IdInfo* ) idInfo from:(id)sender;
@end

@interface IDCardViewController : UIViewController
{
    UIView         *_cameraView;
    unsigned char* _buffer;
    
    UILabel *codeLabel; //身份证号
    UILabel *nameLabel; //姓名
    UILabel *genderLabel; //性别
    UILabel *nationLabel; //民族
    UILabel *addressLabel; //地址
    UILabel *issueLabel; //签发机关
    UILabel *validLabel; //地址
    
    UIImageView * faceImgView; //头像
}

@property (nonatomic)BOOL             verify;
- (IBAction)backAc:(id)sender;
- (IBAction)lightAc:(id)sender;
- (IBAction)photo:(id)sender;

@property (nonatomic, weak) id<IDCamCotrllerDelegate> IDCamDelegate;
@property (nonatomic, assign) BOOL bShouldFront;

@end
