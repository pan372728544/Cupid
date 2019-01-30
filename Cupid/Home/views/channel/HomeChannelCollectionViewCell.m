//
//  HomeChannelCollectionViewCell.m
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeChannelCollectionViewCell.h"

@interface HomeChannelCollectionViewCell()

@property(nonatomic,strong)CAShapeLayer *maskLayer;

@end

@implementation HomeChannelCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //title
        _title = [[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _title.frame = CGRectMake(5, 5, frame.size.width-10, frame.size.height-10);
        
        // 任意圆角
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.title.bounds byRoundingCorners:UIRectCornerAllCorners   cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        
        maskLayer.frame = self.title.layer.bounds;
        maskLayer.path = path.CGPath;
        [_title.layer addSublayer:maskLayer];
        self.maskLayer= maskLayer;
        
         _title.textColor = RGBAColor(78, 78, 78, 1);
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
        _title.backgroundColor = [UIColor clearColor];
        
        
        // 删除图标
        _delBtn = [[UIButton alloc]init];
        [self.contentView addSubview:_delBtn];
        _delBtn.frame = CGRectMake(frame.size.width-18, 0, 18, 18);
        [_delBtn setImage:[UIImage imageNamed:@"deleteicon_channel_18x18_"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setModel:(HomeChannelModel *)model{
    
    _model = model;

    if (model.tagType == MyChannel) {
        self.maskLayer.fillColor =RGBAColor(245, 245, 245, 1).CGColor;
        
        // 阴影颜色
        _title.layer.shadowColor = [UIColor clearColor].CGColor;

        
        if ([model.title containsString:@"＋"]) {
            model.title = [model.title substringFromIndex:1];
        }
        if (model.editable) {
        }else{
            model.editable = YES;
        }
        if (model.resident) {
            _delBtn.hidden = YES;
        }else{
            _delBtn.hidden = NO;
        }
        
        //选择出来的tag高亮显示
        if (model.selected) {
            _title.textColor = COLOR_COMMONRED;
        }else{
            _title.textColor = RGBAColor(78, 78, 78, 1);
        }
        
    }else if (model.tagType == RecommandChannel){
        
       self.maskLayer.fillColor =RGBAColor(255, 255, 255, 1).CGColor;
        // 阴影颜色
        _title.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        // 阴影偏移，默认(0, -3)
        _title.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        _title.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        _title.layer.shadowRadius = 5;
        
        if (![model.title containsString:@"＋"]) {
            model.title = [@"＋" stringByAppendingString:model.title];
        }
        if (model.editable) {
            model.editable = NO;
        }else{
        }
        _delBtn.hidden = YES;
    }
    _title.text = model.title;
    
}



- (void)delete:(UIButton *)sender{
    
    [_delegate deleteCell:sender];
}


@end
