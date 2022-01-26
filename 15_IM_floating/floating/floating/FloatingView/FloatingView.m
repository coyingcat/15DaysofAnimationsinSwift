//
//  FloatingView.m
//  
//
//  Created by  on 16/9/22.
//  Copyright © 2016年 . All rights reserved.
//

#import "FloatingView.h"

typedef void(^FlyingBlock)(void);
@interface FloatingView ()<CAAnimationDelegate>


@property (nonatomic, strong) CAKeyframeAnimation *flyingXAnimation;

@property (nonatomic, strong) NSMutableArray *trotViewArr;
/**< 用于存放待滚动的view的*/
@property (nonatomic, copy)   FlyingBlock stopBlock;
@property (nonatomic, copy)   FlyingBlock startBlock;
@property (nonatomic, copy)   FlyingBlock trotingBlock;
@end

@implementation FloatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    self.backgroundColor = [UIColor whiteColor];
    _duration = 10;
    _isTroting = NO;
    self.hidden = YES;
    _trotViewArr = [NSMutableArray array];
    
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
    
   
        trotView.frame = CGRectMake(trotContainerSize.width, (self.bounds.size.height - trotSize.height) / 2, trotSize.width, trotSize.height);
        CGFloat len = (trotContainerSize.width + trotSize.width);
        self.flyingXAnimation.values = @[@(0), @(- trotContainerSize.width), @(- trotContainerSize.width), @(- len)];
        NSTimeInterval pause = 3.0;
        NSTimeInterval total = _duration + pause;
        NSTimeInterval percent = trotContainerSize.width / len;
        NSTimeInterval widthTime = percent * _duration /total ;
        self.flyingXAnimation.keyTimes = @[@0, @(widthTime), @(pause / total + widthTime), @(1)];
    
    if ([trotView.layer animationForKey:@"trotingX"]) {
        [trotView.layer removeAnimationForKey:@"trotingX"];
    }

        self.flyingXAnimation.removedOnCompletion = NO;
        self.flyingXAnimation.repeatCount = 0;
        [trotView.layer addAnimation:self.flyingXAnimation forKey:@"trotingX"];
}

- (CAKeyframeAnimation *)flyingXAnimation {
    if (!_flyingXAnimation) {
        _flyingXAnimation = [CAKeyframeAnimation animation];
        _flyingXAnimation.keyPath = @"transform.translation.x";
        _flyingXAnimation.delegate = self;
        _flyingXAnimation.duration = _duration;
        _flyingXAnimation.fillMode = kCAFillModeForwards;
        _flyingXAnimation.removedOnCompletion = NO;
    }
    return _flyingXAnimation;
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
    
    self.flyingXAnimation.duration = duration;
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
