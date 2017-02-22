//
//  DRPhoto.h
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DrCardInfo;
@protocol DRPhotoDelegate <NSObject>
@required
-(void)didEndPhotoRecDRWithResult:(DrCardInfo *)drInfo from:(id)sender;
@optional
-(void)didFinishPhotoRec;
@end

@interface DRPhoto : NSObject <UIImagePickerControllerDelegate>

@property(nonatomic, weak)UIViewController *target;

-(void) photoReco;

@property (nonatomic, weak) id<DRPhotoDelegate> delegate;
@end
