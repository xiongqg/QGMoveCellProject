//
//  PreviewFoodImgCell.m
//  CDC
//
//  Created by cdc on 2018/5/22.
//  Copyright © 2018年 CDC. All rights reserved.
//

#import "PreviewFoodImgCell.h"
#import "Header.h"

@interface PreviewFoodImgCell()
@property(nonatomic,strong)UIImageView *imageV;
@end
@implementation PreviewFoodImgCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, BXScreenW-20, (BXScreenW-20)/4*3)];
    [imageV setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:imageV];
    self.imageV=imageV;
    
}
-(void)setRecipeFoodImg:(NSString *)imgStr
{
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
}
-(void)setPreviewFoodImg:(NSString *)imgStr
{
    [self.imageV setImage:[self base64Decode:imgStr]];
}
-(UIImage*)base64Decode:(NSString*)base64Str{
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData: decodeData];
    return decodedImage;
}
@end
