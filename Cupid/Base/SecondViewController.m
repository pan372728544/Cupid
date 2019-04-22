//
//  SecondViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "SecondViewController.h"
#import "ZJBaseViewController+NavBar.h"
#import "ThirdViewController.h"
#import "VideoDetailViewController.h"
#import "Cupid-Swift.h"
#import "LoginViewController.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) ServerManager *serM;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initNavView];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    
    [self.view addSubview:self.tableView];
    
    self.typeAnimation = PopAnimationTypeOther;
    
    
}



-(void)initNavView
{
    [self createNavBarViewWithTitle:@"IM"];
    self.superNavBarView.backgroundColor = COLOR_COMMONRED;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"进入群聊页面"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    LoginViewController *vc =   [LoginViewController new];
    
    vc.block = ^(NSString * _Nonnull nickName, NSString * _Nonnull type) {
        IMChatViewController *chat = [[IMChatViewController alloc]init];
        [chat setNickNameWithStr:nickName type:type];
        [self.navigationController pushViewController:chat animated:YES];
    };
    

    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

@end
