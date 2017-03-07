//
//  IDCardViewController.m
//  idcard
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//
@import MobileCoreServices;
@import ImageIO;
#import "DRCardViewController.h"
#import "./camera/DRCameraController.h"
#import "./camera/DRFrameView.h"
#import "DrCardInfo.h"
#import "photo/DRPhoto.h"
#import "DRCardResultViewController.h"
#import "../cardcore/DictManager.h"

//判断系统版本
#define IS_LOWER_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)

#define IS_IPHONE       ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface DRCardViewController ()<DRRecDelegate, DRPhotoDelegate, UIAlertViewDelegate>
{
    CGRect frameBounders;
    UILabel *supportLabel; 
}
@property (nonatomic, strong) DRCameraController * cameraController;
@property (strong, nonatomic) DRFrameView * frameView;
@property(nonatomic, strong) IBOutlet UIButton *logoBtn;
@property(nonatomic, strong) IBOutlet UIButton *photoBtn;
@property(nonatomic, strong) DRPhoto *photo;
@property(nonatomic, assign) BOOL bphotoReco;

@end

@implementation DRCardViewController
@synthesize DRCamDelegate;
@synthesize photo;
@synthesize bphotoReco;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

CGRect getDRPreViewFrame( int previewWidth, int previewHeight)
{
    float cardh, cardw;
    float lft, top;
    
    //cardw = previewWidth*70/100;
    if (IS_IPHONE) {
        cardw = previewWidth*95/100;
    } else {
        cardw = previewWidth*80/100;
    }
    if(previewWidth < cardw)
        cardw = previewWidth;
    
    cardh = (float)(cardw / 0.63084f);
    
    lft = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    CGRect r = CGRectMake(lft, top + 20, cardw, cardh);
    return r;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.cameraController.bShouldStop = NO;
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (![DictManager hasInit]) {
        if([self.cameraController.captureSession isRunning])
        {
            [self.cameraController.captureSession stopRunning];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"识别核心初始化失败，请检查授权并重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if([self.cameraController.captureSession isRunning] == NO && bphotoReco == NO)
    {
        [self.cameraController.captureSession startRunning];
        [self.cameraController resetRecParams];
    }
}

- (DRCameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[DRCameraController alloc] init];
    }
    return _cameraController;
}

