//
//  PersonViewController.m
//  jdt
//
//  Created by Stephen Chin on 17/2/22.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "PersonViewController.h"


#import "DictManager.h"

#import "IDCardViewController.h"
#import "IDCardResultViewController.h"

#import "DRCardViewController.h"
#import "DRCardResultViewController.h"

@interface PersonViewController ()<IDRstEditDelegate, DRCamCotrllerDelegate>

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [DictManager InitDict];
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

- (IBAction)action1:(id)sender {
    IDCardResultViewController *IDRstVc = [[IDCardResultViewController alloc] init];
    IDRstVc.delegate = self;
    [self.navigationController pushViewController:IDRstVc animated:YES];
}
-(void)returnIDResult:(IdInfo* ) idInfo from:(id)sender
{
    
}

- (IBAction)action2:(id)sender {
    DRCardViewController * controller = [[DRCardViewController alloc] initWithNibName:nil bundle:nil];
    controller.DRCamDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)didEndRecDRWithResult:(DrCardInfo* ) drInfo from:(id)sender{
    __weak UIViewController * vc = (UIViewController*)sender;
    
    if (![DrCardInfo getNoShowDRResultView]) {
        if(drInfo != nil)
        {
            DRCardResultViewController * DRRstVc = [[DRCardResultViewController alloc] init];
            DRRstVc.DRInfo = drInfo;
            [vc.navigationController pushViewController:DRRstVc animated:NO];
            NSLog(@"push drCardResultViewController");
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)dealloc {
    [DictManager FinishDict];
}
@end
