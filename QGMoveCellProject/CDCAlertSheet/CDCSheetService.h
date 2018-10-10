//
//  CDCSheetService.h
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CDCSheetService : NSObject
@property (nonatomic, copy) void (^shareBtnClickBlock)(NSIndexPath *index);
@property (nonatomic, copy) void (^cancelClickBlock)();
@property(nonatomic,copy)NSArray *dataArr;

+ (instancetype)shared;

- (void)showInViewController:(UIViewController *)viewController;
- (void)hideSheetView;
@end
