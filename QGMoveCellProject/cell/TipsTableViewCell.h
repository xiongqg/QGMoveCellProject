//
//  TipsTableViewCell.h
//  CDC
//
//  Created by cdc on 2018/5/14.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TipsTableViewCell : UITableViewCell<UITextViewDelegate>
@property(nonatomic,strong)UITextView *txtView;
@property(nonatomic,strong)UIView *catView;
@property (nonatomic, copy) void (^chooseCategoryBlock)(void);
@property (nonatomic, copy) void (^textStrBlock)(NSString *textStr);
-(void)setLabelStr:(NSArray *)arr;
@end
