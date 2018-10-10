//
//  PreviewSkillsCell.m
//  CDC
//
//  Created by cdc on 2018/5/22.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "PreviewSkillsCell.h"
#import "Header.h"
@interface PreviewSkillsCell()
@property(nonatomic,strong)UILabel *contentLab;
@end
@implementation PreviewSkillsCell
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
//    [self setBackgroundColor:[UIColor yellowColor]];
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, BXScreenW-20, 0)];
//    [contentLab setBackgroundColor:RGB(255, 0, 0)];
    [contentLab setFont:[UIFont systemFontOfSize:16]];
    [contentLab setTextColor:TEXTCOLOR102];
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    [self.contentView addSubview:contentLab];
    self.contentLab=contentLab;

}
-(void)setContentWithContentStr:(NSString*)contentStr
{
    [self.contentLab setText:contentStr];
    CGSize size = [self.contentLab.text boundingRectWithSize:CGSizeMake(BXScreenW-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLab.font} context:nil].size;
    [self.contentLab setFrame:CGRectMake(10, 0, BXScreenW-20, size.height)];
}
@end
