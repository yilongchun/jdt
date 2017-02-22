//
//  IDPhoto.h
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IdInfo;
@protocol IDPhotoDelegate <NSObject>
@required
-(void)returnIDPhotoResult:(IdInfo *)idInfo from:(id)sender;
@optional
-(void)didFinishPhotoRec;
@end

@interface IDPhoto : NSObject <UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property(nonatomic, weak)UIViewController *target;

-(void) photoReco;

@property (nonatomic, weak) id<IDPhotoDelegate> delegate;
@end
