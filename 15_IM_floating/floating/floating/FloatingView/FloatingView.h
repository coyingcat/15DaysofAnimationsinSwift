//
//  FloatingView.h
//  
//
//  Created by  on 16/9/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingView : UIView

@property (nonatomic, strong) UIView *currentTrotView;  /**< 当前正在滚动的view*/
@property (nonatomic, strong) UIView *trotContaierView;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) BOOL isTroting;   /**< 是否在滚动*/


/**
 添加需要滚动的view
 */
- (void)addTrotView:(UIView *)trotView;
/**
 停止troting
 */
- (void)trotingStop:(void(^)(void))stopBlock;

/**
 开始troting
 */
- (void)trotingStart:(void(^)(void))startBlcok;
/**
 正在troting
 */
- (void)troting:(void(^)(void))trotingBlock;
/**
 主动去执行troting，会重置正在进行的troting
 */
- (void)updateTroting;
@end



