//
//  ListViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ListViewController.h"
#import "ZJBaseViewController+NavBar.h"


@interface ListViewController()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *maryTitle;

@end


@implementation ListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainViews];
    [self initNavView];
    
    
    
    
    
    _maryTitle = [NSMutableArray array];
    for (int i=0; i<20; i++) {
      
        [_maryTitle addObject:[NSString stringWithFormat:@"---%d",i]];
    }
    


    
    
}

-(void)initNavView
{
    [self createNavBarViewWithTitle:@"List"];
    [self createNavLeftBtnWithItem:@"" target:self action:@selector(backClick:)];
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
}

-(void)initMainViews
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100) style:UITableViewStylePlain];
    
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


-(void)backClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
