//
//  IDCardResultController.m
//  EXOCR
//
//  Created by z on 15/7/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "DRCardResultViewController.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define UIColorFromRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

@implementation DRCardResultViewController
@synthesize DRInfo;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGBA(0xf0eff5,1)];
    self.navigationItem.title = @"驾驶证信息";
    
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
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [self loadUI];
}

-(void)loadUI {
    UIScrollView * scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scr setBackgroundColor:[UIColor grayColor]];
    scr.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
    [self.view addSubview: scr];
    float lastY = 5;

    if (DRInfo.fullImg != nil) {    //无识别结果
        //未识别图片
        UILabel *fullBackground = [[UILabel alloc]initWithFrame:CGRectMake(20-0.5, lastY-0.5, SCREEN_WIDTH-20-20+0.5*2, (SCREEN_WIDTH-20-20)*0.632+0.5*2)];
        fullBackground.backgroundColor = [UIColor whiteColor];
        fullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        fullBackground.layer.borderWidth = 0.5;
        [scr addSubview:fullBackground];
        
        fullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, lastY, SCREEN_WIDTH-20-20, (SCREEN_WIDTH-20-20) * 0.632)];
        fullImageView.image = DRInfo.fullImg;
        [scr addSubview:fullImageView];
        lastY = lastY + (SCREEN_WIDTH-20-20) * 0.632 + 20;
    }
    //姓名
    if (![DrCardInfo getNoShowDRname]) {
        nameLable = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        nameLable.text = @"姓名";
        
        [scr addSubview: nameLable];
        lastY = lastY + nameLable.bounds.size.height + 3;
        
        nameValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        nameValue.text = DRInfo.name;
        [scr addSubview:nameValue];
        lastY = lastY + nameValue.bounds.size.height + 3;
    }
    //性别
    if (![DrCardInfo getNoShowDRsex]) {
        sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        sexLabel.text = @"性别";
        [scr addSubview: sexLabel];
        lastY = lastY + sexLabel.bounds.size.height + 3;
        
        sexValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        sexValue.text = DRInfo.sex;
        [scr addSubview:sexValue];
        lastY = lastY + sexValue.bounds.size.height + 3;
    }
    //国籍
    if (![DrCardInfo getNoShowDRnation]) {
        nationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        nationLabel.text = @"国籍";
        [scr addSubview: nationLabel];
        lastY = lastY + nationLabel.bounds.size.height + 3;
        
        nationValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        nationValue.text = DRInfo.nation;
        [scr addSubview:nationValue];
        lastY = lastY + nationValue.bounds.size.height + 3;
    }
    //证号
    if (![DrCardInfo getNoShowDRcardId]) {
        cardIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        cardIdLabel.text = @"驾驶证号";
        [scr addSubview: cardIdLabel];
        lastY = lastY + cardIdLabel.bounds.size.height + 3;
               
        cardIdValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        cardIdValue.text = DRInfo.cardId;
        [scr addSubview: cardIdValue];
        lastY = lastY + cardIdValue.bounds.size.height + 3;
    }
    //住址
    if (![DrCardInfo getNoShowDRaddress]) {
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        addressLabel.text = @"住址";
        [scr addSubview: addressLabel];
        lastY = lastY + addressLabel.bounds.size.height + 3;
        
        addressValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        addressValue.text = DRInfo.address;
        [scr addSubview:addressValue];
        lastY = lastY + addressValue.bounds.size.height + 3;
    }
    //出生日期
    if (![DrCardInfo getNoShowDRbirth]) {
        birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        birthLabel.text = @"出生日期";
        [scr addSubview: birthLabel];
        lastY = lastY + birthLabel.bounds.size.height + 3;
    
        birthValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        birthValue.text = DRInfo.birth;
        [scr addSubview:birthValue];
        lastY = lastY + birthValue.bounds.size.height + 3;
    }
    //初次领证日期
    if (![DrCardInfo getNoShowDRissueDate]) {
        issueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        issueDateLabel.text = @"初次领证日期";
        [scr addSubview: issueDateLabel];
        lastY = lastY + issueDateLabel.bounds.size.height + 3;
    
        issueDateValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        issueDateValue.text = DRInfo.issueDate;
        [scr addSubview:issueDateValue];
        lastY = lastY + issueDateValue.bounds.size.height + 3;
    }
    //准驾车型
    if (![DrCardInfo getNoShowDRdriveType]) {
        driveTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        driveTypeLabel.text = @"准驾车型";
        [scr addSubview: driveTypeLabel];
        lastY = lastY + driveTypeLabel.bounds.size.height + 3;
        
        driveTypeValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        driveTypeValue.text = DRInfo.driveType;
        [scr addSubview:driveTypeValue];
        lastY = lastY + driveTypeValue.bounds.size.height + 3;
    }
    //有效日期
    if (![DrCardInfo getNoShowDRvalidDate]) {
        validDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        validDateLabel.text = @"有效日期";
        [scr addSubview: validDateLabel];
        lastY = lastY + validDateLabel.bounds.size.height + 3;
    
        validDateValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        validDateValue.text = DRInfo.validDate;
        [scr addSubview:validDateValue];
        lastY = lastY + validDateValue.bounds.size.height + 3;
    }
    
    for (UIView *subView in self.view.subviews) {
        for (id controll in subView.subviews)
        {
            if ([controll isKindOfClass:[UITextField class]])
            {
                [controll setBackgroundColor:[UIColor whiteColor]];
                [controll setDelegate:self];
            }
        }
    }
}

@end
