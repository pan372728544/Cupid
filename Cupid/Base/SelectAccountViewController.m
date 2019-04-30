//
//  SelectAccountViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "SelectAccountViewController.h"

@interface SelectAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *maryData;

@property(nonatomic,strong)NSMutableArray *maryIMg;
@end

@implementation SelectAccountViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCloseView];
    
    self.view.backgroundColor = RGBAColor(250, 250, 250, 1);
    
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W, 40)];
    tip.text = @"选中要登录的账号";
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:tip];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"111"];
    [self.view addSubview:self.tableView];
    
    
    self.maryData = [NSMutableArray arrayWithObjects:@"齐天大圣-001",@"BAYMAX-002",@"钢铁侠-003", nil];
    
        self.maryIMg = [NSMutableArray arrayWithObjects:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556091375677&di=b77ddcda0fdcb6e4062b63c2e349cd09&imgtype=0&src=http%3A%2F%2Fimg.storage.17wanba.org.cn%2Fgame%2F2016%2F05%2F10%2Fd729d853b0519256f9c6189e6f9eb457.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556091346923&di=94a030de1baced5369065862835fad23&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F010b0d5541ef6c000001714a5ae2e9.jpg%402o.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556091569946&di=e9d9569824014cb2733c8ceb10c19ad4&imgtype=0&src=http%3A%2F%2Fimg.7xz.com%2Fimg%2Fpicimg%2F201607%2F20160728163406_389ae972b1283f76160.jpg", nil];
   
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.maryData.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"111";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }

    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_W-20, 180)];
    
//    [imgV sd_setImageWithURL:[NSURL URLWithString:self.maryIMg[indexPath.row]]];
    
    imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpeg",indexPath.row+1]];
    [cell.contentView addSubview:imgV];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    lab.text = self.maryData[indexPath.row];
    lab.font = [UIFont systemFontOfSize:30];
    lab.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:lab];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self btnClose:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.maryData[indexPath.row] forKey:NICKNAME];
    [defaults synchronize];
    if (self.completedBlock) {
        self.completedBlock();
    }
   
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
