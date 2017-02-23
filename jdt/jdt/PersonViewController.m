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

#import "UserSettingViewController.h"

#import "LBXScanViewController.h"

@interface PersonViewController ()<IDCamCotrllerDelegate,DRCamCotrllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UITextField *tf1;
    UITextField *tf2;
    UITextField *tf3;
    UITextField *tf4;
    
    NSInteger btnTag;
    UIImage *image1;
    UIImage *image2;
    
    UIButton *imgBtn1;
    UIButton *imgBtn2;
    
    UILabel *countLabel;
}

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"寄递通";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]]; 
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.jz_navigationBarTintColor = RGB(50, 54, 66);
    
    [DictManager InitDict];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"个人设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    [item1 setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = item1;
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveToLocal) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:RGBA(255, 255, 255, 0.2) forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = SYSTEMFONT(17);
//    saveBtn.backgroundColor = [UIColor grayColor];
    [itemView addSubview:saveBtn];
//    itemView.backgroundColor = [UIColor whiteColor];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 70, 30)];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = SYSTEMFONT(12);
    [itemView addSubview:countLabel];
//    countLabel.backgroundColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setCount];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 130, 40)];
    label1.text = @"寄件人姓名";
    label1.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label1];
    
    tf1 = [[UITextField alloc] initWithFrame:CGRectMake(150, 20, Main_Screen_Width - 150 -20, 40)];
    tf1.borderStyle = UITextBorderStyleNone;
    tf1.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label1.frame) + 20, 130, 40)];
    label2.text = @"身份证号码";
    label2.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label2];
    
    tf2 = [[UITextField alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(label1.frame) + 20, Main_Screen_Width - 150 -20, 40)];
    tf2.borderStyle = UITextBorderStyleNone;
    tf2.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label2.frame) + 20, 130, 40)];
    label3.text = @"寄件人手机号码";
    label3.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label3];
    
    tf3 = [[UITextField alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(label2.frame) + 20, Main_Screen_Width - 150 -20, 40)];
    tf3.borderStyle = UITextBorderStyleNone;
    tf3.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label3.frame) + 40, 150, 40)];
    label4.text = @"寄递物品验视照片";
    label4.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label4];
    
    imgBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(label3.frame) + 20, 80, 80)];
    imgBtn1.tag = 1;
    [imgBtn1 setBackgroundImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    [imgBtn1 addTarget:self action:@selector(showPic:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:imgBtn1];
    UILabel *btn1Label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgBtn1.frame), CGRectGetMaxY(imgBtn1.frame) + 5, CGRectGetWidth(imgBtn1.frame), 20)];
    btn1Label.font = SYSTEMFONT(15);
    btn1Label.text = @"内件照";
    btn1Label.textColor = [UIColor grayColor];
    btn1Label.textAlignment = NSTextAlignmentCenter;
    [_myScrollView addSubview:btn1Label];
    
    imgBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 80 - 20, CGRectGetMaxY(label3.frame) + 20, 80, 80)];
    imgBtn2.tag = 2;
    [imgBtn2 setBackgroundImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    [imgBtn2 addTarget:self action:@selector(showPic:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:imgBtn2];
    UILabel *btn2Label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgBtn2.frame), CGRectGetMaxY(imgBtn2.frame) + 5, CGRectGetWidth(imgBtn2.frame), 20)];
    btn2Label.font = SYSTEMFONT(15);
    btn2Label.text = @"封箱照";
    btn2Label.textColor = [UIColor grayColor];
    btn2Label.textAlignment = NSTextAlignmentCenter;
    [_myScrollView addSubview:btn2Label];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(btn2Label.frame) + 20, 150, 40)];
    label5.text = @"寄递单号";
    label5.font = SYSTEMFONT(15);
    [_myScrollView addSubview:label5];
    
    tf4 = [[UITextField alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(btn2Label.frame) + 20, Main_Screen_Width - 150 -20, 40)];
    tf4.borderStyle = UITextBorderStyleNone;
    tf4.backgroundColor = [UIColor lightGrayColor];
    [_myScrollView addSubview:tf4];
    
    UIButton *idcardBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tf4.frame) + 20, Main_Screen_Width - 30, 40)];
    [idcardBtn addTarget:self action:@selector(IDCardClick) forControlEvents:UIControlEventTouchUpInside];
    [idcardBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    [idcardBtn setTitle:@" 身份证扫描" forState:UIControlStateNormal];
    [idcardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [idcardBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_myScrollView addSubview:idcardBtn];
    
    UIButton *drcardBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(idcardBtn.frame) + 20, Main_Screen_Width - 30, 40)];
    [drcardBtn addTarget:self action:@selector(DRCardClick) forControlEvents:UIControlEventTouchUpInside];
    [drcardBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    [drcardBtn setTitle:@" 驾驶证扫描" forState:UIControlStateNormal];
    [drcardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [drcardBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_myScrollView addSubview:drcardBtn];
    
    UIButton *dhBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(drcardBtn.frame) + 20, Main_Screen_Width - 30, 40)];
    [dhBtn addTarget:self action:@selector(DhClick) forControlEvents:UIControlEventTouchUpInside];
    [dhBtn setImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
    [dhBtn setTitle:@" 寄递单号扫描" forState:UIControlStateNormal];
    [dhBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [dhBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_myScrollView addSubview:dhBtn];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(dhBtn.frame) + 20, Main_Screen_Width - 30, 40)];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_myScrollView addSubview:submitBtn];
    
    [_myScrollView setContentSize:CGSizeMake(Main_Screen_Width, CGRectGetMaxY(submitBtn.frame) + 50)];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dh:) name:@"dh" object:nil];
    
}

