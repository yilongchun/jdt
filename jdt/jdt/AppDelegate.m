//
//  AppDelegate.m
//  jdt
//
//  Created by Stephen Chin on 17/2/22.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "PersonViewController.h"
#import "UnitViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBaiduAk  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start successed!");
    }
    
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarHidden = NO;
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [ud objectForKey:LOGINED_USER];
    if (data != nil) {
//        NSMutableArray *vcs = [NSMutableArray array];
        
        PersonViewController *vc1 = [PersonViewController new];
//        vc1.title = @"个人";
//        [vcs addObject:vc1];
//        
//        UnitViewController *vc2 = [UnitViewController new];
//        vc2.title = @"单位";
//        [vcs addObject:vc2];
//        
//        MainViewController *slideSegmentController = [[MainViewController alloc] initWithViewControllers:vcs];
//        slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        slideSegmentController.indicatorColor = [UIColor blackColor];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc1];
        [nc.navigationBar setTintColor:RGB(50, 54, 66)];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = nc;
        [self.window makeKeyAndVisible];
    }else{
        LoginViewController *vc = [LoginViewController new];
        //    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        //    nc.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:kFont size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
