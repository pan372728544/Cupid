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
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W,500) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;

    
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
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm";
    
    return cell;
    
}
@end
