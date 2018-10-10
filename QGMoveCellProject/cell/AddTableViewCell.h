//
//  AddTableViewCell.h
//  CDC
//
//  Created by cdc on 2018/4/3.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddBtnAction)(NSString *identifier);
@interface AddTableViewCell : UITableViewCell
@property(nonatomic,copy)AddBtnAction addBtnAction;
@property(nonatomic,copy)NSString *identifier;
-(void)setBtnTitle:(NSString *)title;
@end
