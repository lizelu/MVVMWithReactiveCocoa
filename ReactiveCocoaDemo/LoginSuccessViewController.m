//
//  LoginSuccessViewController.m
//  ReactiveCocoaDemo
//
//  Created by Mr.LuDashi on 15/11/6.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import "LoginSuccessViewController.h"

@interface LoginSuccessViewController ()
@property (strong, nonatomic) IBOutlet UILabel *userInfoLabel;

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userInfoLabel.text = [NSString stringWithFormat:@"用户名：%@,  密码：%@", _userName, _password];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
