//
//  IDCardResultController.h
//  EXOCR
//
//  Created by z on 15/7/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IdInfo.h"
#import "IDCardViewController.h"


@protocol IDRstEditDelegate <NSObject>
-(void)returnIDResult:(IdInfo* ) idInfo from:(id)sender;
@end


@interface IDCardResultViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, IDCamCotrllerDelegate>  {
    UIImageView * frontFullImageView;
    UIImageView * backFullImageView;
    
    UIButton *frontBtn;
    
    UILabel * nameLable;
    UITextField * nameValueTextField;
    UIImageView * faceImageView;
    
    UILabel * sexLabel;
    UITextField * sexValueTextField;
  
    UILabel * nationLabel;
    UITextField * nationValueTextField;
    
    UILabel * birthdayLabel;
    UITextField * birthdayTextField;
    
    UILabel * birthdayYearLabel;
    UITextField * birthdayYearTextField;
    
    UILabel * birthdayMonthLabel;
    UITextField * birthdayMonthTextField;
    
    UILabel * birthdayDayLabel;
    UITextField * birthdayDayTextField;
    
    UILabel * addressLabel;
    UITextView * addressValueTextView;
    UITextField * addressValueTextField;
    
    UILabel * codeLabel;
    UITextField * codeValueTextField;
    
    UIButton *backBtn;
    
    UILabel * issueLabel;
    UITextField * issueValueTextField;
    
    UILabel * validLabel;
    UITextField * validValueTextField;
    
}

@property (nonatomic, weak) id<IDRstEditDelegate> delegate;
@property (nonatomic) IdInfo * IDInfo;
@end
