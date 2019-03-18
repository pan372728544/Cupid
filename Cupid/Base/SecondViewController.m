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

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
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
    
//    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_W, SCREEN_H)];
//    imgV.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:imgV];
//
//    NSString *str = [@"http%3A%2F%2Fp3-tt.bytecdn.cn%2Flarge%2Fpgc-image%2Fe119b15f49f44485871e433519f07d42" stringByRemovingPercentEncoding];
//
//    [imgV sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        UIImage *imag = image;
//        NSLog(@"%@",imag);
//
//    }];
    
}


-(void)initNavView
{
    [self createNavBarViewWithTitle:@"西瓜视频"];
    
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
    
    [self presentViewController:[VideoDetailViewController new] animated:YES completion:nil];
    
//    [self.navigationController pushViewController:[VideoDetailViewController new] animated:YES];
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
