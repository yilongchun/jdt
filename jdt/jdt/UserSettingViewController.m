//
//  UserSettingViewController.m
//  jdt
//
//  Created by Stephen Chin on 17/2/23.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UIImage+Color.h"

@interface UserSettingViewController (){
    UILabel *contentLabel;
    BOOL showUpdatePwd;
    
    UITextField *tf1;
    UITextField *tf2;
    UITextField *tf3;
    UIButton *submitBtn;
    UIButton *cancelBtn;
}

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"个人设置";
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 20, Main_Screen_Width, 20)];
    label1.text = @"收件统计";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = BOLDSYSTEMFONT(19);
    [self.view addSubview:label1];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame) + 20, Main_Screen_Width, 1)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 20, Main_Screen_Width, 30)];
//    contentLabel.text = @"今日收件数量: 0 件";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contentLabel];
    
    
    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLabel.frame) + 20, Main_Screen_Width - 30, 40)];
    [updateBtn addTarget:self action:@selector(showTf) forControlEvents:UIControlEventTouchUpInside];
    [updateBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [updateBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.view addSubview:updateBtn];
    
    showUpdatePwd = YES;
    
    tf1 = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(updateBtn.frame) + 20, Main_Screen_Width - 30, 40)];
    tf1.borderStyle = UITextBorderStyleNone;
    tf1.backgroundColor = [UIColor lightGrayColor];
    tf1.placeholder = @"请输入原密码";
    tf1.secureTextEntry = YES;
    [self.view addSubview:tf1];
    
    tf2 = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tf1.frame) + 20, Main_Screen_Width - 30, 40)];
    tf2.borderStyle = UITextBorderStyleNone;
    tf2.backgroundColor = [UIColor lightGrayColor];
    tf2.placeholder = @"请输入新密码";
    tf2.secureTextEntry = YES;
    [self.view addSubview:tf2];
    
    tf3 = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tf2.frame) + 20, Main_Screen_Width - 30, 40)];
    tf3.borderStyle = UITextBorderStyleNone;
    tf3.backgroundColor = [UIColor lightGrayColor];
    tf3.placeholder = @"请再次输入新密码";
    tf3.secureTextEntry = YES;
    [self.view addSubview:tf3];
    
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tf3.frame) + 20, Main_Screen_Width - 30, 40)];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(submitBtn.frame) + 20, Main_Screen_Width - 30, 40)];
    [cancelBtn addTarget:self action:@selector(showTf) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消修改" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor:RGB(29, 206, 119) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    [self showTf];
    
    
    [self loadData];
}

-(void)loadData{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user objectForKey:@"id"] forKey:@"uid"];
    [parameters setObject:[user objectForKey:@"token"] forKey:@"tk"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,kTodayCount];
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        DLog(@"%@",responseObject);
        
        NSNumber *code = [dic objectForKey:@"code"];
        if ([code intValue] == 0) {
            
            NSNumber *num = [dic objectForKey:@"message"];
            
            NSString *numStr = [NSString stringWithFormat:@"%d",[num intValue]];
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"今日收件数量: %d 件",[num intValue]]];
            [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],} range:NSMakeRange(0, 8)];
            [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],} range:NSMakeRange(8, numStr.length)];
            [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],} range:NSMakeRange(8 + numStr.length + 1 , 1)];
            contentLabel.attributedText = attributeString;
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
    }];
}

-(void)submit{
    
    
    if ([tf1.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入原密码"];
        [tf1 becomeFirstResponder];
        return;
    }
    if ([tf2.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入新密码"];
        [tf2 becomeFirstResponder];
        return;
    }
    if ([tf3.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请再次输入密码"];
        [tf3 becomeFirstResponder];
        return;
    }
    if (![tf2.text isEqualToString:tf3.text]) {
        [self showHintInView:self.view hint:@"两次密码不一致，请重新输入"];
        return;
    }
    [self.view endEditing:YES];
    
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:tf1.text forKey:@"oldPassword"];
    [parameters setObject:tf2.text forKey:@"newPassword"];
    [parameters setObject:[user objectForKey:@"id"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,kUpdatePwd];
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        DLog(@"%@",responseObject);
        
        NSNumber *code = [dic objectForKey:@"code"];
        if ([code intValue] == 0) {
            
            [self showHintInView:self.view hint:[dic objectForKey:@"message"]];
            tf1.text = @"";
            tf2.text = @"";
            tf3.text = @"";
            [self showTf];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
    }];
    
}

-(void)showTf{
    showUpdatePwd = !showUpdatePwd;
    
    tf1.hidden = !showUpdatePwd;
    tf2.hidden = !showUpdatePwd;
    tf3.hidden = !showUpdatePwd;
    submitBtn.hidden = !showUpdatePwd;
    cancelBtn.hidden = !showUpdatePwd;
    
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
