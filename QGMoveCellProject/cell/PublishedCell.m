//
//  PublishedCell.m
//  CDC
//
//  Created by cdc on 2018/4/17.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "PublishedCell.h"
#import "Header.h"
@interface PublishedCell()
@property(nonatomic,strong)UIView *lineLab;
@end
@implementation PublishedCell
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
    UIView *lineLab=[[UIView alloc]initWithFrame:CGRectMake(10, 50-1, BXScreenW-20, 1)];
    [lineLab setBackgroundColor:RGB(245, 245, 245)];
    [self.contentView addSubview:lineLab];
    self.lineLab=lineLab;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.lineLab.frame = CGRectMake(0, self.bounds.size.height-1,self.bounds.size.width, 1);
}

@end
