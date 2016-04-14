//
//  QMUserInfoViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/1.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMUserInfoViewController.h"
#import "NetWorking.h"
#import "AFNetworking.h"
#import "QMRememberButton.h"

@interface QMUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *serviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet QMRememberButton *rememberKeyBtn;
@end

@implementation QMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户信息";
    
    self.serviceTextField.text = @"114.112.100.68:8020";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kRememberKey] isEqualToString:@"YES"]) {
        self.serviceTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pathToService"];
        self.accountTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        self.rememberKeyBtn.selected = YES;
    } else {
        self.serviceTextField.text = nil;
        self.accountTextField.text = nil;
        self.passwordTextField.text = nil;
        
        self.rememberKeyBtn.selected = NO;
    }
}

- (IBAction)rememberInfo:(UIButton *)sender {
    static BOOL isSelect = YES;
    if (isSelect) {// 记住密码
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"RememberKey"];
        
        self.rememberKeyBtn.selected = YES;
         isSelect = NO;
    } else {// 不记住密码
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"RememberKey"];
        
        self.rememberKeyBtn.selected = NO;
        isSelect = YES;
    }
}

- (IBAction)loginBtn:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"登陆"]) {
//        [self signIn];
        [self singnInWithAFN];
        [sender setTitle:@"注销" forState:(UIControlStateNormal)];
    } else if ([sender.titleLabel.text isEqualToString:@"注销"]) {
        [sender setTitle:@"登陆" forState:(UIControlStateNormal)];
        [self logOutWithAFN];
    }
}


- (void)singnInWithAFN {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/Account/Login",_serviceTextField.text];
    // 请求的参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: _accountTextField.text forKey:@"userName"];
    [parameters setObject: _passwordTextField.text forKey:@"password"];
    [parameters setObject: [self mAppUUID] forKey:@"deviceID"];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSDictionary * returnDataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:&error];
        if ([returnDataDic[@"Error"] isKindOfClass:[NSNull class]]) {
            NSDictionary *dataDic = returnDataDic[@"Data"];
            //        NSArray *PlanColumnTypesArr = dataDic[@"PlanColumnTypes"]; // 发稿栏目
            //        NSArray *PlanReportTypesArr = dataDic[@"PlanReportTypes"]; // 报道形式
            [[NSUserDefaults standardUserDefaults] setObject:_serviceTextField.text forKey:@"pathToService"];
            [[NSUserDefaults standardUserDefaults] setObject:_accountTextField.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"Token"] forKey:@"token"];

            [MBProgressHUD showSuccess:@"登陆成功"];
        } else {
            NSDictionary *errorDic = returnDataDic[@"Error"];

            [MBProgressHUD showError:errorDic[@"Message"]];
        }
        
        if (error) {
            QMLog(@"登陆数据解析错误:%@",[error description]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            QMLog(@"%@",[error description]);
        }
    }];
}

- (void)logOutWithAFN {
    _serviceTextField.text = nil;
    _passwordTextField.text = nil;
    _accountTextField.text = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:_serviceTextField.text forKey:@"pathToService"];
    [[NSUserDefaults standardUserDefaults] setObject:_accountTextField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
    
}

#pragma mark - 原工程代码
- (NSString *)mAppUUID {
    NSUserDefaults *UserDef = [NSUserDefaults standardUserDefaults];
    NSString *deviceIdStr = [UserDef valueForKey:@"deviceId"];
    if (!deviceIdStr) {
        CFUUIDRef deviceId = CFUUIDCreate (NULL);
        CFStringRef deviceIdStrRef = CFUUIDCreateString(NULL,deviceId);
        CFRelease(deviceId);
        deviceIdStr = [NSString stringWithString:(__bridge NSString *)deviceIdStrRef];
        [UserDef setValue:deviceIdStr forKey:@"deviceId"];
        [UserDef synchronize];
    }
    NSMutableString *str = [NSMutableString stringWithString:deviceIdStr];
    [str replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    return str;
}

- (void)logOut {
    _serviceTextField.text = nil;
    _passwordTextField.text = nil;
    _accountTextField.text = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *signIn = @"losed";
    [user setObject:signIn forKey:@"signIn"];
    [user setObject:_passwordTextField.text forKey:@"password"];
}

- (void)signIn {   //@"http://114.112.100.68:8020/Account/Login"
    NSString *path = [NSString stringWithFormat:@"http://%@/Account/Login",_serviceTextField.text];
    
    [[NetWorking shareNetWork]postURL:[NSURL URLWithString:path] loginName:_accountTextField.text loginPassWord:_passwordTextField.text];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenTaking:) name:@"token" object:nil];
}

- (void)tokenTaking:(NSNotification *)notification {
    UIAlertView *alertView;
    if (notification.object){
        alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                               message:@"登陆成功"
                                              delegate:nil
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:nil
                     , nil];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *signIn = @"succeed";
    [user setObject:signIn forKey:@"signIn"];
    [user setObject:_serviceTextField.text forKey:@"address"];
    [user setObject:_accountTextField.text forKey:@"userName"];
    [user setObject:_passwordTextField.text forKey:@"password"];
    
    [alertView show];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