//本地数量
-(void)setCount{
    countLabel.text = [NSString stringWithFormat:@"(%d条)",0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//接收到单号结果
- (void)dh:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"danhao"]);
    NSLog(@"－－－－－接收到通知------");
    tf4.text = text.userInfo[@"danhao"];
}

-(void)saveToLocal{
    
}

//提交
-(void)submit{
    
    if ([tf1.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请填写寄件人姓名" ];
        return;
    }
    if ([tf2.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请填写身份证号码"];
        return;
    }
    if ([tf3.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入手机号码"];
        return;
    }
    if ([tf4.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请填写快递单号"];
        return;
    }
    if (image1 == nil) {
        [self showHintInView:self.view hint:@"请上传内件照"];
        return;
    }
    if (image2 == nil) {
        [self showHintInView:self.view hint:@"请上传封箱照"];
        return;
    }
    
    [self.view endEditing:YES];
    [self showHudInView:self.view];
    
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"上传中";
    });
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:tf1.text forKey:@"name"];//姓名
    [parameters setValue:tf2.text forKey:@"idcard"];//身份证
    [parameters setValue:tf3.text forKey:@"mobile"];//手机号
    [parameters setValue:tf4.text forKey:@"no"];//单号
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    [parameters setObject:[user objectForKey:@"id"] forKey:@"uid"];
    [parameters setObject:[user objectForKey:@"token"] forKey:@"tk"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,kAdd];
    
    
    AFHTTPRequestOperationManager* _manager = [AFHTTPRequestOperationManager manager];
    
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    NSMutableURLRequest* request = [_manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data1 = UIImageJPEGRepresentation(image1,1.0f);
        [formData appendPartWithFileData:data1 name:@"file" fileName:@"1.png" mimeType:@"image/png"];
        NSData *data2 = UIImageJPEGRepresentation(image2,1.0f);
        [formData appendPartWithFileData:data2 name:@"file" fileName:@"2.png" mimeType:@"image/png"];
        
    } error:nil];
    
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self hideHud];
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSNumber *code = [dic objectForKey:@"code"];
        if ([code intValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"修改成功";
                
            });
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        DLog(@"%f",(float)totalBytesWritten/totalBytesExpectedToWrite);
        float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;

        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    }];  
    
    [operation start];
}

