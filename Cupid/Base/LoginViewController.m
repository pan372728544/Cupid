//
//  LoginViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/3/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCloseView];
    
    self.view.backgroundColor = RGBAColor(250, 250, 250, 1);
    
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W, 40)];
    tip.text = @"登录你的头条，精彩永不丢失";
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:tip];
    
    
    UIView *viewA = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(tip.frame)+50, SCREEN_W-80, 40)];
    viewA.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    viewA.layer.borderWidth= 1.0f;
    viewA.layer.masksToBounds = YES;
    viewA.layer.cornerRadius = 20;
    
    [self.view addSubview:viewA];
    
    
    UITextField *textFPhone = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
    textFPhone.placeholder = @"手机号";
    textFPhone.font = [UIFont systemFontOfSize:15];
    [viewA addSubview:textFPhone];
    
    // 竖线
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W-80-100, 10, 1, 20)];
    viewLine.backgroundColor = [UIColor blackColor];
    
    [viewA addSubview:viewLine];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewLine.frame), 0, 100, 40)];
    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
   [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [viewA addSubview:btn];
    
    
    
    
    
    
    UIView *viewA2 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(viewA.frame)+20, SCREEN_W-80, 40)];
    viewA2.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    viewA2.layer.borderWidth= 1.0f;
    viewA2.layer.masksToBounds = YES;
    viewA2.layer.cornerRadius = 20;
    
    [self.view addSubview:viewA2];
    
    
    UITextField *textFC = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_W-80, 40)];
    textFC.placeholder = @"请输入验证码";
        textFC.font = [UIFont systemFontOfSize:15];
    [viewA2 addSubview:textFC];
    
    
    UIButton *btnA = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(viewA2.frame)+20, SCREEN_W-80, 40)];
    [btnA setTitle:@"进入头条" forState:UIControlStateNormal];
    btnA.titleLabel.font = [UIFont systemFontOfSize:15];
    btnA.backgroundColor =COLOR_COMMONRED;
    [btnA setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    btnA.layer.masksToBounds = YES;
    btnA.layer.cornerRadius = 20;
    [self.view addSubview:btnA];
    
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_H-300, SCREEN_W, 300)];
    imageV.image = [UIImage imageNamed:@"abc.png"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    
    
}

-(void)initCloseView
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-24-10, 10, 24, 24)];
    
    
    [btn setBackgroundImage:[UIImage imageNamed:@"close_channel_24x24_@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)btnClose:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
