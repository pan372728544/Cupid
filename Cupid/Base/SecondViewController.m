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
    
    // 开启服务器
//    self.serM =  [[ServerManager alloc]init];
//    [self.serM startRunning];
    
}



-(void)initNavView
{
    [self createNavBarViewWithTitle:@"IM"];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"Test--%ld",indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.navigationController pushViewController:[IMChatViewController new] animated:YES];
}

@end
