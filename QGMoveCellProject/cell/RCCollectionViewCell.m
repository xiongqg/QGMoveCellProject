//
//  RCCollectionViewCell.m
//  CDC
//
//  Created by cdc on 2018/5/15.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "RCCollectionViewCell.h"
#import "Header.h"

@implementation RCCollectionViewCell
@synthesize isSelect;
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (UIButton *)cellBtn
{
    if (_cellBtn == nil) {
        UIButton *cellBtn = [[UIButton alloc] init];
        cellBtn.backgroundColor = [UIColor clearColor];
        [cellBtn setTitleColor:TEXTCOLOR102 forState:UIControlStateNormal];
        cellBtn.layer.borderWidth = 1;
        cellBtn.layer.borderColor = [TEXTCOLOR102 CGColor];
        [cellBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        [ToolGeneral setRoundedCorners:cellBtn size:CGSizeMake(3, 3)];
        [cellBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cellBtn];
        _cellBtn = cellBtn;
    }
    return _cellBtn;
}
-(void)updataBtn:(BOOL)isSelect{
    if (isSelect) {
        [self.cellBtn setBackgroundColor:RGB(205, 30, 30)];
        [self.cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cellBtn.layer.borderColor = [RGB(205, 30, 30) CGColor];
    }else{
        [self.cellBtn setTitleColor:TEXTCOLOR102 forState:UIControlStateNormal];
        self.cellBtn.layer.borderColor = [TEXTCOLOR102 CGColor];
        [self.cellBtn setBackgroundColor:[UIColor whiteColor]];
        
    }
    
}
-(void)click
{
    if (self.btnClickAction) {
        self.btnClickAction();
    }
}

@end
