//
//  CDCAlertContentView.h
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDCAlertContentView : UIView
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) void (^shareBtnClickBlock)(NSIndexPath *index);
@property (nonatomic, assign) BOOL isSingle;
@end
