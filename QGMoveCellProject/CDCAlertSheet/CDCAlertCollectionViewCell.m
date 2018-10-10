//
//  CDCAlertCollectionViewCell.m
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "CDCAlertCollectionViewCell.h"
#import "Header.h"

@implementation CDCAlertCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIButton *)cellBtn
{
    if (_cellBtn == nil) {
        UIButton *cellBtn = [[UIButton alloc] init];
        cellBtn.backgroundColor = [UIColor clearColor];
        [cellBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cellBtn.layer.borderWidth = 1;
        cellBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [cellBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:cellBtn];
        _cellBtn = cellBtn;
    }
    return _cellBtn;
}
-(void)updataBtn{
    if (self.isSelected) {
        [self.cellBtn setBackgroundColor:RGBCOLOR(0xffa5a6a)];
        [self.cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cellBtn.layer.borderColor = [RGBCOLOR(0xffa5a6a) CGColor];
    }else{
        [self.cellBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.cellBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self.cellBtn setBackgroundColor:[UIColor whiteColor]];

    }
   
}
@end