-(void)showPic:(UIButton *)btn{
    DLog(@"%ld",btn.tag);
    
    btnTag = btn.tag;
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"用户相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
            imagePicker2.delegate = self;
            imagePicker2.allowsEditing = NO;
            imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker2.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
            [[imagePicker2 navigationBar] setTintColor:RGB(67,216,230)];
            [[imagePicker2 navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
            [self presentViewController:imagePicker2 animated:YES completion:nil];
        }];
        [alert addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //检查相机模式是否可用
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"sorry, no camera or camera is unavailable.");
                return;
            }
            UIImagePickerController  *imagePicker1 = [[UIImagePickerController alloc] init];
            imagePicker1.delegate = self;
            imagePicker1.allowsEditing = NO;
            imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker1.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
            [self presentViewController:imagePicker1 animated:YES completion:nil];
        }];
        [alert addAction:action2];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
}

-(void)setting{
    UserSettingViewController *vc = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)DhClick{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.whRatio = 2.5;
    style.xScanRetangleOffset = 20;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineStill;
    style.colorAngle = [UIColor colorWithRed:38./255 green:203./255. blue:216./255. alpha:1.0];
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    //    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgLine;
    
    LBXScanViewController *vc = [LBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    vc.title = @"扫描条形码";
   
    
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
//    UIImage *backImage = [UIImage imageNamed:@"navi_back2"];
//    [backItem setBackButtonBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
//    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
}

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

- (void)DRCardClick{
    DRCardViewController * controller = [[DRCardViewController alloc] initWithNibName:nil bundle:nil];
    controller.DRCamDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)didEndRecDRWithResult:(DrCardInfo* ) drInfo from:(id)sender{
//    __weak UIViewController * vc = (UIViewController*)sender;
    
    if (![DrCardInfo getNoShowDRResultView]) {
        if(drInfo != nil)
        {
            tf1.text = drInfo.cardId;
            tf2.text = drInfo.name;
//            DRCardResultViewController * DRRstVc = [[DRCardResultViewController alloc] init];
//            DRRstVc.DRInfo = drInfo;
//            [vc.navigationController pushViewController:DRRstVc animated:NO];
//            NSLog(@"push drCardResultViewController");
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)dealloc {
    [DictManager FinishDict];
}

//保存图片
-(void)saveImageDocuments:(UIImage *)image path:(NSString *)path{
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:path];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
}
// 读取并存贮到相册
-(UIImage *)getDocumentImage:(NSString *)path{
    // 读取沙盒路径图片
    NSString *aPath3=[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),path];
    // 拿到沙盒路径图片
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    // 图片保存相册
    UIImageWriteToSavedPhotosAlbum(imgFromUrl3, self, nil, nil);
    return imgFromUrl3;
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData* data = UIImageJPEGRepresentation(image,0.1f);
        DLog(@"%lu",(unsigned long)data.length);
        if (btnTag == 1) {
            image1 = [UIImage imageWithData:data];
            [imgBtn1 setImage:image1 forState:UIControlStateNormal];
        }else if (btnTag == 2){
            image2 = [UIImage imageWithData:data];
            [imgBtn2 setImage:image2 forState:UIControlStateNormal];
        }
        
//        NSData *data2 = UIImageJPEGRepresentation(image,0.5f);
//        DLog(@"%lu",(unsigned long)data2.length);
//        
//        NSData *data3 = UIImageJPEGRepresentation(image,1.0f);
//        DLog(@"%lu",(unsigned long)data3.length);
//        
//        UIImage *timg1 = [UIImage imageWithData:data];
//        UIImage *timg2 = [UIImage imageWithData:data2];
//        UIImage *timg3 = [UIImage imageWithData:data3];
//        [self saveImageDocuments:timg1 path:@"/Documents/test1.png"];
//        [self saveImageDocuments:timg2 path:@"/Documents/test2.png"];
//        [self saveImageDocuments:timg3 path:@"/Documents/test3.png"];
//        
//        [self getDocumentImage:@"/Documents/test1.png"];
//        [self getDocumentImage:@"/Documents/test2.png"];
//        [self getDocumentImage:@"/Documents/test3.png"];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        viewController.jz_navigationBarTintColor = RGB(50, 54, 66);
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        
        DLog(@"%@",viewController);
    }else{
        DLog(@"%@",viewController);
    }
    //    if([viewController isKindOfClass:[SettingViewController class]]){
    //        NSLog(@"返回");
    //        return;
    //    }
}

@end
