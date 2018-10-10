//
//  CDCAlertSheetView.h
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDCAlertContentView.h"
@interface CDCAlertSheetView : UIView
@property (nonatomic, copy) void (^shareBtnClickBlock)(NSIndexPath *index);
@property(nonatomic,copy)NSArray *dataArr;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) CDCAlertContentView *contentView;
-(void)reload;
@end
