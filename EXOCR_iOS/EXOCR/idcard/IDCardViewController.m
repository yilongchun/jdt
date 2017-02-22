//
//  IDCardViewController.m
//  idcard
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//
@import MobileCoreServices;
@import ImageIO;
#import "IDCardViewController.h"
#import "./camera/IDCameraController.h"
#import "./camera/IDFrameView.h"
#import "IdInfo.h"
#import "photo/IDPhoto.h"
#import "../cardcore/DictManager.h"


#define PROMPT_FRONT    @"请将身份证放在屏幕中央，正面朝上"
#define PROMPT_BACK     @"请将身份证放在屏幕中央，背面朝上"

#define ERROR_FRONT     @"检测到身份证背面，请将正面朝上"
#define ERROR_BACK      @"检测到身份证正面，请将背面朝上"
//判断系统版本
#define IS_LOWER_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)

#define IS_IPHONE       ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface IDCardViewController ()<IDRecDelegate, IDPhotoDelegate, UIAlertViewDelegate>
{
    CGRect frameBounders;
    UILabel *supportLabel;
}
@property (nonatomic, strong) IDCameraController * cameraController;
@property (strong, nonatomic) IDFrameView * frameView;
@property (nonatomic, assign) BOOL bLastWrong;
@property (nonatomic, assign) BOOL bDoubleCheck;
@property(nonatomic, strong) IBOutlet UIButton *logoBtn;
@property(nonatomic, strong) IBOutlet UIButton *photoBtn;
@property(nonatomic, strong) IDPhoto *photo;
@property(nonatomic, assign) BOOL bphotoReco;

@end

@implementation IDCardViewController
@synthesize IDCamDelegate;
@synthesize photo;
@synthesize bphotoReco;

int lastCardsLength = 5;
NSArray * lastCards;
int compareCount = 0;
int lastCardsIndex = 0;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

CGRect getIDPreViewFrame( int previewWidth, int previewHeight)
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
    CGRect r = CGRectMake(lft, top, cardw, cardh);
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

-(void)disableDoubleCheck
{
    if (self.isViewLoaded && self.view.window) {    //当前viewController正在显示
        NSLog(@"close double-check");
        self.bDoubleCheck = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.bDoubleCheck = [IdInfo shouldEnableDoubleCheck];
    if(self.bDoubleCheck) {
        NSLog(@"open double-check");
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(disableDoubleCheck) userInfo:nil repeats:NO];
    }
    compareCount = 0;
    self.cameraController.bShouldStop = NO;
    self.cameraController.bHasResult = NO;
    
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
    if (self.bShouldFront) {
        _frameView.promptLabel.text = PROMPT_FRONT;
    } else {
        _frameView.promptLabel.text = PROMPT_BACK;
    }
    
}

- (IDCameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[IDCameraController alloc] init];
    }
    return _cameraController;
}

