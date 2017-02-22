//
//  PersonViewController.m
//  jdt
//
//  Created by Stephen Chin on 17/2/22.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "PersonViewController.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"

#import "DictManager.h"

#import "IDCardViewController.h"
#import "IDCardResultViewController.h"

#import "DRCardViewController.h"
#import "DRCardResultViewController.h"

@interface PersonViewController ()<IDCamCotrllerDelegate>{
    UITextField *tf1;
    UITextField *tf2;
    UITextField *tf3;
}

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.jz_navigationBarTintColor = RGB(50, 54, 66);
    
    [DictManager InitDict];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"个人设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    [item1 setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = item1;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 130, 40)];
    label1.text = @"寄件人姓名";
    label1.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label1];
    
    tf1 = [[UITextField alloc] initWithFrame:CGRectMake(150, 20, Main_Screen_Width - 150 -20, 40)];
    tf1.borderStyle = UITextBorderStyleNone;
    tf1.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label1.frame) + 40, 130, 40)];
    label2.text = @"身份证号码";
    label2.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label2];
    
    tf2 = [[UITextField alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(label1.frame) + 40, Main_Screen_Width - 150 -20, 40)];
    tf2.borderStyle = UITextBorderStyleNone;
    tf2.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label2.frame) + 40, 130, 40)];
    label3.text = @"寄件人手机号码";
    label3.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label3];
    
    tf3 = [[UITextField alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(label2.frame) + 40, Main_Screen_Width - 150 -20, 40)];
    tf3.borderStyle = UITextBorderStyleNone;
    tf3.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label3.frame) + 80, 150, 40)];
    label4.text = @"寄递物品验视照片";
    label4.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label4];
    
    UIButton *imgBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(label3.frame) + 40, 80, 80)];
    [imgBtn1 setImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    [_myScrollView addSubview:imgBtn1];
    
    
    
    UIButton *idcardBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgBtn1.frame) + 20, Main_Screen_Width - 30, 40)];
    [idcardBtn addTarget:self action:@selector(IDCardClick) forControlEvents:UIControlEventTouchUpInside];
    [idcardBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    [idcardBtn setTitle:@" 身份证扫描" forState:UIControlStateNormal];
    [idcardBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_myScrollView addSubview:idcardBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setting{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)IDCardClick{
//    IDCardResultViewController *IDRstVc = [[IDCardResultViewController alloc] init];
//    IDRstVc.delegate = self;
//    [self.navigationController pushViewController:IDRstVc animated:YES];
    
    
    IDCardViewController * IDCardController = [[IDCardViewController alloc] init];
    IDCardController.IDCamDelegate = self;
//    if (sender.tag == FRONT_TAG) {
        IDCardController.bShouldFront = YES;//正面
//    } else {
//        IDCardController.bShouldFront = NO;
//    }
    [self.navigationController pushViewController:IDCardController animated:YES];
    
}
-(void)didEndRecIDWithResult:(IdInfo* ) idInfo from:(id)sender
{
    if (idInfo.type != 0) { //识别成功
        DLog(@"%@",idInfo);
        tf1.text = idInfo.code;
        tf2.text = idInfo.name;
//        IDInfo = idInfo;
//        [self.delegate returnIDResult:idInfo from:self];
//        [self loadData];
    }else{
        DLog(@"识别失败");
    }
}

- (IBAction)action2:(id)sender {
//    DRCardViewController * controller = [[DRCardViewController alloc] initWithNibName:nil bundle:nil];
//    controller.DRCamDelegate = self;
//    [self.navigationController pushViewController:controller animated:YES];
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
