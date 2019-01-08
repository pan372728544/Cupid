//
//  MyView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "MyView.h"

@implementation MyView

-(id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(customControllerPopHandle:)];
        [self addGestureRecognizer:panGesture];
        
    }
    return self;
}

- (void)customControllerPopHandle:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"==== %f",[recognizer translationInView:self].x);
    
    self.frame = CGRectMake(100+[recognizer translationInView:self].x, 100+[recognizer translationInView:self].y, 100, 100) ;

    
}
@end