-(IDFrameView*)frameView
{
    if(!_frameView)
    {
        CGRect rect = getIDPreViewFrame(frameBounders.size.width, frameBounders.size.height);
        _frameView = [[IDFrameView alloc] initWithFrame:rect];
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
   
    lastCards = [[NSArray alloc] initWithObjects:[IdInfo new],[IdInfo new], [IdInfo new], [IdInfo new], [IdInfo new],  nil];
    
    self.navigationItem.title = @"返回";
    frameBounders = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:self.frameView atIndex:0];
    float viewAlpha = 0.5;
    
    CGRect frameRct = getIDPreViewFrame(frameBounders.size.width, frameBounders.size.height);
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
    
    if (DISPLAY_LOGO_ID) {
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
    
    self.cameraController.sessionPreset = AVCaptureSessionPreset1280x720;
    
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraController.captureSession];
        preLayer.frame = frameBounders;
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

- (IBAction)backAc:(id)sender {
    self.cameraController.bShouldStop = YES;
    
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
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
    NSLog(@"ID Photo");
    if(![self.cameraController.captureSession isRunning]) {
        self.photo = [[IDPhoto alloc] init];
        ((IDPhoto *)self.photo).target = self;
        ((IDPhoto *)self.photo).delegate = self;
        [self.photo photoReco];
    }
}

#pragma mark - IDRecDelegate
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

-(BOOL)checkIDResult:(IdInfo *)cardcur
{
    if (!self.bDoubleCheck) {
        NSLog(@"disable double-check");
        return YES;
    } else {
        NSLog(@"enable double-check");
    }
    
    if(compareCount++ > 50){
        return true;
    }
    
    IdInfo * cardlast;
    for(int i = 0; i < lastCardsLength; i++ ){
        if(lastCards[i] != nil){
            cardlast = lastCards[i];
            if(cardlast.type == 1  && cardcur.type == 1){
               
                if ([cardlast.name compare:cardcur.name] == NSOrderedSame &&
                    [cardlast.gender compare:cardcur.gender] == NSOrderedSame &&
                    [cardlast.nation compare:cardcur.nation] == NSOrderedSame &&
                    [cardlast.address compare:cardcur.address] == NSOrderedSame &&
                    [cardlast.code compare:cardcur.code] == NSOrderedSame){
                    //Log.e("比对成功",  String.valueOf(i));
                    return true;
                }
            }else if(cardlast.type == 2  && cardcur.type == 2){
                if ([cardlast.issue compare:cardcur.issue] == NSOrderedSame &&
                    [cardlast.valid compare:cardcur.valid] == NSOrderedSame){
                    //Log.e("比对成功",  String.valueOf(i));
                    return true;
                }
            }
        }
    }
    
    lastCardsIndex++;
    if(lastCardsIndex + 1 > lastCardsLength) {
        lastCardsIndex = 0;
    }
//    if(lastCards[lastCardsIndex] == nil){
//        lastCards[lastCardsIndex] = new EXIDCardResult();
//    }
    ((IdInfo*)lastCards[lastCardsIndex]).type = cardcur.type;
    if(cardcur.type == 1){
        ((IdInfo*)lastCards[lastCardsIndex]).gender = [NSString stringWithString:cardcur.gender];
        ((IdInfo*)lastCards[lastCardsIndex]).nation = [NSString stringWithString:cardcur.nation];
        ((IdInfo*)lastCards[lastCardsIndex]).code = [NSString stringWithString:cardcur.code];
        ((IdInfo*)lastCards[lastCardsIndex]).address = [NSString stringWithString:cardcur.address];
        ((IdInfo*)lastCards[lastCardsIndex]).name = [NSString stringWithString:cardcur.name];
    }else if(cardcur.type == 2){
        ((IdInfo*)lastCards[lastCardsIndex]).valid = [NSString stringWithString:cardcur.valid];
        ((IdInfo*)lastCards[lastCardsIndex]).issue = [NSString stringWithString:cardcur.issue];
    }
    //Log.e("比对失败",  String.valueOf(lastCardsIndex));
    return false;
    
    
    
    
    
}

-(void)IDCardRecognited:(IdInfo*)idInfo
{
    self.cameraController.bShouldStop = YES;
    self.cameraController.bHasResult = YES;
    
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    
    if ((idInfo.type == 1 && self.bShouldFront) || (idInfo.type == 2 && !self.bShouldFront)) {
        self.bLastWrong = NO;
        [IDCamDelegate didEndRecIDWithResult:idInfo from:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (!self.bLastWrong) {
            _frameView.promptLabel.textColor = [UIColor redColor];
            if (self.bShouldFront) {
                _frameView.promptLabel.text = ERROR_FRONT;
            } else if (!self.bShouldFront){
                _frameView.promptLabel.text = ERROR_BACK;
            }
            [self performSelector:@selector(setDefaultPrompt) withObject:nil afterDelay:2.0f];
            self.bLastWrong = YES;
        }
        self.cameraController.bShouldStop = NO;
        self.cameraController.bHasResult = NO;
        
        if([self.cameraController.captureSession isRunning] == NO)
        {
            [self.cameraController.captureSession startRunning];
            [self.cameraController resetRecParams];
        }
    }
}

-(void)setDefaultPrompt
{
    _frameView.promptLabel.textColor = [UIColor greenColor];
    if (self.bShouldFront) {
        _frameView.promptLabel.text = PROMPT_FRONT;
    } else if (!self.bShouldFront){
        _frameView.promptLabel.text = PROMPT_BACK;
    }
    self.bLastWrong = NO;
}
#pragma mark - IDPhotoDelegate
-(void)returnIDPhotoResult:(IdInfo *)idInfo from:(id)sender
{
    [IDCamDelegate didEndRecIDWithResult:idInfo from:self];
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
