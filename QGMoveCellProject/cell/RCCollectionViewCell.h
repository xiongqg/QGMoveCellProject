//
//  RCCollectionViewCell.h
//  CDC
//
//  Created by cdc on 2018/5/15.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *cellBtn;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy)void (^btnClickAction)(void);
-(void)updataBtn:(BOOL)isSelect;
@end
