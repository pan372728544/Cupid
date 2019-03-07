//
//  HomeViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeViewController.h"
#import "ListViewController.h"
#import "ZJBaseViewController+NavBar.h"
#import "ZJBaseTabBarController.h"
// 首页内容视图控制器
#import "HomeContentViewController.h"
#import "HomeTopBarView.h"
#import "CategoryTitleModel.h"
#import "ZJNetworking.h"
#import "MJExtension.h"
#import "HomeCategoryAddView.h"
#import "HomeRequest.h"
#import "HomeDetailViewController.h"
#import "HomeChannelViewController.h"



@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,CategoryAddViewDelegate>


@property(nonatomic,strong)UITableView *tableView;

// 标题数组
@property(nonatomic,strong)NSMutableArray *maryTitle;

@property(nonatomic,strong)NSMutableArray *maryData;

// 顶部视图
@property(nonatomic,strong)HomeTopBarView *topBarView;
@property(nonatomic,strong)HomeCategoryAddView *categoryAdd;


@property(nonatomic,strong) UIView *fengeLineView;





@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.isfullScreen = NO;
    self.maryData = [NSMutableArray array];
    self.maryTitle = [NSMutableArray array];
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.categoryAdd];
    [self.view addSubview:self.fengeLineView];
    

    [self initNavView];
    
    [self getDatas];
    

    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)initNavView
{
    [self createNavLeftBtnWithItem:[UIImage imageNamed:@"arrow-left-white-24_24x24_"] target:self action:@selector(btnClick:)];
    
    [self createNavRightBtnWithItem:@"搜索" target:self action:@selector(seachClick:)];
    
    [self createNavBarViewWithTitle:self.topBarView];
    
    [self setNavigationViewBackgroundColor:COLOR_COMMONRED];

    
}

-(void)btnClick:(id)sender
{
 

}

-(void)seachClick:(id)sender
{

}

-(void)getDatas
{
    [self requestList];
}

-(void)requestList
{

    WEAKSELF;
    NSDictionary *rootPram=[HomeRequest getCommonParamDic];
    [ZJNetworking getWithUrl:[HomeRequest getHomeCategoryTitleUrl] refreshRequest:NO cache:NO params:rootPram progressBlock:nil successBlock:^(id response) {
   
        
        [weakSelf requestSuccess:(id)response];
        
    } failBlock:^(NSError *error) {
        
    }];
    
    


}


-(void)requestSuccess:(id)response
{
    // 分类数组
    self.maryTitle = [CategoryTitleModel mj_objectArrayWithKeyValuesArray:(NSDictionary *)response[@"data"][@"data"]];
    
    // 设置VCS
    [self setCategoryTitleVC:self.maryTitle];
}

-(void)setCategoryTitleVC:(NSArray*)resultModel
{
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    
    
    for (CategoryTitleModel *model in resultModel) {
        HomeContentViewController *addVC = [[HomeContentViewController alloc] init];
        addVC.category=model.category;
        addVC.title = model.name;
        [self addChildViewController:addVC];
    }
    
    
    
//    [self setUpContentViewFrame:^(UIView *contentView) {
//        
//        CGFloat contentX = 0;
//        CGFloat contentH = SCREEN_H - contentY;
//        contentView.frame = CGRectMake(contentX, contentY, SCREEN_W, contentH);
//        
//    }];
    
    [self setUpTitleGradient:^(TitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor blackColor];
        *selColor = [UIColor colorWithRed:0.84 green:0.23 blue:0.22 alpha:1];;

    }];

    [self setUpTitleScale:^(CGFloat *titleScale) {
        *titleScale=1.1;
    }];
    self.selectIndex = 1;
    [self refreshDisplay];
    
    [self.view bringSubviewToFront:self.categoryAdd];
    [self.view bringSubviewToFront:self.fengeLineView];

    
}


// 顶部View
-(HomeTopBarView *)topBarView
{
    if(!_topBarView){
        _topBarView = [HomeTopBarView new];
        _topBarView.superVC = self;

    }
    return _topBarView;
}

-(void)clickAddCategory
{
//    [self.cateGoryManagerView show];
    
    HomeChannelViewController *vc = [[HomeChannelViewController alloc]init];

    [self presentViewController:vc animated:YES completion:nil];
    
    
    
    
    
    
    
    
}

-(HomeCategoryAddView *)categoryAdd
{
    if(!_categoryAdd){
        _categoryAdd=[HomeCategoryAddView new];
        _categoryAdd.delegate= self;
        _categoryAdd.frame=CGRectMake(SCREEN_W-44, NAVBAR_IPHONEX_H, 44, 44);
    }
    return _categoryAdd;
}


-(UIView *)fengeLineView
{
    if(!_fengeLineView){
        _fengeLineView=[UIView new];
        _fengeLineView.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
       _fengeLineView.frame=CGRectMake(0, NAVBAR_IPHONEX_H+43, SCREEN_W, 0.5);
    }
    return _fengeLineView;
}
@end
