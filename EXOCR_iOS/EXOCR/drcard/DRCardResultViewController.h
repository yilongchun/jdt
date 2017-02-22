//
//  IDCardResultController.h
//  EXOCR
//
//  Created by z on 15/7/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DrCardInfo.h"

@interface DRCardResultViewController : UIViewController<UITextFieldDelegate>  {
    UIImageView * fullImageView;
    
    UILabel * nameLable;
    UITextField * nameValue;
    
    UILabel * sexLabel;
    UITextField * sexValue;
  
    UILabel * nationLabel;
    UITextField * nationValue;
    
    UILabel * cardIdLabel;
    UITextField * cardIdValue;
    
    UILabel * addressLabel;
    UITextField * addressValue;
    
    UILabel * birthLabel;
    UITextField * birthValue;
    
    UILabel * issueDateLabel;
    UITextField * issueDateValue;
    
    UILabel * driveTypeLabel;
    UITextField * driveTypeValue;
    
    UILabel * validDateLabel;
    UITextField * validDateValue;
}

@property (nonatomic) DrCardInfo * DRInfo;
@end
