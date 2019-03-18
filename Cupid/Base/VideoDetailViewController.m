//
//  VideoDetailViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/25.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "VideoDetailViewController.h"

@interface VideoDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-24-10, 10, 24, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"close_channel_24x24_"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W, SCREEN_H-30-STATUSBAR_H) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    
    [self.view addSubview:self.tableView];

    self.isSupportRightSlide = YES;
    
    [self.view addSubview:self.tableView];
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    for (UIGestureRecognizer *ges in  scrollView.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            
            ges.enabled =YES;
        }
    }
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableview滑动的时候 传递滑动方向
    if (scrollView.contentOffset.x==scrollView.contentOffset.y) {
        self.isUp = YES;
    }
    
    if (scrollView.contentOffset.y <=0) {
    
        for (UIGestureRecognizer *ges in  scrollView.gestureRecognizers) {

            if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
                ges.enabled =NO;
            }
        }
    }
    else
    {
        for (UIGestureRecognizer *ges in  scrollView.gestureRecognizers) {

            if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {

                ges.enabled =YES;
            }
        }
    }
}

// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    NSLog(@"gestureRecognizerShouldBegin");
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
//    [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
 
//      NSLog(@"%@===%@",[gestureRecognizer.view class],[otherGestureRecognizer.view class]);
//    [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"shouldRequireFailureOfGestureRecognizer");
//    [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
//    NSLog(@"%@==========%@",[gestureRecognizer.view class],[otherGestureRecognizer.view class]);
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {

        for (UIGestureRecognizer *ges in  otherGestureRecognizer.view.gestureRecognizers) {

            NSLog(@"已经修好+++++++++++++++shouldRequireFailureOfGestureRecognizer");
            if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {

                ges.enabled =YES;
            }
        }
        return YES;
    }
    return NO;
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
    
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数--%ld",indexPath.row];
    return cell;
    
}
@end
