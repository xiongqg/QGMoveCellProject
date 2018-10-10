//
//  FootImgTableViewCell.m
//  CDC
//
//  Created by cdc on 2018/4/4.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "FootImgTableViewCell.h"
#import "Header.h"
@interface FootImgTableViewCell()
@property(nonatomic,strong)UILabel *titLab;
@end
@implementation FootImgTableViewCell
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

    // Configure the view for the selected state
}
-(void)initCustomView
{
    self.titLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, BXScreenW-20, 16)];
    [self.titLab setTextColor:TEXTCOLOR51];
    [self.titLab setFont:[UIFont systemFontOfSize:16]];
    [ self.titLab setText:@"成品图1:"];
    [self addSubview: self.titLab];
    UIButton *delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setFrame:CGRectMake(BXScreenW-65, 0, 30, 30)];
    delBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [delBtn setImage:[UIImage imageNamed:@"published_del"] forState:UIControlStateNormal];
    [[delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x){
        self.deleteAction(self);
    }];
    [self addSubview:delBtn];
    UIImageView *moveImg=[[UIImageView alloc]initWithFrame:CGRectMake(BXScreenW-26, QGViewY(delBtn)+12, 16, 6)];
    [moveImg setImage:[UIImage imageNamed:@"published_move"]];
    [self addSubview:moveImg];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, BXScreenW-20, (BXScreenW-20)/4*3)];
    [image setBackgroundColor:RGB(200, 200, 200)];
    [image setImage:[UIImage imageNamed:@"published_step"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [self addSubview:image];
    self.image=image;
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stepImgGesture:)];
    [image addGestureRecognizer:singleTap];
    
//    UITextView *txtView=[[UITextView alloc]initWithFrame:CGRectMake(10, QGViewYH(image), BXScreenW-20, 50)];
//    txtView.layer.backgroundColor = [[UIColor clearColor] CGColor];
//    //    txtView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//    //    txtView.layer.borderWidth = 1.0;
//    [txtView setFont:[UIFont systemFontOfSize:14]];
//    [txtView.layer setMasksToBounds:YES];
//    [self addSubview:txtView];
//    UILabel *placeholderLabel = [[UILabel alloc] init];
//    placeholderLabel.text = @"请填写成品描述（可选）";
//    [placeholderLabel setFont:[UIFont systemFontOfSize:14]];
//    [placeholderLabel setTextColor:RGB(153, 153, 153)];
//    [txtView addSubview:placeholderLabel];
//    [txtView setValue:placeholderLabel forKey:@"_placeholderLabel"];
}
-(void)setTitle:(NSInteger)row
{
    [ self.titLab setText:[NSString stringWithFormat:@"成品图%ld:",row]];

}
-(void)stepImgGesture:(UITapGestureRecognizer *)gesture{
    self.foodImgAction();
}
-(void)initData
{
    [self.image setImage:[UIImage imageNamed:@"published_step"]];
    
    
}
@end
