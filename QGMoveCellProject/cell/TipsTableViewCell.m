//
//  TipsTableViewCell.m
//  CDC
//
//  Created by cdc on 2018/5/14.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "TipsTableViewCell.h"
#import "Header.h"

@interface TipsTableViewCell()
@property(nonatomic,strong)UIView *categoryView;
@end
@implementation TipsTableViewCell
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
    UITextView *txtView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, BXScreenW-20, 130)];
    [txtView setDelegate:self];
    txtView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    txtView.layer.borderColor = [RGB(245, 245, 245) CGColor];
    txtView.layer.borderWidth = 1.0;
    [txtView setFont:[UIFont systemFontOfSize:14]];
    [txtView.layer setMasksToBounds:YES];
    [self addSubview:txtView];
    self.txtView=txtView;
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"分享您做这道菜的心得和小技巧给更多小伙伴哦～";
    [placeholderLabel setFont:[UIFont systemFontOfSize:14]];
    [placeholderLabel setTextColor:RGB(153, 153, 153)];
    [txtView addSubview:placeholderLabel];
    [txtView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    
    UILabel *categoryTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, QGViewYH(txtView)+20, BXScreenW-20, 12)];
    [categoryTitle setFont:[UIFont systemFontOfSize:11]];
    [categoryTitle setText:@"写到这里你太棒了，选择分类，让更多的小伙伴看到你的手艺^_^"];
    [categoryTitle setTextColor:TEXTCOLOR];
    [self addSubview:categoryTitle];
    UIView *categoryView=[[UIView alloc]initWithFrame:CGRectMake(10, QGViewYH(categoryTitle)+10, BXScreenW-20, 45)];
    [categoryView setBackgroundColor:RGB(245, 245, 245)];
    [self addSubview:categoryView];
    self.categoryView=categoryView;
    UILabel *categoryLab=[[UILabel alloc]initWithFrame:CGRectMake(10, (45-16)/2, BXScreenW-20, 16)];
    [categoryLab setFont:[UIFont systemFontOfSize:16]];
    [categoryLab setText:@"推荐分类"];
    [categoryLab setTextAlignment:NSTextAlignmentLeft];
    [categoryLab setTextColor:TEXTCOLOR51];
    [categoryView addSubview:categoryLab];
    UILabel *categoryChooseLab=[[UILabel alloc]initWithFrame:CGRectMake(QGViewW(categoryView)-120, (45-16)/2, 100, 16)];
    [categoryChooseLab setFont:[UIFont systemFontOfSize:16]];
    [categoryChooseLab setText:@"请选择"];
    [categoryChooseLab setTextAlignment:NSTextAlignmentRight];
    [categoryChooseLab setTextColor:TEXTCOLOR];
    [categoryView addSubview:categoryChooseLab];
    UIImageView *rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(QGViewW(categoryView)-22, (45-22)/2, 22, 22)];
    [rightImg setImage:[UIImage imageNamed:@"rightArrow"]];
    [categoryView addSubview:rightImg];
    UIButton *chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setFrame:CGRectMake(0, 0, QGViewW(categoryView), QGViewH(categoryView))];
//    [chooseBtn setBackgroundColor:RGB(255, 0, 0)];
    [chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:chooseBtn];
//    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, QGViewYH(categoryView)+90, BXScreenW, 12)];
//    [lab setFont:[UIFont systemFontOfSize:12]];
//    [lab setText:@"已自动为您保存草稿至草稿箱"];
//    [lab setTextColor:RGB(153, 153, 153)];
//    [lab setTextAlignment:NSTextAlignmentCenter];
//    [self addSubview:lab];
//    NSLog(@"%f",QGViewYH(lab)+30);
    UIView *catView=[[UIView alloc]initWithFrame:CGRectMake(0, QGViewYH(self.categoryView), BXScreenW, 60)];
    [catView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:catView];
    self.catView=catView;

}
-(void)setLabelStr:(NSArray *)arr
{
    NSLog(@"%@",arr);
    [self.catView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<arr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10+70*i,10, 60, 30)];
        [btn setTitle:[[arr objectAtIndex:i]objectForKey:@"ct_name"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setBackgroundColor:RGB(205,30,30)];
        [self.catView addSubview:btn];
    }
}
-(void)chooseAction:(id)sender
{
    if (self.chooseCategoryBlock) {
        self.chooseCategoryBlock();
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textStrBlock) {
        self.textStrBlock(textView.text);
    }
}
@end
