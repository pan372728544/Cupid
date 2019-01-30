//
//  HomeChannelViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeChannelViewController.h"
#import "ChannelTopView.h"
#import "HomeChannelCollectionViewCell.h"
#import "HomeChannelModel.h"
#import "ChannelCollectionView.h"

@interface HomeChannelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ChannelCellDeleteDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)ChannelTopView *topView;

// 数据数组
@property(nonatomic,strong)NSMutableArray *channelTags;
@property(nonatomic,strong)NSMutableArray *recomTags;



// 模型数组
@property(nonatomic,strong)NSMutableArray *maryChannelModels;
@property(nonatomic,strong)NSMutableArray *maryRecommandModels;


//
@property (nonatomic, strong) ChannelCollectionView *mainView ;


@property (nonatomic, strong)UIButton *editBtn;//编辑按钮

@property (nonatomic, assign)BOOL onEdit;//tag处在编辑状态
@property (nonatomic, assign)BOOL tagDeletable;//在长按tag的时候是否可以删除该tag


@end

@implementation HomeChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _channelTags = @[@"关注",@"推荐",@"热点",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食",@"图片",@"火车",@"朋友圈",@"火车",@"外星人"].mutableCopy;
    _recomTags = @[@"小说",@"时尚",@"历史",@"育儿",@"直播",@"搞笑",@"数码",@"养生",@"电影",@"手机",@"旅游",@"宠物",@"情感",@"家居",@"教育",@"三农",@"研究",@"生物",@"物理"].mutableCopy;
    
    [self makeTags];
    [self initTopView];
     _onEdit = NO;
    [self initMainView];
}


-(void)viewDidDisappear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)initTopView
{
    
    [self.view addSubview:self.topView];
}



// 关闭
-(void)clickClose
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (void)makeTags{
    _maryChannelModels = @[].mutableCopy;
    _maryRecommandModels = @[].mutableCopy;
    for (NSString *title in _channelTags) {
        HomeChannelModel *mod = [[HomeChannelModel alloc]init];
        mod.title = title;
        if ([title isEqualToString:@"关注"]||[title isEqualToString:@"推荐"]) {
            mod.resident = YES;//常驻
        }
        mod.editable = YES;
        mod.selected = NO;
        mod.tagType = MyChannel;
        //demo默认选择第一个
        if ([title isEqualToString:@"关注"]) {
            mod.selected = YES;
        }
        [_maryChannelModels addObject:mod];
    }
    for (NSString *title in _recomTags) {
        HomeChannelModel *mod = [[HomeChannelModel alloc]init];
        mod.title = title;
        if ([title isEqualToString:@"关注"]||[title isEqualToString:@"推荐"]) {
            mod.resident = YES;//常驻
        }
        mod.editable = NO;
        mod.tagType = RecommandChannel;
        [_maryRecommandModels addObject:mod];
    }
}

- (void)initMainView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _mainView = [[ChannelCollectionView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_W,SCREEN_H-44-STATUSBAR_H) collectionViewLayout:layout];
    [self.view addSubview:_mainView];
    _mainView.backgroundColor = [UIColor whiteColor];

    _mainView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    
    [_mainView registerClass:[HomeChannelCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1"];
    [_mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2"];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    //添加长按的手势
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_mainView addGestureRecognizer:longPress];
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:_mainView];
    //从长按开始
    NSIndexPath *indexPath=[_mainView indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [_mainView beginInteractiveMovementForItemAtIndexPath:indexPath];
        if (_onEdit) {
        }else{
            [self editTags:_editBtn];
        }
        _tagDeletable = NO;
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [_mainView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [_mainView endInteractiveMovement];
        _tagDeletable = YES;
        //其他情况
    } else {
        [_mainView cancelInteractiveMovement];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 支持多手势
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0)
{
    // 这个方法返回YES，第一个手势和第二个互斥时，第一个会失效
    if ([otherGestureRecognizer.view isKindOfClass:[ChannelCollectionView class]]) {
        return YES;
    }
    return NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setGestureRecognizerEnable:YES scrollView:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setGestureRecognizerEnable:YES scrollView:scrollView];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // 结束的时候手势可用
    [self setGestureRecognizerEnable:YES scrollView:scrollView];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滑动到顶部的时候设置手势失效
    if (scrollView.contentOffset.y <=0) {

        [self setGestureRecognizerEnable:NO scrollView:scrollView];
    }

    else
    {
        // 手势可用
        [self setGestureRecognizerEnable:YES scrollView:scrollView];
    }
}

-(void)setGestureRecognizerEnable:(BOOL)isEnable scrollView:(UIScrollView *)scrollView
{
    for (UIGestureRecognizer *gesRec in  scrollView.gestureRecognizers) {
        if ([gesRec isKindOfClass:[UIPanGestureRecognizer class]]) {

            gesRec.enabled =isEnable;
        }
    }
}



#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _maryChannelModels.count;
    }else{
        return _maryRecommandModels.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellIdentifier";
    HomeChannelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_maryChannelModels.count>indexPath.item) {
            cell.model = _maryChannelModels[indexPath.item];
            cell.delBtn.tag = indexPath.item;
            cell.delegate = self;
            if (_onEdit) {
                if (cell.model.resident) {
                    cell.delBtn.hidden = YES;
                }else{
                    if (!cell.model.editable) {
                        cell.delBtn.hidden = YES;
                    }else{
                        cell.delBtn.hidden = NO;
                    }
                }
            }else{
                cell.delBtn.hidden = YES;
            }
        }
    }else if (indexPath.section == 1){
        if (_maryRecommandModels.count>indexPath.item) {
            cell.model = _maryRecommandModels[indexPath.item];
            if (_onEdit) {
                cell.delBtn.hidden = NO;
            }else{
                cell.delBtn.hidden = YES;
            }
        }
    }
    return cell;
}

