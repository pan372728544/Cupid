//
//  ResultSearchViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ResultSearchViewController.h"
#import "SearchBarView.h"
#import "ResultSearchDetailViewController.h"
#import "ResultTopView.h"


static NSString *identify = @"collecitonview";

static CGFloat kLineSpacing =10;

@interface ResultSearchViewController()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong) SearchBarView *searchBarView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *maryTitle;

@property(nonatomic,strong)NSMutableArray *maryCollection;

@property(nonatomic,strong)NSArray *marySearch;


@property(nonatomic,strong) UIView *serachBackView;


/** 内容滚动视图 */
@property (nonatomic, strong) UICollectionView *collectionView;


@property(nonatomic,copy)NSString *searString;

@end

@implementation ResultSearchViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBarView becomeFirstResponder];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];


    [self initNavView];
    self.typeAnimation =PopAnimationTypeSearch;
    [self.serachBackView addSubview:self.searchBarView];
    
    [self createCollectionView];
    [self setupSubviews];
 
}

-(void)createCollectionView
{
    
     _maryCollection = [NSMutableArray array];
    for (int i=0; i<50; i++)
    {
        
        [_maryCollection addObject:[NSString stringWithFormat:@"推荐搜索数据-%d",i]];
    }
    
    [self.view addSubview:self.collectionView];
    
}


-(void)initNavView
{

    
    [self createNavBarViewWithTitle:self.serachBackView];

    [self createNavLeftBtnWithItem:[UIImage imageNamed:@"arrow-left-white-24_24x24_"] target:self action:@selector(backClick:)];
    
    [self createNavRightBtnWithItem:@"搜索" target:self action:@selector(seachClick:)];

    [self setNavigationViewBackgroundColor:COLOR_COMMONRED];

}



-(void)seachClick:(id)sender
{
    MYLog(@"搜索----");
  [self pushDetailVC];

}
-(void)resignFirstResponderSearchView;
{
 
     [self.searchBarView resignFirstResponder];
}
-(void)backClick:(id)sender
{
    
    MYLog(@"返回按钮----");
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)setupSubviews
{
    
    _maryTitle = [NSMutableArray array];
    
    
    _marySearch = [NSArray array];
    
    for (int i=0; i<50; i++)
    {
        
        [_maryTitle addObject:[NSString stringWithFormat:@"搜索到的数据----%d",i]];
    }
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) style:UITableViewStylePlain];
    
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _marySearch.count>0?_marySearch.count: _maryTitle.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"abc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (_marySearch.count >0)
    {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[_marySearch objectAtIndex:indexPath.row]];
        
        [attString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:[[_marySearch objectAtIndex:indexPath.row] rangeOfString:self.searString]];
        
        cell.textLabel.attributedText = attString;
        
    }
    else
    {
        cell.textLabel.text = [_maryTitle objectAtIndex:indexPath.row];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self resignFirstResponderSearchView];
        [self pushDetailVC];
}

-(SearchBarView *)searchBarView
{
    if (!_searchBarView) {
        
        _searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake(50, (NAVBAR_H-SearchBar_H)/2, SCREEN_W-100, SearchBar_H)];
        
        _searchBarView.delegate = self;
        
    }
    return _searchBarView;
}

-(UIView *)serachBackView
{
    if (!_serachBackView) {
        _serachBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, NAVBAR_H)];
    }
    return _serachBackView;
}

-(void)pushDetailVC
{
    
    [self.navigationController pushViewController:[ResultSearchDetailViewController new] animated:YES];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self resignFirstResponderSearchView];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    MYLog(@"textFieldShouldBeginEditing===== result");
    
   
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    MYLog(@"textFieldShouldEndEditing===== result");
    return YES;
    
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MYLog(@"textFieldShouldEndEditing===== result");

    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0)
{
    MYLog(@"textFieldShouldEndEditing===== result");

    
}// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
    MYLog(@"textFieldShouldEndEditing===== result  %@",string);
    NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    /**通过谓词修饰的方式来查找包含我们搜索关键字的数据*/
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",searchString];
    self.searString = searchString;
    
    self.tableView.hidden = !searchString.length;
    self.marySearch = [self.maryTitle filteredArrayUsingPredicate:resultPredicate];
    
    [self.tableView reloadData];
    
    return YES;
}// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    MYLog(@"textFieldShouldEndEditing===== result");
    return YES;
    
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    MYLog(@"textFieldShouldEndEditing===== result");
    [self pushDetailVC];
    return YES;
    
}// called when 'return' key pressed. return NO to ignore.





- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        // 创建布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize  = CGSizeMake(SCREEN_W/2-10, 50);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) collectionViewLayout:layout];
        // 设置内容滚动视图
        _collectionView.bounces = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identify];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyCollectionViewHeaderView"];
        
    
        
    }
    
    return _collectionView;
}




#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/**
 每个分区item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _maryCollection.count;
}
/**
 创建cell
 */
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    for (UIView *lab in [cell.contentView subviews]) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    cell.backgroundColor = Randon_Color;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.width, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = [_maryCollection objectAtIndex:indexPath.row];
    
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}
/**
 创建区头视图和区尾视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionViewHeaderView" forIndexPath:indexPath];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W, 30)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = [NSString stringWithFormat:@"猜你想搜的"];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return nil;
    
    
}
/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
     [self resignFirstResponderSearchView];
}
/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (SCREEN_W-3*10)/2;
    return CGSizeMake(w, 30);
}


/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kLineSpacing, 0, kLineSpacing);
}





/**
 区头大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_W, 30);
}


@end
