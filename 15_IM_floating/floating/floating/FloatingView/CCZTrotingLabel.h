//
//  CCZTrotingLabel.h
//  CCZTrotView
//
//  Created by  on 16/9/25.
//  Copyright © 2016年 . All rights reserved.
//

/// 使用时只需要用这个封装好的 CCZTrotingLabel就可以了

#import "CCZTrotingView.h"
#import "CCZTrotingAttribute.h"


typedef void(^CCZTrotingStartBlock)(NSString *giftID);
typedef void(^CCZTrotingStopBlock)(void);


@interface CCZTrotingLabel : CCZTrotingView

@property (nonatomic, strong, readonly) UILabel *currentLabel;
//礼物跑马灯相关
@property (nonatomic, strong) NSMutableArray *giftIdArr;
@property (nonatomic, copy) NSString *currentGiftId;
@property (nonatomic, copy) CCZTrotingStartBlock giftStartBlock;
@property (nonatomic, copy) CCZTrotingStopBlock giftStopBlock;


- (void)addTrotAttribute:(CCZTrotingAttribute *)attribute;
- (void)addTextArray:(NSArray *)textArray;
- (void)addAttributeArray:(NSArray *)attArray;

- (void)removeAttributeAtIndex:(NSUInteger)index;
- (void)removeAllAttribute;
@end
