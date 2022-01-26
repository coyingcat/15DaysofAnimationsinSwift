//
//  FloatingLabel.m
//  
//
//  Created by  on 16/9/25.
//  Copyright © 2016年 . All rights reserved.
//

#import "FloatingLabel.h"

@interface FloatingLabel()
@property (nonatomic, strong, readwrite) UILabel *currentLabel;
@property (nonatomic, strong) NSMutableArray *attributeArr;
@property (nonatomic, assign) NSUInteger index; // 控制滚动的文本显示
@end

@implementation FloatingLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self basicSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetting];
    }
    return self;
}

- (void)basicSetting {
    self.index = 0;
    self.tipIdList = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self trotingStop:^{
        if (weakSelf.attributeArr.count) {
            [weakSelf.attributeArr removeObject:weakSelf.attributeArr.firstObject];
            if (weakSelf.attributeArr.count != 0) {
                [weakSelf addTrotAttribute:nil];
            }
        }
        // 移除礼物id
        if (weakSelf.tipIdList.count) {
            [weakSelf.tipIdList removeObjectAtIndex:0];
        }
        
        // 当无礼物id时  说明已全部播放完
        if (weakSelf.tipIdList.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.giftStopBlock) {
                    weakSelf.giftStopBlock();
                }
            });
        }
    }];
    
    //开始滚动
    [self trotingStart:^{
        weakSelf.currentGiftId = weakSelf.tipIdList.firstObject;
        if (weakSelf.giftStartBlock) {
            weakSelf.giftStartBlock(weakSelf.currentGiftId);
        }
        
    }];
    
    
    
    
    
}

#pragma mark - add att

- (void)addTrotAttribute:(FloatingAttribute *)attribute {
    if (attribute) {
        [self.attributeArr addObject:attribute];
    }
    
    FloatingAttribute *trotingAtt = self.attributeArr[self.index];
    
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.font = [UIFont systemFontOfSize:14];
        _currentLabel.textColor = UIColor.redColor;
        [self trotingWithAttribute:trotingAtt];
        [self addTrotView:_currentLabel];
    } else if (!self.isTroting) {
            [self trotingWithAttribute:trotingAtt];
            [self updateTroting];
    }
}

- (void)addText:(NSString *)text {
    FloatingAttribute *trotingAtt = [[FloatingAttribute alloc] init];
    trotingAtt.text = text;
    [self addTrotAttribute:trotingAtt];
}

- (void)addTextArray:(NSArray *)textArray {
    for (id text in textArray) {
        if ([text isKindOfClass:[NSString class]]) {
            [self addText:text];
        }
    }
}


- (void)addAttributeArray:(NSArray *)attArray {
    for (id att in attArray) {
        if ([att isKindOfClass:[FloatingAttribute class]]) {
            [self addTrotAttribute:att];
        }
    }
}

- (void)trotingWithAttribute:(FloatingAttribute *)att {
    _currentLabel.text = att.text;
    if (att.attribute) {
        _currentLabel.attributedText = att.attribute;
    }
    CGSize textSize = [att.text sizeWithAttributes:@{NSFontAttributeName: _currentLabel.font}];
    _currentLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    
    __weak typeof(self) weakSelf = self;
    [self troting:^{
        CGSize trotContrinerSize = weakSelf.trotContaierView.frame.size;
            weakSelf.duration = (trotContrinerSize.width + textSize.width) / 40;
    }];
}

#pragma mark - remove

- (void)removeAttributeAtIndex:(NSUInteger)index {
    if (index <= self.attributeArr.count - 1) {
        [self.attributeArr removeObjectAtIndex:index];
        if (self.index >= index) {
            self.index--;
        }
    }
}

- (void)removeAllAttribute {
    [self.attributeArr removeAllObjects];
    self.index = 0;
}


- (NSMutableArray *)attributeArr {
    if (!_attributeArr) {
        _attributeArr = [NSMutableArray array];
    }
    return _attributeArr;
}

@end
