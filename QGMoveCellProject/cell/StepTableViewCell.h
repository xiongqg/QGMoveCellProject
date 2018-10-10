//
//  StepTableViewCell.h
//  CDC
//
//  Created by cdc on 2018/4/3.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeleteCellBtnAction)(UITableViewCell *cell);
typedef void (^StepImgAcion)(void);
@interface StepTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *image;  //步骤图
@property(nonatomic,strong)UITextView *txtView; //详细
@property(nonatomic,strong)UIButton *stepTimeBtn; //用时
@property(nonatomic,strong)UIButton *stepUseNumBtn;//用量

@property(nonatomic,copy)DeleteCellBtnAction deleteAction;
@property(nonatomic,copy)StepImgAcion stepImgAcion;
@property(nonatomic,copy)void (^stepDetailBolck)(NSString *str);
@property(nonatomic,copy)void (^stepTimeBolck)(void);
@property(nonatomic,copy)void (^stepUseNumBolck)(void);
-(void)setTitle:(NSInteger)row detail:(NSString*)detailStr time:(NSString*)timeStr material:(NSString*)materialStr;
-(void)initData;
@end
