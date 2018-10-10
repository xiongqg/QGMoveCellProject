//
//  AddTableViewCell.m
//  CDC
//
//  Created by cdc on 2018/4/3.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "AddTableViewCell.h"
#import "Header.h"
@interface AddTableViewCell()
@property(nonatomic,strong)UIButton *addBtn;
@end
@implementation AddTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.identifier=reuseIdentifier;
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
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, 0, BXScreenW, 30)];
//    [addBtn setBackgroundColor:[UIColor redColor]];
    [addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[addBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.addBtnAction(self.identifier);
    }];
    [self.contentView addSubview:addBtn];
//    if ([self.identifier isEqualToString:@"AddMain"]) {
//        [self.addBtn setTitle:@"添加主料" forState:UIControlStateNormal];
//
//    }else if ([self.identifier isEqualToString:@"AddMain"])
//    {
//        [self.addBtn setTitle:@"添加辅料" forState:UIControlStateNormal];
//
//    }else if ([self.identifier isEqualToString:@"AddMain"])
//    {
//        [self.addBtn setTitle:@"添加步骤" forState:UIControlStateNormal];
//
//    }else if ([self.identifier isEqualToString:@"AddMain"])
//    {
//        [self.addBtn setTitle:@"添加成品图" forState:UIControlStateNormal];
//
//    }
//    else
//    {
//
//    }
    
    self.addBtn=addBtn;
}
-(void)setBtnTitle:(NSString *)title
{
    [self.addBtn setTitle:title forState:UIControlStateNormal];
}
@end
