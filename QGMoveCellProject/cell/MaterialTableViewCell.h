//
//  MaterialTableViewCell.h
//  CDC
//
//  Created by cdc on 2018/4/2.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeleteCellBtnAction)(UITableViewCell *cell);
@interface MaterialTableViewCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *txtname;
@property(nonatomic,strong)UITextField *txtDosage;
@property(nonatomic,copy)DeleteCellBtnAction deleteAction;
@property(nonatomic,copy)void (^addNameBlock)(NSString *name);
@property(nonatomic,copy)void (^addUseBlock)(NSString *name);

-(void)initData;
@end
