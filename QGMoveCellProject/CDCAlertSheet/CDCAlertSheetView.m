//
//  CDCAlertSheetView.m
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "CDCAlertSheetView.h"
#import "Header.h"

@implementation CDCAlertSheetView
@synthesize dataArr;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}


- (void)initView
{
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(40);
//        make.right.equalTo(self.mas_right).offset(-40);
//        make.bottom.equalTo(self.mas_bottom).offset(-20);
//        make.height.equalTo(@50);
//    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
//        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-20);
        
        //        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    //    self.contentView.shareBtnClickBlock = self.shareBtnClickBlock;
    
}

//- (void)setShareBtnClickBlock:(void (^)(NSIndexPath *))shareBtnClickBlock
//{
//    _shareBtnClickBlock = shareBtnClickBlock;
//    self.contentView.shareBtnClickBlock = shareBtnClickBlock;
//
//}


#pragma mark - Lazy Load

-(void)reload
{
    _contentView.dataArr = self.dataArr;
}
-(CDCAlertContentView*)contentView{
    _contentView = [[CDCAlertContentView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    @weakify(self)
    _contentView.shareBtnClickBlock=^(NSIndexPath *path){
        @strongify(self)
        if (self.shareBtnClickBlock) {
            self.shareBtnClickBlock(path);
        }
    };
    [self addSubview:_contentView];
    return _contentView;
}
//- (UIButton *)cancelBtn
//{
//    if (_cancelBtn == nil) {
//        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelBtn.backgroundColor = RGB(200, 30, 30);
//        [_cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        _cancelBtn.layer.cornerRadius = 25;
//        _cancelBtn.layer.masksToBounds = YES;
//        [self addSubview:_cancelBtn];
//    }
//    return _cancelBtn;
//}
@end
