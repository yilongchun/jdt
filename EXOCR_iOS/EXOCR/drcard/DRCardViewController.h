//
//  DRCardViewController.h
//  idcard
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrCardInfo.h"

@protocol DRCamCotrllerDelegate <NSObject>
-(void)didEndRecDRWithResult:(DrCardInfo* ) DRInfo from:(id)sender;
@end

@interface DRCardViewController : UIViewController
{
    UIView         *_cameraView;
    unsigned char* _buffer;
}
- (IBAction)backAc:(id)sender;
- (IBAction)lightAc:(id)sender;
-(IBAction)photo:(id)sender;

@property (nonatomic, weak) id<DRCamCotrllerDelegate> DRCamDelegate;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic)BOOL             verify;
@end
