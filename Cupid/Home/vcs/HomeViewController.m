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
#import "YQNetworking.h"
#import "MJExtension.h"
#import "HomeCategoryAddView.h"
#import "HomeRequest.h"


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
//    self.title = @"首页";
    
    self.isfullScreen = NO;
    self.maryData = [NSMutableArray array];
    self.maryTitle = [NSMutableArray array];
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.categoryAdd];
    [self.view addSubview:self.fengeLineView];
    
    
//    [self.view addSubview:self.topBarView];
   
    
    [self initNavView];
    
    [self getDatas];
    
}



-(void)initNavView
{
    
//    UISearchBar *search = [UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 280, 44)
    
    [self createNavBarViewWithTitle:self.topBarView];
    [self setNavigationViewBackgroundColor:RGBAllColor(0xFF1111)];
//    [self createNavBarViewWithTitle:@"首页"];
    
}


-(void)getDatas
{
    [self requestList];
}

-(void)requestList
{

    WEAKSELF;
    [YQNetworking getWithUrl:[HomeRequest getHomeCategoryTitleUrl] refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
   
        
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
    [self refreshDisplay];
    
    [self.view bringSubviewToFront:self.categoryAdd];
    [self.view bringSubviewToFront:self.fengeLineView];

    
}


// 顶部View
-(HomeTopBarView *)topBarView
{
    if(!_topBarView){
        _topBarView = [HomeTopBarView new];
        
    }
    return _topBarView;
}

-(void)clickAddCategory
{
//    [self.cateGoryManagerView show];
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
