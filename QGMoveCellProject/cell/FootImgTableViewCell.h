//
//  FootImgTableViewCell.h
//  CDC
//
//  Created by cdc on 2018/4/4.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeleteCellBtnAction)(UITableViewCell *cell);
typedef void (^FoodImgAction)(void);
@interface FootImgTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *image;
/**
 *  成品描述
 */
@property(nonatomic,strong)UITextView *txtView;
/**
 *  删除cell回调
 */
@property(nonatomic,copy)DeleteCellBtnAction deleteAction;
/**
 *  成品图cell回调
 */
@property(nonatomic,copy)FoodImgAction foodImgAction;

-(void)setTitle:(NSInteger)row;
-(void)initData;
@end



