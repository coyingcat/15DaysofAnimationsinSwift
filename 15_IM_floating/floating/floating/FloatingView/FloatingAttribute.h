//
//  FloatingAttribute.h
//  CCZTrotView
//
//  Created by  on 16/9/25.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatingAttribute : NSObject
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) NSAttributedString *attribute;
@property (nonatomic, copy) NSString *identifier; //／ 这个属性可以用作特殊用途
@end
