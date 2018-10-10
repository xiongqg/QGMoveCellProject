//
//  StepTableViewCell.m
//  CDC
//
//  Created by cdc on 2018/4/3.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "StepTableViewCell.h"
#import "Header.h"

@interface StepTableViewCell()<UITextViewDelegate>
@property(nonatomic,strong)UILabel *titLab;
@end
@implementation StepTableViewCell
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
//    [self setBackgroundColor:RGB(255, 0, 0)];
    self.titLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, BXScreenW-20, 16)];
    [self.titLab setTextColor:TEXTCOLOR51];
    [self.titLab setFont:[UIFont systemFontOfSize:16]];
    [ self.titLab setText:@"步骤1:"];
    [self addSubview: self.titLab];
    UIButton *delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setFrame:CGRectMake(BXScreenW-65, 3, 30, 30)];
    delBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [delBtn setImage:[UIImage imageNamed:@"published_del"] forState:UIControlStateNormal];
    [[delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x){
        self.deleteAction(self);
    }];        
    [self addSubview:delBtn];
    UIImageView *moveImg=[[UIImageView alloc]initWithFrame:CGRectMake(BXScreenW-26, QGViewY(delBtn)+12, 16, 6)];
    [moveImg setImage:[UIImage imageNamed:@"published_move"]];
    [self addSubview:moveImg];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, QGViewYH(self.titLab)+10, BXScreenW-20, (BXScreenW-20)/4*3)];
    [image setBackgroundColor:RGB(200, 200, 200)];
    [image setImage:[UIImage imageNamed:@"published_step"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [self addSubview:image];
    self.image=image;
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stepImgGesture:)];
    [image addGestureRecognizer:singleTap];
    
    UITextView *txtView=[[UITextView alloc]initWithFrame:CGRectMake(10, QGViewYH(image)+10, BXScreenW-20, 50)];
    txtView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    txtView.delegate=self;
//    txtView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//    txtView.layer.borderWidth = 1.0;
    [txtView setFont:[UIFont systemFontOfSize:14]];
    [txtView.layer setMasksToBounds:YES];
    [self addSubview:txtView];
    self.txtView=txtView;
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"请填写步骤描述";
    [placeholderLabel setFont:[UIFont systemFontOfSize:14]];
    [placeholderLabel setTextColor:RGB(153, 153, 153)];
    [txtView addSubview:placeholderLabel];
    [txtView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(10, QGViewYH(txtView), BXScreenW-20, 1)];
    [line1 setBackgroundColor:RGB(222, 222, 222)];
    [self addSubview:line1];
    UIView *moreView=[[UIView alloc]initWithFrame:CGRectMake(10, QGViewYH(line1), BXScreenW-20, 40)];
    [moreView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:moreView];
    
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(BXScreenW-100, QGViewYH(line1), 100, 40)];
//    [btn setTitle:@"显示更多可填项" forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [btn setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
//    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [moreView setHidden:NO];
//        [x setHidden:YES];
//
//    }];
//    [self addSubview:btn];
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(10, QGViewYH(moreView), BXScreenW-20, 1)];
    [line2 setBackgroundColor:RGB(222, 222, 222)];
    [self addSubview:line2];
    
    UIButton *stepTimeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [stepTimeBtn setFrame:CGRectMake(0, 0, QGViewW(moreView)/2, 40)];
    [stepTimeBtn setTitle:@"步骤用时（可选）" forState:UIControlStateNormal];
    [stepTimeBtn setImage:[UIImage imageNamed:@"published_upArrow"] forState:UIControlStateNormal];
    stepTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [stepTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [stepTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, QGViewXW(stepTimeBtn)-20, 0, 0)];
    [stepTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [stepTimeBtn setTitleColor:TEXTCOLOR51 forState:UIControlStateNormal];
    [stepTimeBtn addTarget:self action:@selector(stepTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:stepTimeBtn];
    self.stepTimeBtn=stepTimeBtn;
    UIButton *stepUseNumBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [stepUseNumBtn setFrame:CGRectMake(QGViewXW(stepTimeBtn), 0, QGViewW(moreView)/2, 40)];
    [stepUseNumBtn setTitle:@"步骤用料（可选）" forState:UIControlStateNormal];
    [stepUseNumBtn setImage:[UIImage imageNamed:@"published_upArrow"] forState:UIControlStateNormal];
    stepUseNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [stepUseNumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [stepUseNumBtn setImageEdgeInsets:UIEdgeInsetsMake(0, QGViewXW(stepTimeBtn)-12, 0, 0)];
    [stepUseNumBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [stepUseNumBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [stepUseNumBtn setTitleColor:TEXTCOLOR51 forState:UIControlStateNormal];
    [stepUseNumBtn addTarget:self action:@selector(stepUseNumAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:stepUseNumBtn];
    self.stepUseNumBtn=stepUseNumBtn;
    UILabel *timeNumLine=[[UILabel alloc]initWithFrame:CGRectMake(QGViewXW(stepTimeBtn), 10, 1, 20)];
    [timeNumLine setBackgroundColor:RGB(200, 200, 200)];
    [moreView addSubview:timeNumLine];
    
//    [moreView setHidden:YES];
    
}
-(void)setTitle:(NSInteger)row detail:(NSString*)detailStr time:(NSString*)timeStr material:(NSString*)materialStr
{
    [ self.titLab setText:[NSString stringWithFormat:@"步骤%ld:",row]];
    if (![detailStr isEqualToString:@""]&&detailStr!=nil) {
        self.txtView.text=detailStr;
    }
    if (![timeStr isEqualToString:@""]&&timeStr!=nil) {
        [self.stepTimeBtn setTitle:timeStr forState:UIControlStateNormal];
    }else
    {
        [self.stepTimeBtn setTitle:@"步骤用时（可选）" forState:UIControlStateNormal];

    }
    if (![materialStr isEqualToString:@""]&&materialStr!=nil) {
        [self.stepUseNumBtn setTitle:materialStr forState:UIControlStateNormal];
    }else
    {
        [self.stepUseNumBtn setTitle:@"步骤用料（可选）" forState:UIControlStateNormal];

    }

}
-(void)stepImgGesture:(UITapGestureRecognizer *)gesture{
    self.stepImgAcion();
}
-(void)initData
{
    [self.image setImage:[UIImage imageNamed:@"published_step"]];
    self.txtView.text=@"";
    [self.stepTimeBtn setTitle:@"步骤用时（可选）" forState:UIControlStateNormal];
    [self.stepUseNumBtn setTitle:@"步骤用料（可选）" forState:UIControlStateNormal];

}
-(void)stepTimeAction:(id)sender
{
    if (self.stepTimeBolck) {
        self.stepTimeBolck();
    }
}
-(void)stepUseNumAction:(id)sender
{
    if (self.stepUseNumBolck) {
        self.stepUseNumBolck();
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.stepDetailBolck) {
        self.stepDetailBolck(textView.text);
    }
}
@end
