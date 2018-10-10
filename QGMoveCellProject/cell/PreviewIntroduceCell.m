//
//  PreviewIntroduceCell.m
//  CDC
//
//  Created by cdc on 2018/5/22.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "PreviewIntroduceCell.h"
#import "Header.h"

@interface PreviewIntroduceCell()
@property(nonatomic,strong)UILabel *contentLab;
@property(nonatomic,strong)UIView *btnView;
@end
@implementation PreviewIntroduceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCustomView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)initCustomView
{
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, BXScreenW-20, 200)];
    [contentLab setText:@"食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍食材介绍"];
    [contentLab setFont:[UIFont systemFontOfSize:14]];
    [contentLab setTextColor:TEXTCOLOR102];
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    [self.contentView addSubview:contentLab];
    CGSize size = [contentLab.text boundingRectWithSize:CGSizeMake(BXScreenW-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLab.font} context:nil].size;
    [contentLab setFrame:CGRectMake(10, 20, BXScreenW-20, size.height)];
    self.contentLab=contentLab;
    
    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, QGViewYH(contentLab)+15, BXScreenW, 50)];
    [btnView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:btnView];
    self.btnView=btnView;
}
-(void)setContentWithContentStr:(NSString*)contentStr
{
    [self.contentLab setText:contentStr];
    CGSize size = [self.contentLab.text boundingRectWithSize:CGSizeMake(BXScreenW-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLab.font} context:nil].size;
    [self.contentLab setFrame:CGRectMake(10, 20, BXScreenW-20, size.height)];
    [self.btnView setFrame:CGRectMake(0, QGViewYH(self.contentLab)+15, BXScreenW, 50)];
}
-(void)setLabelBtn:(NSArray*)arr
{
//    [self.btnView removeFromSuperview];
    [arr enumerateObjectsUsingBlock:^(id dic, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10+70*idx, 0, 60, 30)];
        [btn setTitle:[dic objectForKey:@"ct_name"] forState:UIControlStateNormal];
        [btn setBackgroundColor:RGB(245, 245, 245)];
        [btn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.btnView addSubview:btn];
    }];
}

@end
