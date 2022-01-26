//
//  FloatingLabel.h
//  
//
//  Created by  on 16/9/25.
//  Copyright © 2016年 . All rights reserved.
//

/// 使用时只需要用这个封装好的 FloatingLabel就可以了

#import "FloatingView.h"
#import "FloatingAttribute.h"


typedef void(^CCZTrotingStartBlock)(NSString *giftID);
typedef void(^CCZTrotingStopBlock)(void);


@interface FloatingLabel : FloatingView

@property (nonatomic, strong, readonly) UILabel *currentLabel;
//跑马灯相关
@property (nonatomic, strong) NSMutableArray *tipIdList;
@property (nonatomic, copy) NSString *currentGiftId;
@property (nonatomic, copy) CCZTrotingStartBlock giftStartBlock;
@property (nonatomic, copy) CCZTrotingStopBlock giftStopBlock;


- (void)addTrotAttribute:(FloatingAttribute *)attribute;
- (void)addTextArray:(NSArray *)textArray;
- (void)addAttributeArray:(NSArray *)attArray;

- (void)removeAttributeAtIndex:(NSUInteger)index;
- (void)removeAllAttribute;
@end
