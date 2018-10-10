//
//  MaterialTableViewCell.m
//  CDC
//
//  Created by cdc on 2018/4/2.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "MaterialTableViewCell.h"
#import "Header.h"
@implementation MaterialTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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

 
    
}
-(void)initCustomView
{
    UITextField *txtname=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, (BXScreenW-25)/2, 30)];
    txtname.delegate=self;
    [txtname setBackgroundColor:RGB(245, 245, 245)];
    txtname.placeholder=@"材料名称";
    [txtname setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:txtname];
    self.txtname=txtname;
    UITextField *txtDosage=[[UITextField alloc]initWithFrame:CGRectMake(QGViewXW(txtname)+5,5,QGViewW(txtname), 30)];
    txtDosage.delegate=self;
    [txtDosage setBackgroundColor:RGB(245, 245, 245)];
    [txtDosage setFont:[UIFont systemFontOfSize:12]];
    txtDosage.placeholder=@"用量";
    [self addSubview:txtDosage];
    self.txtDosage=txtDosage;
    UIButton *delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setFrame:CGRectMake(BXScreenW-65, 0, 40, 40)];
    delBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [delBtn setImage:[UIImage imageNamed:@"published_del"] forState:UIControlStateNormal];
    [[delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x){
        self.deleteAction(self);
    }];
    [self addSubview:delBtn];
    UIImageView *moveImg=[[UIImageView alloc]initWithFrame:CGRectMake(BXScreenW-26, QGViewY(delBtn)+17, 16, 6)];
    [moveImg setImage:[UIImage imageNamed:@"published_move"]];
    [self addSubview:moveImg];
    UILabel *lineLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 39, BXScreenW-20, 1)];
    [lineLab setBackgroundColor:RGB(200, 200, 200)];
    [self addSubview:lineLab];
}
-(void)initData
{
    self.txtDosage.text=@"";
    self.txtname.text=@"";
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    if ([textField isEqual:self.txtname]) {
        self.addNameBlock(textField.text);
    }else
    {
        self.addUseBlock(textField.text);

    }
}
@end
