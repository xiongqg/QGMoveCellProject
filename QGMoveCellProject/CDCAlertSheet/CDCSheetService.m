//
//  CDCSheetService.m
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "CDCSheetService.h"
#import "CDCAlertSheetView.h"
#import "Header.h"
@interface CDCSheetService ()
@property (nonatomic, strong) CDCAlertSheetView *sheetView;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, strong) UIView *maskView;
@end
@implementation CDCSheetService
@synthesize dataArr;
+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static CDCSheetService* service;
    dispatch_once(&onceToken, ^{
        service = [[CDCSheetService alloc] init];
    });
    return service;
}

- (void)showInViewController:(UIViewController *)viewController
{
    [self showShareSheetView:viewController];
}

- (void)showShareSheetView:(UIViewController *)viewController
{
    if (self.isShowing) {return;}
    self.isShowing = YES;
    UIWindow *keyWindow = viewController.view.window;
    NSLog(@"%@",NSStringFromCGRect(keyWindow.frame));
    
    // 添加maskView
    UIView *maskView = [[UIView alloc] init];
    [keyWindow addSubview:maskView];
    self.maskView = maskView;
    maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    
    [maskView layoutIfNeeded];
    NSLog(@"%@",NSStringFromCGRect(maskView.frame));
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSheetView)];
    [maskView addGestureRecognizer:tap];
    CDCAlertSheetView *sheetView = [[CDCAlertSheetView alloc] init];
    sheetView.dataArr=dataArr;
    [viewController.view.window addSubview:sheetView];
    [sheetView reload];
    self.sheetView = sheetView;
    CGFloat height = dataArr.count /4 *45+40+30;
    if (dataArr.count%4!=0) {
        height=height+45;
    }
    self.sheetView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height);
    CGRect frame = self.sheetView.frame;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGFloat y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.sheetView.frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    @weakify(self)
    self.sheetView.shareBtnClickBlock=^(NSIndexPath*path){
        @strongify(self)
        if (self.shareBtnClickBlock) {
            self.shareBtnClickBlock(path);
        }
        [self hideSheetView];
    };
    
//    [[self.sheetView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        [self hideSheetView];
//        if (self.cancelClickBlock) {
//            self.cancelClickBlock();
//        }
//    }];
}

- (void)hideSheetView
{
    CGRect frame = self.sheetView.frame;
    [UIView animateWithDuration:.1 delay:0 usingSpringWithDamping:.1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGFloat y = [UIScreen mainScreen].bounds.size.height ;
        self.sheetView.frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        [self.sheetView removeFromSuperview];
        self.sheetView = nil;
        self.isShowing = NO;
        [self.maskView removeFromSuperview];
    }];
}


#pragma mark - Lazy Load

- (CDCAlertSheetView *)sheetView
{
    if (_sheetView == nil) {
        _sheetView = [[CDCAlertSheetView alloc] init];
        
    }
    return _sheetView;
}
@end
