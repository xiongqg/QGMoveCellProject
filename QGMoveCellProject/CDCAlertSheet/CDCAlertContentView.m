//
//  CDCAlertContentView.m
//  CDC
//
//  Created by cdc on 2018/5/11.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "CDCAlertContentView.h"
#import "CDCAlertCollectionViewCell.h"
#import "Header.h"

@interface CDCAlertContentView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UILabel *tipLabel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation CDCAlertContentView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
- (void)initView
{
//    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(15);
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.left.right.offset(0);
//    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.right.offset(0);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    _indexPath=nil;
}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr=dataArr;
    [self.collectionView reloadData];

}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width-30*5)/4, 30);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 30, 20, 30);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView.collectionViewLayout invalidateLayout];
    return self.dataArr.count;
}
-(void)updateCellStatus:(CDCAlertCollectionViewCell *)cell selected:(BOOL)selected
{
    cell.backgroundColor = [UIColor redColor];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CDCAlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDCAlertCollectionViewCell" forIndexPath:indexPath];
    NSString *str= self.dataArr[indexPath.item];
    [cell.cellBtn setTitle:str forState:UIControlStateNormal];
    @weakify(self)
    [[cell.cellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.shareBtnClickBlock) {
            self.shareBtnClickBlock(indexPath);
//            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            CDCAlertCollectionViewCell * cell1;
            if (self.indexPath!=nil) {
                cell1 = (CDCAlertCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.indexPath];
                [cell1 setSelected:NO];
                [cell1 updataBtn];
            }
            if ([cell isEqual:cell1]) {
                self.indexPath=nil;
                return ;
            }
            [cell setSelected:YES];
            self.indexPath=indexPath;
            [cell updataBtn];
        }
    }];
    return cell;
}


#pragma mark - Lazy Load

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [self addSubview:_collectionView];
        [_collectionView registerClass:[CDCAlertCollectionViewCell class] forCellWithReuseIdentifier:@"CDCAlertCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces=NO;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


- (UICollectionViewFlowLayout *)flowLayout
{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((self.frame.size.width-30*5)/4, 30);
    }
    return _flowLayout;
}


- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setBackgroundColor:[UIColor whiteColor]];
        _tipLabel.font = [UIFont systemFontOfSize:17];
        _tipLabel.textColor = [UIColor blackColor];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        _tipLabel.text = @"";
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
