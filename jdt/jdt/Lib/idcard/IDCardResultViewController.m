//
//  IDCardResultController.m
//  EXOCR
//
//  Created by z on 15/7/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "IDCardResultViewController.h"
#import<QuartzCore/QuartzCore.h>

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define IS_IPHONE       ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define UIColorFromRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.2]

#define FRONT_TAG   0x1033
#define BACK_TAG    0x1034

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HIGHT  44

#define LEFT_MARGIN     20
#define RIGHT_MARGIN    20

#define DISTANCR_HOR    10

#define LABEL_WIDTH     90

@implementation IDCardResultViewController
@synthesize IDInfo;
@synthesize delegate;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGBA(0xf0eff5,1)];
    self.navigationItem.title = @"身份证信息";
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //关闭scrollView自动调整
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createUI];
}

- (void) hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)createUI
{
    CGFloat borderWidth = IS_IPHONE ? 0.6 : 1.0;
    CGFloat distanceY = borderWidth * 2;
    CGFloat labelHeight = IS_IPHONE ? 40 : 60;
    
    UIScrollView * scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAV_BAR_HIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scr setBackgroundColor:UIColorFromRGBA(0xf0eff5,1)];

    /*for dismiss keyboard*/
    UIView *backView = [[UIView alloc] initWithFrame:scr.frame];
    [backView setBackgroundColor:[UIColor clearColor]];
    [scr addSubview:backView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    [backView addGestureRecognizer:tapGr];
    
    if (GET_FULLIMAGE) {
        scr.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
    } else {
        scr.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.5);
    }
    [self.view addSubview: scr];
    float lastY = 10;
    
    CGFloat valueOffset = LEFT_MARGIN + LABEL_WIDTH + DISTANCR_HOR;
    CGFloat valueWidth = SCREEN_WIDTH - valueOffset - RIGHT_MARGIN;
    
    //获取“身份证正面”按钮
    frontBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [frontBtn setBackgroundColor:[UIColor clearColor]];
    [frontBtn setBackgroundImage:[UIImage imageNamed:@"exocr-click_camera_btn"] forState:UIControlStateNormal];
    CGRect frontFrame = CGRectMake(SCREEN_WIDTH - 50, lastY + 40, 40, 30);
    frontBtn.frame = frontFrame;
    frontBtn.tag = FRONT_TAG;
    [frontBtn addTarget:self action:@selector(launchCameraView:) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:frontBtn];
    
    //人脸
    if (![IdInfo getNoShowIDFaceImg]) {
        UILabel *faceBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, 80+borderWidth*2, 80+borderWidth*2)];
        faceBackground.backgroundColor = [UIColor whiteColor];
        faceBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        faceBackground.layer.borderWidth = borderWidth;
        [scr addSubview:faceBackground];
        
        faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, 80, 80)];
        [faceImageView setBackgroundColor:[UIColor whiteColor]];
        [scr addSubview:faceImageView];
        lastY = faceImageView.bounds.origin.y + faceImageView.bounds.size.height + 30;
    }
    //姓名
    if (![IdInfo getNoShowIDName]) {
        UILabel *nameBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        nameBackground.backgroundColor = [UIColor whiteColor];
        nameBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nameBackground.layer.borderWidth = borderWidth;
        [scr addSubview:nameBackground];
        
        nameLable = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        nameLable.text = @"  姓名";
        [scr addSubview: nameLable];
        
        nameValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        nameValueTextField.delegate = self;
        [scr addSubview:nameValueTextField];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //性别
    if (![IdInfo getNoShowIDSex]) {
        UILabel *sexBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        sexBackground.backgroundColor = [UIColor whiteColor];
        sexBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        sexBackground.layer.borderWidth = borderWidth;
        [scr addSubview:sexBackground];
        
        sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        sexLabel.text = @"  性别";
        [scr addSubview: sexLabel];
        
        sexValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        sexValueTextField.delegate = self;
        [scr addSubview:sexValueTextField];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //民族
    if (![IdInfo getNoShowIDNation]) {
        UILabel *nationBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        nationBackground.backgroundColor = [UIColor whiteColor];
        nationBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nationBackground.layer.borderWidth = borderWidth;
        [scr addSubview:nationBackground];
        
        nationLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        nationLabel.text = @"  民族";
        [scr addSubview: nationLabel];
        
        nationValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:nationValueTextField];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //出生日期
    if (![IdInfo getNoShowIDBirth]) {
        UILabel *birthdayBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        birthdayBackground.backgroundColor = [UIColor whiteColor];
        birthdayBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        birthdayBackground.layer.borderWidth = borderWidth;
        [scr addSubview:birthdayBackground];
        
        birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        birthdayLabel.text = @"  出生";
        [scr addSubview: birthdayLabel];
        
        birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:birthdayTextField];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //住址
    if (![IdInfo getNoShowIDAddress]) {
        UILabel *addressBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight*2+borderWidth*2)];
        addressBackground.backgroundColor = [UIColor whiteColor];
        addressBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        addressBackground.layer.borderWidth = borderWidth;
        [scr addSubview:addressBackground];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        addressLabel.text = @"  住址";
        [scr addSubview: addressLabel];
        
        if (IS_IPHONE) {
            addressValueTextView = [[UITextView alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight*2)];
            addressValueTextView.delegate = self;
            [addressValueTextView setFont:[UIFont systemFontOfSize:17]];
            [scr addSubview:addressValueTextView];
            lastY = lastY + labelHeight*2 + distanceY - borderWidth;
        } else {
            addressValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:addressValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
    }
    //身份证号
    if (![IdInfo getNoShowIDCode]) {
        UILabel *codeBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        codeBackground.backgroundColor = [UIColor whiteColor];
        codeBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        codeBackground.layer.borderWidth = borderWidth;
        [scr addSubview:codeBackground];
        
        codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        codeLabel.text = @"  身份证号";
        [scr addSubview: codeLabel];
        
        codeValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:codeValueTextField];
        lastY = lastY + labelHeight + 20;
    }
    //正面fullImage
    if (![IdInfo getNoShowIDFrontFullImg]) {
        if(GET_FULLIMAGE){
            UILabel *frontFullBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, (SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN)*0.632+borderWidth*2)];
            frontFullBackground.backgroundColor = [UIColor whiteColor];
            frontFullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            frontFullBackground.layer.borderWidth = borderWidth;
            [scr addSubview:frontFullBackground];
            
            frontFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN, (SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632)];
            [scr addSubview:frontFullImageView];
            lastY = lastY + (SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632 + 20;
        }
    }
    //获取“身份证背面”按钮
    backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    //    [backBtn setTitle:@"backBtn" forState:UIControlStateNormal];
    //    [[backBtn titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
    //    [backBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"exocr-click_camera_btn"] forState:UIControlStateNormal];
    CGRect backFrame = CGRectMake(SCREEN_WIDTH - 50, lastY, 40, 30);
    backBtn.frame = backFrame;
    backBtn.tag = BACK_TAG;
    [backBtn addTarget:self action:@selector(launchCameraView:) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:backBtn];
    lastY = lastY + labelHeight + 20;
    
    //签发机关
    if (![IdInfo getNoShowIDOffice]) {
        UILabel *issueBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        issueBackground.backgroundColor = [UIColor whiteColor];
        issueBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        issueBackground.layer.borderWidth = borderWidth;
        [scr addSubview:issueBackground];
        
        issueLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        issueLabel.text = @"  签发机关";
        [scr addSubview: issueLabel];
        
        issueValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:issueValueTextField];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //有效期限
    if (![IdInfo getNoShowIDValid]) {
        UILabel *validBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        validBackground.backgroundColor = [UIColor whiteColor];
        validBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        validBackground.layer.borderWidth = borderWidth;
        [scr addSubview:validBackground];
        
        validLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        validLabel.text = @"  有效期限";
        [scr addSubview: validLabel];
        
        validValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:validValueTextField];
        lastY = lastY + labelHeight + 20;
    }
    //背面fullImage
    if (![IdInfo getNoShowIDBackFullImg]) {
        if(GET_FULLIMAGE){
            UILabel *backFullBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, (SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN)*0.632+borderWidth*2)];
            backFullBackground.backgroundColor = [UIColor whiteColor];
            backFullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            backFullBackground.layer.borderWidth = borderWidth;
            [scr addSubview:backFullBackground];
            
            backFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN, (SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632)];
            [scr addSubview:backFullImageView];
        }
    }
    
    for (UIView *subView in self.view.subviews) {
        for (id controll in subView.subviews)
        {
            if ([controll isKindOfClass:[UITextField class]])
            {
                [controll setBackgroundColor:[UIColor whiteColor]];
                [controll setDelegate:self];
                [controll setAdjustsFontSizeToFitWidth:YES];
                [controll setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            }
        }
    }
}

