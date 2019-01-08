//
//  FirstViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "FirstViewController.h"
#import "ListViewController.h"
#import "ZJBaseViewController+NavBar.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *maryTitle;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    self.isOpenTransiton = NO;
    
    _maryTitle = [NSMutableArray arrayWithObjects:@"ABCD--", @"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",@"ABCD--",nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self initNavView];
    
}
-(void)initNavView
{
    [self createNavBarViewWithTitle:@"首页"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _maryTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"abc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [_maryTitle objectAtIndex:indexPath.row];

    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListViewController *vc = [[ListViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
