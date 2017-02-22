//
//  MainViewController.m
//  jdt
//
//  Created by Stephen Chin on 17/2/22.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MainViewController.h"
#import "JZNavigationExtension.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.jz_navigationBarTintColor = RGB(38, 40, 51);
    
    
    
    
//    UIBarButtonItem *bookmarksButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bookmarksButton];
//    
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    spacer.width = SPACE_BETWEEN_BUTTONS;
//    [buttons addObjectsFromArray:@[bookmarksButtonItem,spacer]];
//    
//    
//    /* ADD ALL THESE BUTTONS TO CUSTOM TOOLBAR AND TOOLBAR TO NAVIGATION BAR */
//    UIToolbar *customToolbar = [[UIToolbar alloc]
//                                initWithFrame:CGRectMake(0.0f, 0.0f, ([bottomButtons count]/2*ONE_BUTTON_TOTAL_WIDTH), 44.01f)]; // 44.01 shifts it up 1px for some reason
//    
//    customToolbar.clearsContextBeforeDrawing = NO;
//    customToolbar.clipsToBounds = NO;
//    customToolbar.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
//    customToolbar.barStyle = -1; // clear background
//    [customToolbar setItems: bottomButtons animated:NO];
//    
//    UIBarButtonItem *customUIBarButtonitem = [[UIBarButtonItem alloc] initWithCustomView:customToolbar];
//    self.navigationItem.rightBarButtonItem = customUIBarButtonitem;
    
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    [item1 setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    
    
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [item2 setTintColor:[UIColor whiteColor]];
    
    
    
    self.navigationItem.rightBarButtonItems = @[item1,item,item2];
}

-(void)submit{
    
}

-(void)save{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