- (void)launchCameraView:(UIButton *)sender
{
    IDCardViewController * IDCardController = [[IDCardViewController alloc] init];
    IDCardController.IDCamDelegate = self;
    if (sender.tag == FRONT_TAG) {
        IDCardController.bShouldFront = YES;
    } else {
        IDCardController.bShouldFront = NO;
    }
    [self.navigationController pushViewController:IDCardController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - IDCamCotrllerDelegate

-(void)didEndRecIDWithResult:(IdInfo* ) idInfo from:(id)sender
{
    if (idInfo.type != 0) { //识别成功
        IDInfo = idInfo;
        [self.delegate returnIDResult:idInfo from:self];
        [self loadData];
    }
}
-(void)loadData
{
    if (IDInfo.type == 1) {
        //人脸
        if (IDInfo.faceImg != nil) {
            [faceImageView setImage:IDInfo.faceImg];
        }
        
        //姓名
        if (nameValueTextField != nil)
            nameValueTextField.text = IDInfo.name;
        
        //性别
        if (sexValueTextField != nil)
            sexValueTextField.text = IDInfo.gender;
        
        //民族
        if (nationValueTextField != nil)
            nationValueTextField.text = IDInfo.nation;
        
        //出生日期
        if (birthdayTextField != nil) {
            birthdayTextField.text = IDInfo.birth;
        }
        
        //住址
        if (IS_IPHONE) {
            if (addressValueTextView != nil) {
                addressValueTextView.text = IDInfo.address;
                //textview 改变字体的行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10;// 字体的行间距
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                             NSParagraphStyleAttributeName:paragraphStyle
                                             };
                addressValueTextView.attributedText = [[NSAttributedString alloc] initWithString:addressValueTextView.text attributes:attributes];
            }
        } else {
            if (addressValueTextField != nil)
                addressValueTextField.text = IDInfo.address;
        }
        //身份证号
        if (codeValueTextField != nil)
            codeValueTextField.text = IDInfo.code;
        //是否显示整幅身份证图像
        if(GET_FULLIMAGE){
            if (frontFullImageView != nil)
                [frontFullImageView setImage:IDInfo.frontFullImg];
        }
    }else{
        //签发机关
        if (issueValueTextField != nil)
            issueValueTextField.text = IDInfo.issue;
        //有效期限
        if (validValueTextField != nil)
            validValueTextField.text = IDInfo.valid;
        //是否显示整幅身份证图像
        if(GET_FULLIMAGE){
            if (backFullImageView != nil)
                [backFullImageView setImage:IDInfo.backFullImg];
        }
    }
}

#pragma mark - UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
}
@end
