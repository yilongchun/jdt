//
//  LoginViewController.m
//  jdt
//
//  Created by Stephen Chin on 17/2/22.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+Color.h"
#import "MainViewController.h"
#import "PersonViewController.h"
#import "UnitViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = RGB(38, 40, 51);
    
    UIView *accountLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *accountImage = [[UIImageView alloc] initWithFrame:accountLeftView.bounds];
    accountImage.contentMode = UIViewContentModeCenter;
    accountImage.image = [UIImage imageNamed:@"2"];
    [accountLeftView addSubview:accountImage];
    _account.leftView = accountLeftView;
    _account.leftViewMode = UITextFieldViewModeAlways;
    _account.backgroundColor = RGBA(255, 255, 255, 0.3);
    [_account setValue:RGBA(204, 204, 204, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:accountLeftView.bounds];
    passwordImage.contentMode = UIViewContentModeCenter;
    passwordImage.image = [UIImage imageNamed:@"3"];
    [passwordLeftView addSubview:passwordImage];
    _password.leftView = passwordLeftView;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.backgroundColor = RGBA(255, 255, 255, 0.3);
    [_password setValue:RGBA(204, 204, 204, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
    
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    ViewBorderRadius(_loginBtn, 5, 0, RGB(29, 206, 119));
    
    
    _loginBtn.titleLabel.font = DEFAULT_FONT;
    
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

-(void)login{
//    [self showHudInView:self.view];
//    
//    [self hideHud];
    
    
    
    
    
    
    NSMutableArray *vcs = [NSMutableArray array];
    
    PersonViewController *vc1 = [PersonViewController new];
    vc1.title = @"个人";
    [vcs addObject:vc1];
    
    UnitViewController *vc2 = [UnitViewController new];
    vc2.title = @"单位";
    [vcs addObject:vc2];
    
    MainViewController *slideSegmentController = [[MainViewController alloc] initWithViewControllers:vcs];
    slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    slideSegmentController.indicatorColor = [UIColor blackColor];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:slideSegmentController];
    [nc.navigationBar setTintColor:[UIColor blackColor]];
    
    [self presentViewController:nc animated:YES completion:^{
//        self.view.window.rootViewController = slideSegmentController;
    }];
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