#pragma mark- collection delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_W/4-10, 53);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 4, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 50);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader){

            NSString *CellIdentifier = @"head1";
            header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            
            for (UIView *v in [header subviews]) {
                [v removeFromSuperview];
            }
            
            UILabel *lab1 = [[UILabel alloc]init];
            lab1.text = @"我的频道";
            lab1.frame = CGRectMake(20, 0, 100, 60);
            lab1.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
            
            UILabel *lab2 = [[UILabel alloc]init];
            lab2.text = @"点击进入频道";
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.frame = CGRectMake(100, 2, 200, 60);
            lab2.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];

            // 获取编辑按钮文本
            NSString *title = self.editBtn.titleLabel.text?:@"编辑";
            
            _editBtn = [[UIButton alloc]init];
            _editBtn.frame = CGRectMake(collectionView.frame.size.width-60, 13, 44, 24);
            
            [header addSubview:lab1];
            [header addSubview:lab2];
            [header addSubview:_editBtn];

            [_editBtn setTitle:title forState:UIControlStateNormal];
            _editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [_editBtn setTitleColor:COLOR_COMMONRED forState:UIControlStateNormal];
            _editBtn.layer.borderColor = COLOR_COMMONRED.CGColor;
            _editBtn.layer.masksToBounds = YES;
            _editBtn.layer.cornerRadius = 12;
            _editBtn.layer.borderWidth = 0.8;
            [_editBtn addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = @"head2";
            header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            UILabel *lab1 = [[UILabel alloc]init];
            [header addSubview:lab1];
            lab1.text = @"频道推荐";
            lab1.frame = CGRectMake(20, 0, 100, 60);
            lab1.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
            
            UILabel *lab2 = [[UILabel alloc]init];
            [header addSubview:lab2];
            lab2.text = @"点击添加频道";
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.frame = CGRectMake(100, 2, 200, 60);
            lab2.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        }
    }
    return header;
}

/** 进入编辑状态 */
- (void)editTags:(UIButton *)sender{
    
    if (!_onEdit) {
        for (HomeChannelCollectionViewCell *items in _mainView.visibleCells) {
            if (items.model.tagType == MyChannel) {
                if (items.model.resident) {
                    items.delBtn.hidden = YES;
                }else{
                    items.delBtn.hidden = NO;
                }
            }
        }
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        for (HomeChannelCollectionViewCell *items in _mainView.visibleCells) {
            if (items.model.tagType == MyChannel) {
                items.delBtn.hidden = YES;
            }
        }
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    _onEdit = !_onEdit;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeChannelCollectionViewCell *cell = (HomeChannelCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell.model.resident) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    HomeChannelModel *object= _maryChannelModels[sourceIndexPath.item];
    [_maryChannelModels removeObjectAtIndex:sourceIndexPath.item];
    if (destinationIndexPath.section == 0) {
        [_maryChannelModels insertObject:object atIndex:destinationIndexPath.item];
    }else if (destinationIndexPath.section == 1) {
        object.tagType = RecommandChannel;
        object.editable = NO;
        object.selected = NO;
        [_maryRecommandModels insertObject:object atIndex:destinationIndexPath.item];
        [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    }
    
    [self refreshDelBtnsTag];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSInteger item = 0;
        for (HomeChannelModel *mod in _maryChannelModels) {
            if (mod.selected) {
                mod.selected = NO;
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
            }
            item++;
        }
        HomeChannelModel *object = _maryChannelModels[indexPath.item];
        object.selected = YES;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        typeof(self) __weak weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            //单选某个tag
            if (weakSelf.selectedTag) {
                weakSelf.selectedTag(object);
            }
        }];
    }else if (indexPath.section == 1) {
        HomeChannelCollectionViewCell *cell = (HomeChannelCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.model.editable = YES;
        cell.model.tagType = MyChannel;
        cell.delBtn.hidden = YES;
        [_mainView reloadItemsAtIndexPaths:@[indexPath]];
        [_maryRecommandModels removeObjectAtIndex:indexPath.item];
        [_maryChannelModels addObject:cell.model];
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:_maryChannelModels.count-1 inSection:0];
        cell.delBtn.tag = targetIndexPage.item;
        [_mainView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
    
    [self refreshDelBtnsTag];
}

-(void)deleteCell:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    HomeChannelCollectionViewCell *cell = (HomeChannelCollectionViewCell *)[_mainView cellForItemAtIndexPath:indexPath];
    cell.model.editable = NO;
    cell.model.tagType = RecommandChannel;
    cell.model.selected = NO;
    cell.delBtn.hidden = YES;
    [_mainView reloadItemsAtIndexPaths:@[indexPath]];
    
    id object = _maryChannelModels[indexPath.item];
    [_maryChannelModels removeObjectAtIndex:indexPath.item];
    [_maryRecommandModels insertObject:object atIndex:0];
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [_mainView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    [self refreshDelBtnsTag];
}

/** 刷新删除按钮的tag */
- (void)refreshDelBtnsTag{
    
    for (HomeChannelCollectionViewCell *cell in _mainView.visibleCells) {
        NSIndexPath *indexpath = [_mainView indexPathForCell:cell];
        cell.delBtn.tag = indexpath.item;
    }
}



- (void)returnLast{
    typeof(self) __weak weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.choosedTags) {
            weakSelf.choosedTags(_maryChannelModels,_maryRecommandModels);
        }
    }];
}








-(ChannelTopView *)topView
{
    if (!_topView) {
        
        WEAKSELF
        _topView = [[ChannelTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 44 )];
        _topView.blockClickClose = ^{
          
            [weakSelf clickClose];
        };
        
    }
    return _topView;
}
@end
