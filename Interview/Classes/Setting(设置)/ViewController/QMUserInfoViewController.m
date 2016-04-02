//
//  QMUserInfoViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/1.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMUserInfoViewController.h"
#import "NetWorking.h"

@interface QMUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *serviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation QMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"userinfo";
    
    self.serviceTextField.text = @"114.112.100.68:8020";

}

- (IBAction)rememberInfo:(UIButton *)sender {
    static BOOL isSelect = YES;
    if (isSelect) {
        sender.backgroundColor = [UIColor greenColor];
         isSelect = NO;
    } else {
        sender.backgroundColor = [UIColor redColor];
        isSelect = YES;
    }
}

- (IBAction)loginBtn:(UIButton*)sender {

    if ([sender.titleLabel.text isEqualToString:@"登陆"]) {
        [self signIn];
        [sender setTitle:@"注销" forState:(UIControlStateNormal)];
    } else if ([sender.titleLabel.text isEqualToString:@"注销"]) {
        [sender setTitle:@"登陆" forState:(UIControlStateNormal)];
        [self logOut];
    }
}

- (void)signIn
{   //@"http://114.112.100.68:8020/Account/Login"
    NSString *path = [NSString stringWithFormat:@"http://%@/Account/Login",_serviceTextField.text];
    
    [[NetWorking shareNetWork]postURL:[NSURL URLWithString:path] loginName:_accountTextField.text loginPassWord:_passwordTextField.text];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenTaking:) name:@"token" object:nil];
}

- (void)logOut
{
    _serviceTextField.text = nil;
    _passwordTextField.text = nil;
    _accountTextField.text = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *signIn = @"losed";
    [user setObject:signIn forKey:@"signIn"];
    [user setObject:_passwordTextField.text forKey:@"password"];
}

- (void)tokenTaking:(NSNotification *)notification
{
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