-(DRFrameView*)frameView
{
    if(!_frameView)
    {
        CGRect rect = getDRPreViewFrame(frameBounders.size.width, frameBounders.size.height);
        _frameView = [[DRFrameView alloc] initWithFrame:rect];
    }
    return _frameView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)dealloc {
    [self.frameView.timer invalidate];
    [self.frameView.line_timer invalidate];
    self.frameView.timer = nil;
    self.frameView.line_timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    frameBounders = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:self.frameView atIndex:0];
    
    float viewAlpha = 0.5;
    
    CGRect frameRct = getDRPreViewFrame(frameBounders.size.width, frameBounders.size.height);
    CGRect topFrame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frameRct.origin.y);
    
    UIView * uiTop = [[UIView alloc] initWithFrame:topFrame];
    [uiTop setBackgroundColor:[UIColor blackColor]];
    uiTop.alpha = viewAlpha;
    [self.view insertSubview:uiTop atIndex:0];
    
    CGRect leftFrame =  CGRectMake(0, frameRct.origin.y, frameRct.origin.x, frameRct.size.height);
    UIView * uiLeft = [[UIView alloc] initWithFrame:leftFrame];
    [uiLeft setBackgroundColor:[UIColor blackColor]];
    uiLeft.alpha = viewAlpha;
    [self.view insertSubview:uiLeft atIndex:0];
    
    CGRect rightFrame =  CGRectMake(frameRct.origin.x + frameRct.size.width, frameRct.origin.y , frameBounders.size.width - (frameRct.origin.x + frameRct.size.width), frameRct.size.height);
    
    UIView * uiRight = [[UIView alloc] initWithFrame:rightFrame];
    [uiRight setBackgroundColor:[UIColor blackColor]];
    uiRight.alpha = viewAlpha;
    [self.view insertSubview:uiRight atIndex:0];
    
    CGRect bottomFrame =  CGRectMake(0, frameRct.origin.y + frameRct.size.height, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - (frameRct.origin.y + frameRct.size.height ) );
    
    UIView * uiBottom = [[UIView alloc] initWithFrame:bottomFrame];
    [uiBottom setBackgroundColor:[UIColor blackColor]];
    uiBottom.alpha = viewAlpha;
    [self.view insertSubview:uiBottom atIndex:0];
    
    if (!IS_LOWER_IOS7) { //IOS7 IOS8
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString * prodName =[infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString * msgBody = @"\n请打开开关，设置－>隐私－>相机－>";
        if(prodName == nil){
            prodName = @"程序";
        }
        msgBody = [msgBody stringByAppendingString:prodName];
        if(authStatus == AVAuthorizationStatusDenied){
            NSLog(@"相机权限受限");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"相机无法启动" message:msgBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    _photoBtn.center = CGPointMake(SCREEN_WIDTH/2, _photoBtn.center.y);
    bphotoReco = NO;

    if (DISPLAY_LOGO_DR) {
        supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 50)];
        supportLabel.backgroundColor = [UIColor clearColor];
        supportLabel.textAlignment = NSTextAlignmentCenter;
        supportLabel.textColor = [UIColor lightGrayColor];
        supportLabel.font = [UIFont boldSystemFontOfSize:16];
        supportLabel.text = @"本技术由易道博识提供";
        [self.view addSubview:supportLabel];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        supportLabel.transform = transform;
        supportLabel.center = CGPointMake(20, SCREEN_HEIGHT/2);
    } else {
        _logoBtn.hidden = YES;
    }
    
    self.cameraController.recDelegate = self;
    
    //    [self.view insertSubview:self.previewView atIndex:0];
    
    self.cameraController.sessionPreset = AVCaptureSessionPreset1280x720;
    
    //    self.overlayView.session = self.cameraController.captureSession;
    
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraController.captureSession];
        preLayer.frame = frameBounders;// CGRectMake(0, 0, 320, 240);
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:preLayer];
        
        [self.cameraController startSession];
    }
    else {
        NSLog(@"%@", error.localizedDescription);
    }
    
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
-(CGRect)getEffectImageRect:(CGSize)size
{
    //    CGSize size = image.extent.size;
//    CGSize size2 = frameBounders.size;
    CGSize size2 = CGSizeMake(frameBounders.size.height, frameBounders.size.width);
    CGPoint pt;
    if(size.width/size.height > size2.width/size2.height)
    {
        float oldW = size.width;
        size.width = size2.width / size2.height * size.height;
        pt.x = (oldW - size.width)/2;
        pt.y = 0;
    }
    else
    {
        float oldH = size.height;
        size.height = size2.height / size2.width * size.width;
        pt.x = 0;
        pt.y = (oldH - size.height)/2;;
    }
    return CGRectMake(pt.x, pt.y, size.width, size.height);
}

-(void)DRCardRecognited:(DrCardInfo*)drInfo
{
    self.cameraController.bHasResult = YES;
    self.cameraController.bShouldStop = YES;

    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    
    [DRCamDelegate didEndRecDRWithResult:drInfo from:self];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)backAc:(id)sender {
    //self.cameraController.bHasResult = TRUE;
    self.cameraController.bShouldStop = YES;
    
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    
    //    IDCardResultViewController * IDRstVc = [[IDCardResultViewController alloc] init];
    //    IDRstVc.IDInfo = nil;
    //    //IDRstVc.delegate =self;
    //    //[self presentViewController:editVc animated:YES completion:nil];
    //    [self.navigationController pushViewController:IDRstVc animated:YES];
    
     [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)lightAc:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(btn.selected == NO)
    {
        btn.selected = YES;
        self.cameraController.torchMode = AVCaptureTorchModeOn;
    }
    else
    {
        btn.selected = NO;
        self.cameraController.torchMode = AVCaptureTorchModeOff;
        
    }
}

-(IBAction)photo:(id)sender {
    bphotoReco = YES;
    self.cameraController.bHasResult = YES;
    self.cameraController.bShouldStop = YES;
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    NSLog(@"DR Photo");
    if(![self.cameraController.captureSession isRunning]) {
        self.photo = [[DRPhoto alloc] init];
        ((DRPhoto *)self.photo).target = self;
        ((DRPhoto *)self.photo).delegate = self;
        [self.photo photoReco];
    }
}
#pragma mark - DRPhotoDelegate
- (void)didEndPhotoRecDRWithResult:(DrCardInfo *)drInfo from:(id)sender
{
//    if (![DrCardInfo getNoShowDRResultView]) {
//        DRCardResultViewController *drc = [[DRCardResultViewController alloc] init];
//        drc.DRInfo = drInfo;
//        [self.navigationController pushViewController:drc animated:YES];
//    }
    
    [DRCamDelegate didEndRecDRWithResult:drInfo from:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didFinishPhotoRec
{
    bphotoReco = NO;
    if([self.cameraController.captureSession isRunning] == NO && bphotoReco == NO)
    {
        [self.cameraController.captureSession startRunning];
        [self.cameraController resetRecParams];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
