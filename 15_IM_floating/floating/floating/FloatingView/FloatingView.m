//
//  FloatingView.m
//  
//
//  Created by  on 16/9/22.
//  Copyright © 2016年 . All rights reserved.
//

#import "FloatingView.h"

typedef void(^CCZTrotingBlock)(void);
@interface FloatingView ()<CAAnimationDelegate>
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) CAKeyframeAnimation *trotingXAnimation;

@property (nonatomic, strong) NSMutableArray *trotViewArr;  /**< 用于存放待滚动的view的*/
@property (nonatomic, copy)   CCZTrotingBlock stopBlock;
@property (nonatomic, copy)   CCZTrotingBlock startBlock;
@property (nonatomic, copy)   CCZTrotingBlock trotingBlock;
@end

@implementation FloatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __basicSetting];
        [self __pageSetting];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __basicSetting];
        [self __pageSetting];
    }
    return self;
}

- (void)__basicSetting {
    self.backgroundColor = [UIColor whiteColor];
    _duration = 10;
    _isTroting = NO;
    self.hidden = YES;
    _trotViewArr = [NSMutableArray array];
}

- (void)__pageSetting {
    
    _trotContaierView = [[UIView alloc] init];
    _trotContaierView.clipsToBounds = YES;
    [self addSubview:_trotContaierView];
}

- (void)layoutSubviews {
    self.trotContaierView.frame = self.bounds;
    // initialize trot frame
    CGSize trotContainerSize = self.trotContaierView.frame.size;
    UIView *trotView = [self.trotViewArr firstObject];
    self.currentTrotView = trotView;
    CGSize trotSize = trotView.frame.size;
    if (!trotView) {
        return;
    }
    self.hidden = NO;
    _isTroting = YES;
    
    if (self.trotingBlock) {
        self.trotingBlock();
    }
    
   
        trotView.frame = CGRectMake(trotContainerSize.width, (_size.height - trotSize.height) / 2, trotSize.width, trotSize.height);
        UIView * label = [self.trotViewArr firstObject];
        CGRect labelFrame = label.frame;
        CGPoint labelOrigin = CGPointMake(labelFrame.origin.x, (self.bounds.size.height - labelFrame.size.height) / 2);
        label.frame = CGRectMake(labelOrigin.x, labelOrigin.y, labelFrame.size.width, labelFrame.size.height);
        CGFloat len = (trotContainerSize.width + trotSize.width);
        self.trotingXAnimation.values = @[@(0), @(- trotContainerSize.width), @(- trotContainerSize.width), @(- len)];
        NSTimeInterval pause = 3.0;
        NSTimeInterval total = _duration + pause;
        NSTimeInterval percent = trotContainerSize.width / len;
        NSTimeInterval widthTime = percent * _duration /total ;
        self.trotingXAnimation.keyTimes = @[@0, @(widthTime), @(pause / total + widthTime), @(1)];
    
    if ([trotView.layer animationForKey:@"trotingX"]) {
        [trotView.layer removeAnimationForKey:@"trotingX"];
    }

        self.trotingXAnimation.removedOnCompletion = NO;
        self.trotingXAnimation.repeatCount = 0;
        [trotView.layer addAnimation:self.trotingXAnimation forKey:@"trotingX"];
}

- (CAKeyframeAnimation *)trotingXAnimation {
    if (!_trotingXAnimation) {
        _trotingXAnimation = [CAKeyframeAnimation animation];
        _trotingXAnimation.keyPath = @"transform.translation.x";
        _trotingXAnimation.delegate = self;
        _trotingXAnimation.duration = _duration;
        _trotingXAnimation.fillMode = kCAFillModeForwards;
        _trotingXAnimation.removedOnCompletion = NO;
    }
    return _trotingXAnimation;
}


#pragma mark - public

- (void)addTrotView:(UIView *)trotView {
    if (self.currentTrotView) {
        [self.trotViewArr removeObject:self.trotViewArr.firstObject];
        [self.currentTrotView removeFromSuperview];
    }
    
    [self.trotViewArr addObject:trotView];
    [self.trotContaierView addSubview:trotView];
    
    if (!_isTroting) {
        [self setNeedsLayout];
    }
}

- (void)trotingStop:(void (^)(void))stopBlock {
    if (stopBlock) {
        self.stopBlock = stopBlock;
    }
}

- (void)trotingStart:(void (^)(void))startBlcok {
    if (startBlcok) {
        self.startBlock = startBlcok;
    }
}

- (void)troting:(void (^)(void))trotingBlock {
    if (trotingBlock) {
        self.trotingBlock = trotingBlock;
    }
}

- (void)updateTroting {
    [self setNeedsLayout];
}

#pragma mark - Set

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    self.trotingXAnimation.duration = duration;
}

#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isTroting = NO;
    self.hidden = YES;
    
    if (self.stopBlock) {
        self.stopBlock();
    }
}

@end
