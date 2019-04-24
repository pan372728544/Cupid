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
#import "SelectAccountViewController.h"


@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) ZJSocket *socket;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    zjsco
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [defaults objectForKey:NICKNAME];

    [self initNavView];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    
    [self.view addSubview:self.tableView];
    
    self.typeAnimation = PopAnimationTypeOther;
    
    if (name && name.length >0) {
       
        
    } else {
        
        
        SelectAccountViewController *vc =   [SelectAccountViewController new];
        vc.completedBlock = ^{
          
            [self.tableView reloadData];
        };
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    
    
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)connectSer{
//    if socket.connectServer().isSuccess {
//        print("连接成功")
//        socket.delegate = self
//
//        socket.startReadMsg()
//    }
//    self.socket
//    self.socket con
//    if () {
//        <#statements#>
//    }
}

-(void)initNavView
{
    [self createNavBarViewWithTitle:@"IM"];
    [self createNavRightBtnWithItem:@"退出登录" target:self action:@selector(logOut)];
    self.superNavBarView.backgroundColor = COLOR_COMMONRED;
    
}


-(void)logOut
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:NICKNAME];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [defaults objectForKey:NICKNAME];
    
    if (nickName && nickName.length > 0) {
        IMChatViewController *chat = [[IMChatViewController alloc]init];
        [self.navigationController pushViewController:chat animated:YES];
    } else {
        SelectAccountViewController *vc =   [SelectAccountViewController new];
        vc.completedBlock = ^{
            
            [self.tableView reloadData];
        };
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }

}

@end
