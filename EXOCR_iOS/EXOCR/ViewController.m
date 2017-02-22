//
//  ViewController.m
//  EXOCR
//
//  Created by z on 15/7/14.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "DictManager.h"

#import "idcard/IDCardViewController.h"
#import "idcard/IDCardResultViewController.h"

#import "drcard/DRCardViewController.h"
#import "drcard/DRCardResultViewController.h"

#import "AboutViewController.h"


#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)


@interface ViewController ()<IDRstEditDelegate, DRCamCotrllerDelegate>
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    //配置结果页及条目
    /*身份证*/
//    [IdInfo setNoShowIDName:YES];
//    [IdInfo setNoShowIDOffice:YES];
//    [IdInfo setNoShowIDBackFullImg:YES];
//    [IdInfo setNoShowIDAddress:YES];
//    
//    [IdInfo setNoShowIDBirth:YES];
//    [IdInfo setNoShowIDFrontFullImg:YES];
//    [IdInfo setNoShowIDFaceImg:YES];
//    [IdInfo setNoShowIDSex:YES];
//    [IdInfo setNoShowIDNation:YES];
//    [IdInfo setNoShowIDValid:YES];
//    [IdInfo setNoShowIDCode:YES];
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationController.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGBA(0xf0eff5,1)];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [DictManager InitDict];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    //返回键颜色
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    //导航栏颜色
//    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGBA(0x0FA5E0,1)];
  
    //banner
    CGRect bannerRect = CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT / 3);
    UIImageView * banner;
    if (DISPLAY_LOGO_MAIN) {
        banner = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"exocr-bar.png"]] ;
    } else {
        banner = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"exocr-bar_nologo.png"]] ;
    }
    [banner setFrame:bannerRect];
    [self.view addSubview:banner];
    
    //银行卡识别
    CGRect bankCardRect = CGRectMake(0, bannerRect.size.height, SCREEN_WIDTH * 2 / 3,  SCREEN_HEIGHT / 6);
    UIImageView * bankCardImgView = [[UIImageView alloc] initWithFrame:bankCardRect];
    [bankCardImgView setImage:[UIImage imageNamed:@"exocr-bankCard.png"]];
    bankCardImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapBankCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankCardClick)];
    [bankCardImgView addGestureRecognizer:singleTapBankCard];
    [self.view addSubview:bankCardImgView];
    
    //身份证识别
    CGRect IDCardRect = CGRectMake(0, bankCardRect.origin.y + bankCardRect.size.height, SCREEN_WIDTH * 2 / 3,  SCREEN_HEIGHT / 6);
    UIImageView * IDCardImgView = [[UIImageView alloc] initWithFrame:IDCardRect];
    [IDCardImgView setImage:[UIImage imageNamed:@"exocr-IDCard.png"]];
    IDCardImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapIDCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IDCardClick)];
    [IDCardImgView addGestureRecognizer:singleTapIDCard];
    [self.view addSubview:IDCardImgView];
    
    //充值卡识别
    CGRect PPCardRect = CGRectMake(SCREEN_WIDTH * 2 / 3, bannerRect.size.height, SCREEN_WIDTH / 3,  SCREEN_HEIGHT / 6);
    UIImageView * PPCardImgView = [[UIImageView alloc] initWithFrame:PPCardRect];
    [PPCardImgView setImage:[UIImage imageNamed:@"exocr-PPSCard.png"]];
    PPCardImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTapPPCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CZKCardClick)];
    [PPCardImgView addGestureRecognizer:singleTapPPCard];
    [self.view addSubview:PPCardImgView];
    
    //行驶证识别
    CGRect VECardRect = CGRectMake(SCREEN_WIDTH * 2 / 3, PPCardRect.origin.y + PPCardRect.size.height, SCREEN_WIDTH / 3,  SCREEN_HEIGHT / 6);
    UIImageView * VECardImgView = [[UIImageView alloc] initWithFrame:VECardRect];
    [VECardImgView setImage:[UIImage imageNamed:@"exocr-VECard.png"]];
    VECardImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTapVECard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(VECardClick)];
    [VECardImgView addGestureRecognizer:singleTapVECard];
    [self.view addSubview:VECardImgView];
    
    //驾驶证识别
    CGRect DRCardRect = CGRectMake(0, IDCardRect.origin.y + IDCardRect.size.height, SCREEN_WIDTH / 3,  SCREEN_HEIGHT / 6);
    UIImageView * DRCardImgView = [[UIImageView alloc] initWithFrame:DRCardRect];
    [DRCardImgView setImage:[UIImage imageNamed:@"exocr-DRCard.png"]];
    DRCardImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTapDRCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DRCardClick)];
    [DRCardImgView addGestureRecognizer:singleTapDRCard];
    [self.view addSubview:DRCardImgView];
    
    //人脸识别
    CGRect FaceRect = CGRectMake(SCREEN_WIDTH / 3, IDCardRect.origin.y + IDCardRect.size.height, SCREEN_WIDTH / 3,  SCREEN_HEIGHT / 6);
    UIImageView * FaceImgView = [[UIImageView alloc] initWithFrame:FaceRect];
    [FaceImgView setImage:[UIImage imageNamed:@"exocr-Face.png"]];
    FaceImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTapFace = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FaceClick)];
    [FaceImgView addGestureRecognizer:singleTapFace];
    [self.view addSubview:FaceImgView];
    
    //二维码识别
    CGRect QRRect = CGRectMake(SCREEN_WIDTH * 2 / 3, IDCardRect.origin.y + IDCardRect.size.height, SCREEN_WIDTH / 3,  SCREEN_HEIGHT / 6);
    UIImageView * QRImgView = [[UIImageView alloc] initWithFrame:QRRect];
    [QRImgView setImage:[UIImage imageNamed:@"exocr-QR.png"]];
    QRImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTapQR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QRClick)];
    [QRImgView addGestureRecognizer:singleTapQR];
    [self.view addSubview:QRImgView];

    //易填表
    CGRect PhotoImportRect = CGRectMake(0, DRCardRect.origin.y + DRCardRect.size.height, SCREEN_WIDTH * 2 / 3,  SCREEN_HEIGHT / 6);
    UIImageView * PhotoImportImgView = [[UIImageView alloc] initWithFrame:PhotoImportRect];
    [PhotoImportImgView setImage:[UIImage imageNamed:@"exocr-form.png"]];
    PhotoImportImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTapPhotoImport = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FormClick)];
    [PhotoImportImgView addGestureRecognizer:singleTapPhotoImport];
    [self.view addSubview:PhotoImportImgView];
    
    //关于
    CGRect AboutRect = CGRectMake(SCREEN_WIDTH * 2 / 3, PhotoImportRect.origin.y, SCREEN_WIDTH / 3,  SCREEN_HEIGHT / 6);
    UIImageView * AboutImgView = [[UIImageView alloc] initWithFrame:AboutRect];
    [AboutImgView setImage:[UIImage imageNamed:@"exocr-about.png"]];
    AboutImgView.userInteractionEnabled = YES;
    if (DISPLAY_LOGO_MAIN) {
        UITapGestureRecognizer * singleTapAbout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AboutClick)];
        [AboutImgView addGestureRecognizer:singleTapAbout];
    }
    [self.view addSubview:AboutImgView];
}

#pragma mark 银行卡
-(void)bankCardClick{
}

#pragma mark 身份证
-(void)IDCardClick{
    IDCardResultViewController *IDRstVc = [[IDCardResultViewController alloc] init];
    IDRstVc.delegate = self;
    [self.navigationController pushViewController:IDRstVc animated:YES];
}
-(void)returnIDResult:(IdInfo* ) idInfo from:(id)sender
{
    
}

#pragma mark 充值卡
-(void)CZKCardClick{
}

#pragma mark 行驶证
-(void)VECardClick{
}

#pragma mark 二维码
-(void)QRClick{
}

#pragma mark 驾驶证
-(void)DRCardClick{
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

#pragma mark 人脸
-(void)FaceClick{
    
}

#pragma mark 易填表
-(void)FormClick{
}

#pragma mark 关于
-(void)AboutClick{
    AboutViewController * abController = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil  action:nil];
    [self.navigationController pushViewController:abController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [DictManager FinishDict];
}

@end
