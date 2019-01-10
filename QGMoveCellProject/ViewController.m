//
//  ViewController.m
//  QGMoveCellProject
//
//  Created by cdc on 2018/10/10.
//  Copyright © 2018年 QG. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "AddTableViewCell.h"
#import "MaterialTableViewCell.h"
#import "StepTableViewCell.h"
#import "FootImgTableViewCell.h"
#import "PublishedCell.h"
#import "TipsTableViewCell.h"
#import "CDCSheetService.h"
typedef enum {
    AutoScrollUp,
    AutoScrollDown
} AutoScroll;
typedef enum{
    COVERIMG,
    STEPIMG,
    FOODIMG
} IMGTYPE;
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *coverImg;
@property(nonatomic,strong)UIImage *cover;                              //*****封面图
@property(nonatomic,assign)NSInteger stepImgIndex;                      //*****步骤图点击index
@property(nonatomic,assign)NSInteger finishFoodImgIndex;                //*****成品图点击index
@property(nonatomic,copy)NSString *recipeNameStr;
@property(nonatomic,strong)UITextField *titleTxtFiled;
@property(nonatomic,copy)NSString *storyStr;
@property(nonatomic,strong)UITextView *storyView;
@property(nonatomic,assign)BOOL keyBoardlsVisible;
//选择图片
@property(nonatomic,strong)ZLPhotoActionSheet *actionSheet;

@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *mainArr;                 //主料
@property(nonatomic,strong)NSMutableArray *supplementaryArr;        //副料
@property(nonatomic,strong)NSMutableArray *processShowArr;        //工艺类别
@property(nonatomic,strong)NSMutableArray *processShowIdArr;        //工艺类别
@property(nonatomic,strong)NSMutableArray *stepArr;                 //步骤
@property(nonatomic,strong)NSMutableArray *imgArr;                  //成品图
@property(nonatomic,strong)NSMutableArray *categoryArr;
@property(nonatomic,copy)NSArray *sectionZeroImgArr;
@property(nonatomic,assign)IMGTYPE IMGTYPE;
@property(nonatomic,copy)NSString *tipStr;
//工艺类别
@property(nonatomic,copy)NSArray *processArr;
@property(nonatomic,copy)NSArray *tasteArr;         //口味
@property(nonatomic,copy)NSArray *timeArr;
@property(nonatomic,copy)NSArray *quantityArr;
@property(nonatomic,copy)NSArray *difficultyArr;

//长按cell Move
@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) NSIndexPath *fromIndexPath;
@property (nonatomic, strong) NSIndexPath *toIndexPath;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) AutoScroll autoScroll;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isGroup;

@property(nonatomic,copy)NSDictionary *dataDic;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self initData];
    
    self.array=[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BXScreenW, BXScreenH) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    tableView.sectionIndexColor = [UIColor colorWithRed:200/255 green:200/255 blue:200/255 alpha:1];
    tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView = tableView;
    //    [self.tableView setEditing:YES animated:NO];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    _scrollSpeed = 3;
    self.isGroup=YES;
    [self.tableView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveRow:)]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)initData
{
    _keyBoardlsVisible=NO;
    self.mainArr=[NSMutableArray array];
    self.supplementaryArr=[NSMutableArray array];
    self.stepArr=[NSMutableArray array];
    self.imgArr=[NSMutableArray array];
    self.categoryArr=[NSMutableArray array];
    self.processShowArr=[NSMutableArray array];
    self.processShowIdArr=[NSMutableArray array];
    NSArray *processShow=@[@"",@"",@"",@"",@""];
    [self.processShowArr addObjectsFromArray:processShow];
    [self.processShowIdArr addObjectsFromArray:processShow];
    self.sectionZeroImgArr=@[@{@"img":@"process",@"name":@"工艺"},@{@"img":@"taste",@"name":@"口味"},@{@"img":@"time",@"name":@"时间"},@{@"img":@"component",@"name":@"份量"},@{@"img":@"difficulty",@"name":@"难度"}];
    NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"i_name",@"",@"i_use",nil];
    [self.mainArr addObject:mainDic];
    [self.supplementaryArr addObject:mainDic];
    
    UIImage *image=[UIImage imageNamed:@"published_step"];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableDictionary *stepDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:imageData,@"cook_step_pic",@"",@"step_detail",@"",@"step_time",@"",@"step_material",nil];
    [self.stepArr addObject:stepDic];
    self.cover=[UIImage imageNamed:@"published_headImg"];
    
    [self.imgArr addObject:imageData];
    
    self.stepImgIndex=0;
    self.finishFoodImgIndex=0;
    self.recipeNameStr=@"";
    self.storyStr=@"";
    self.tipStr=@"";
    _dataDic=[[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"LABELARR"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --Cell Move
- (void)moveRow:(UILongPressGestureRecognizer *)sender {
    [self.view endEditing:YES];
    //获取点击的位置
    CGPoint point = [sender locationInView:self.tableView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //根据手势点击的位置，获取被点击cell所在的indexPath
        self.fromIndexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if (!_fromIndexPath) return;
        //根据indexPath获取cell
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_fromIndexPath];
        if (_fromIndexPath.section==0||_fromIndexPath.section==5) {
            return;
        }
        //创建一个imageView，imageView的image由cell渲染得来
        self.cellImageView = [self createCellImageView:cell];
        
        //更改imageView的中心点为手指点击位置
        __block CGPoint center = cell.center;
        _cellImageView.center = center;
        _cellImageView.alpha = 0.0;
        [UIView animateWithDuration:0.1 animations:^{
            center.y = point.y;
            self.cellImageView.center = center;
            self.cellImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
            self.cellImageView.alpha = 1.0;
            cell.alpha = 0.0;
        } completion:^(BOOL finished) {
            cell.hidden = YES;
        }];
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        if (_fromIndexPath.section==0||_fromIndexPath.section==5) {
            return;
        }
        //根据手势的位置，获取手指移动到的cell的indexPath
        _toIndexPath = [self.tableView indexPathForRowAtPoint:point];
        
        //更改imageView的中心点为手指点击位置
        CGPoint center = self.cellImageView.center;
        center.y = point.y;
        self.cellImageView.center = center;
        
        //判断cell是否被拖拽到了tableView的边缘，如果是，则自动滚动tableView
        if ([self isScrollToEdge]) {
            [self startTimerToScrollTableView];
        } else {
            [_displayLink invalidate];
        }
        
        /*
         若当前手指所在indexPath不是要移动cell的indexPath，
         且是插入模式，则执行cell的插入操作
         每次移动手指都要执行该判断，实时插入
         */
        if (_toIndexPath && ![_toIndexPath isEqual:_fromIndexPath]){
            [self insertCell:_toIndexPath];
        }
    } else {
        if (_fromIndexPath.section==0||_fromIndexPath.section==5) {
            return;
        }
        /*
         如果是交换模式，则执行交换操作
         交换操作等手势结束时执行，不用每次移动都执行
         */
        //        if (self.isExchange) [self exchangeCell:point];
        [_displayLink invalidate];
        //将隐藏的cell显示出来，并将imageView移除掉
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_fromIndexPath];
        cell.hidden = NO;
        cell.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            
            cell.alpha = 1;
            self.cellImageView.alpha = 0;
            self.cellImageView.transform = CGAffineTransformIdentity;
            self.cellImageView.center = cell.center;
        } completion:^(BOOL finished) {
            [self.cellImageView removeFromSuperview];
            self.cellImageView = nil;
        }];
    }
}

- (BOOL)isScrollToEdge {
    //imageView拖动到tableView顶部，且tableView没有滚动到最上面
    if ((CGRectGetMaxY(self.cellImageView.frame) > self.tableView.contentOffset.y + self.tableView.frame.size.height - self.tableView.contentInset.bottom) && (self.tableView.contentOffset.y < self.tableView.contentSize.height - self.tableView.frame.size.height + self.tableView.contentInset.bottom)) {
        self.autoScroll = AutoScrollDown;
        return YES;
    }
    
    //imageView拖动到tableView底部，且tableView没有滚动到最下面
    if ((self.cellImageView.frame.origin.y < self.tableView.contentOffset.y + self.tableView.contentInset.top) && (self.tableView.contentOffset.y > -self.tableView.contentInset.top)) {
        self.autoScroll = AutoScrollUp;
        return YES;
    }
    return NO;
}

- (void)startTimerToScrollTableView {
    [_displayLink invalidate];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableView)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)scrollTableView{
    //如果已经滚动到最上面或最下面，则停止定时器并返回
    if ((_autoScroll == AutoScrollUp && self.tableView.contentOffset.y <= -self.tableView.contentInset.top)
        || (_autoScroll == AutoScrollDown && self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height + self.tableView.contentInset.bottom)) {
        [_displayLink invalidate];
        return;
    }
    
    //改变tableView的contentOffset，实现自动滚动
    CGFloat height = _autoScroll == AutoScrollUp? -_scrollSpeed : _scrollSpeed;
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + height)];
    //改变cellImageView的位置为手指所在位置
    _cellImageView.center = CGPointMake(_cellImageView.center.x, _cellImageView.center.y + height);
    
    //滚动tableView的同时也要执行插入操作
    _toIndexPath = [self.tableView indexPathForRowAtPoint:_cellImageView.center];
    if (_toIndexPath && ![_toIndexPath isEqual:_fromIndexPath]){
        [self insertCell:_toIndexPath];
    }
}


- (void)insertCell:(NSIndexPath *)toIndexPath {
    if (self.isGroup) {
        //先将cell的数据模型从之前的数组中移除，然后再插入新的数组
        if (_fromIndexPath.section==toIndexPath.section) {
            NSLog(@"移动%ld",_fromIndexPath.section);
            
            if (_fromIndexPath.section==1) {
                [self.mainArr exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
            }else if (_fromIndexPath.section==2){
                [self.supplementaryArr exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
                
            }else if (_fromIndexPath.section==3){
                [self.stepArr exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
                
            }else if (_fromIndexPath.section==4){
                [self.imgArr exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
                
            }
            
            [self.tableView reloadData];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:toIndexPath];
            cell.hidden = YES;
            _fromIndexPath = toIndexPath;
        }
        
    } else {
        //交换两个cell的数据模型
        [self.dataArray exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
}


- (void)exchangeCell:(CGPoint)point {
    NSIndexPath *toIndexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!toIndexPath) return;
    //交换要移动cell与被替换cell的数据模型
    if (self.isGroup) {
        //分组情况下，交换模型的过程比较复杂
        NSMutableArray *fromSection = self.dataArray[_fromIndexPath.section];
        NSMutableArray *toSection = self.dataArray[toIndexPath.section];
        id obj = fromSection[_fromIndexPath.row];
        [fromSection replaceObjectAtIndex:_fromIndexPath.row withObject:toSection[toIndexPath.row]];
        [toSection replaceObjectAtIndex:toIndexPath.row withObject:obj];
    } else {
        [self.dataArray exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
    [self.tableView reloadData];
}

- (UIImageView *)createCellImageView:(UITableViewCell *)cell {
    //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
    cellImageView.layer.shadowOpacity = 0.8f;
    cellImageView.layer.shadowOffset = CGSizeMake(0, 0);
    cellImageView.layer.zPosition=5;//长按cell截图 放在上层
    [self.tableView addSubview:cellImageView];
    return cellImageView;
}

- (void)viewDidLayoutSubviews {
    //重设frame
    NSLog(@"%lf",QGViewH(self.view));
}
#pragma mark--tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section==1)
    {
        return self.mainArr.count;
    }else if (section==2)
    {
        return self.supplementaryArr.count;
    }else if (section==3)
    {
        return self.stepArr.count;
    }else if (section==4)
    {
        return self.imgArr.count;
    }
    else {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 45;
    }else if(indexPath.section==1||indexPath.section==2){
        return 40;
    }else if (indexPath.section==3)
    {
        return (BXScreenW-20)/4*3+150;
    }else if (indexPath.section==4)
    {
        //成品图
        return (BXScreenW-20)/4*3+40;
    }else if (indexPath.section==5)
    {
        return 360;
    }
    else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return 355/(BXScreenW-20)*225+170;
    }else if(section==3||section==4)
    {
        return 0.001;
    }
    else{
        return 55;
    }
}
//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
#pragma mark -- 封面图
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BXScreenW, 350)];//创建一个视图
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *coverImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, BXScreenW-20, 355/(BXScreenW-20)*225)];
        coverImg.contentMode = UIViewContentModeScaleAspectFill;
        coverImg.clipsToBounds = YES;
        [coverImg setBackgroundColor:RGB(200, 200, 200)];
        [coverImg setImage:self.cover];
        coverImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverImgGesture:)];
        [coverImg addGestureRecognizer:singleTap];
        [headerView addSubview:coverImg];
        self.coverImg=coverImg;
        UITextField *titleTxt=[[UITextField alloc]initWithFrame:CGRectMake(10, QGViewYH(coverImg)+10, BXScreenW-20, 50)];
        [titleTxt setDelegate:self];
        [titleTxt setFont:[UIFont systemFontOfSize:18]];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入您的菜谱标题" attributes:
                                          @{NSForegroundColorAttributeName:TEXTCOLOR,
                                            NSFontAttributeName:titleTxt.font
                                            }];
        titleTxt.attributedPlaceholder = attrString;
        
        [titleTxt setBackgroundColor:RGB(245, 245, 245)];
        [headerView addSubview:titleTxt];
        [titleTxt setText:_recipeNameStr];
        self.titleTxtFiled=titleTxt;
        UITextView *storyView=[[UITextView alloc]initWithFrame:CGRectMake(10, QGViewYH(titleTxt)+10, BXScreenW-20, 90)];
        [storyView setDelegate:self];
        storyView.layer.backgroundColor = [[UIColor clearColor] CGColor];
        storyView.layer.borderColor = [RGB(189, 189, 189) CGColor];
        storyView.layer.borderWidth = 1.0;
        [storyView setFont:[UIFont systemFontOfSize:14]];
        [storyView.layer setMasksToBounds:YES];
        [headerView addSubview:storyView];
        [storyView setText:_storyStr];
        self.storyView=storyView;
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.text = @"说说这道菜背后的故事吧～";
        [placeholderLabel setFont:[UIFont systemFontOfSize:14]];
        [placeholderLabel setTextColor:RGB(200, 200, 200)];
        [storyView addSubview:placeholderLabel];
        [storyView setValue:placeholderLabel forKey:@"_placeholderLabel"];
        NSLog(@"%f  %f",QGViewYH(storyView),355/(BXScreenW-20)*225+170);
//        headerView.frame.size=CGSizeMake(BXScreenW-20, QGViewYH(storyView));
        [headerView setFrame:CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, BXScreenW-20, QGViewYH(storyView))];
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, BXScreenW-10, 30)];//创建一个视图
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel *lineLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 54, BXScreenW-20, 1)];
        [lineLab setBackgroundColor:RGB(200, 200, 200)];
        [headerView addSubview:lineLab];
        [lineLab setHidden:YES];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44-16, 150, 16)];
        headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
        headerLabel.textColor = TEXTCOLOR51;
        headerLabel.text =[NSString stringWithFormat:@"section%ld",section];
        [headerView addSubview:headerLabel];
        if (section==1) {
            headerLabel.text =@"主料";
            [lineLab setHidden:NO];
            
        }else if (section==2){
            headerLabel.text =@"辅料";
            [lineLab setHidden:NO];
        }else if (section==3){
            headerLabel.text =@"";
            [lineLab setHidden:YES];
            
        }else if (section==4)
        {
            headerLabel.text =@"";
            [lineLab setHidden:YES];
            
        }
        else{
            headerLabel.text =@"烹饪小贴士";
            [lineLab setHidden:YES];
            
        }
        
        return headerView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 0.001;
    }else if (section==5){
        return 50;
    }else{
        return 50;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==5) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, BXScreenW, 50)];
        UIButton *seeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [seeBtn setBackgroundColor:RGB(245,245,245)];
        [seeBtn setFrame:CGRectMake(0, 0, QGViewW(view)/2, QGViewH(view))];
        [seeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [seeBtn setTitle:@"预览" forState:UIControlStateNormal];
        [seeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [seeBtn addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:seeBtn];
        
        UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundColor:RGB(205,30,30)];
        [publishBtn setFrame:CGRectMake(QGViewW(view)/2, 0, QGViewW(view)/2, QGViewH(view))];
        [publishBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [publishBtn setTitle:@"马上发布" forState:UIControlStateNormal];
        [publishBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [publishBtn addTarget:self action:@selector(publicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:publishBtn];
        return view;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, BXScreenW, 50)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [addBtn setFrame:CGRectMake(0, 10, BXScreenW, 30)];
        [addBtn setImage:[UIImage imageNamed:@"published_add"] forState:UIControlStateNormal];
        [addBtn setTitleColor:RGB(255, 65, 19) forState:UIControlStateNormal];
        [[addBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (section==1) {
                NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"i_name",@"",@"i_use",nil];
                [self.mainArr addObject:mainDic];
                [self.tableView beginUpdates];
                NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow: self.mainArr.count-1  inSection:section];
                [self.tableView insertRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }else if (section==2) {
                NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"i_name",@"",@"i_use",nil];
                [self.supplementaryArr addObject:mainDic];
                [self.tableView beginUpdates];
                NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow: self.supplementaryArr.count-1  inSection:section];
                [self.tableView insertRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }else if (section==3) {
                UIImage *image=[UIImage imageNamed:@"published_step"];
                NSData *imageData = UIImagePNGRepresentation(image);
                NSMutableDictionary *stepDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:imageData,@"cook_step_pic",@"",@"step_detail",@"",@"step_time",@"",@"step_material",nil];
                [self.stepArr addObject:stepDic];
                
                [self.tableView beginUpdates];
                NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow: self.stepArr.count-1  inSection:section];
                [self.tableView insertRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }else if (section==4) {
                if (self.imgArr.count>3) {
//                    [ToolGeneral textExample:@"最多添加四张成品图" viewC:self];
                    return ;
                }
                UIImage *image=[UIImage imageNamed:@"published_step"];
                NSData *imageData = UIImagePNGRepresentation(image);
                //                NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:imageData,@"img",@"",@"detail",nil];
                [self.imgArr addObject:imageData];
                
                
                [self.tableView beginUpdates];
                NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow: self.imgArr.count-1  inSection:section];
                [self.tableView insertRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
            
        }];
        [view addSubview:addBtn];
        if (section==1) {
            [addBtn setTitle:@"添加主料" forState:UIControlStateNormal];
        }else if (section==2) {
            [addBtn setTitle:@"添加辅料" forState:UIControlStateNormal];
        }else if (section==3) {
            [addBtn setTitle:@"添加步骤" forState:UIControlStateNormal];
        }else if (section==4) {
            [addBtn setTitle:@"添加成品图" forState:UIControlStateNormal];
        }else{
            [view setHidden:YES];
        }
        
        return view;
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        //工艺
        static NSString *identifierstring = @"PublishedCell";
        PublishedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
        if (cell == nil) {
            cell = [[PublishedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierstring];
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.sectionZeroImgArr objectAtIndex:indexPath.row]objectForKey:@"name"]];
        [cell.textLabel setTextColor:TEXTCOLOR51];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[self.sectionZeroImgArr objectAtIndex:indexPath.row]objectForKey:@"img"]]];
        NSString *detaileStr=[self.processShowArr objectAtIndex:indexPath.row];
        if (detaileStr==nil||[detaileStr isEqualToString:@""]) {
            cell.detailTextLabel.text = @"请选择";
        }else
        {
            cell.detailTextLabel.text = detaileStr;
        }
        cell.detailTextLabel.textColor=TEXTCOLOR;
        return cell;
#pragma mark 主料
    }else if (indexPath.section==1)
    {
        if (self.mainArr.count>0) {
            static NSString *identifierstring = @"MainMaterialTableViewCell";
            MaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
            if (cell == nil) {
                cell = [[MaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierstring];
                
            }
            NSDictionary *dic= [self.mainArr objectAtIndex:indexPath.row];
            cell.txtname.text=[dic objectForKey:@"i_name"];
            cell.txtDosage.text=[dic objectForKey:@"i_use"];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, BXScreenW);
            BXWeakSelf(cell);
            cell.deleteAction=^(UITableViewCell *cell){
                [self.mainArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView reloadData];
            };
            cell.addNameBlock =^(NSString *name){
                NSDictionary *dic = [self.mainArr objectAtIndex:indexPath.row];
                NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]init];
                [mainDic setValue:name forKey:@"i_name"];
                [mainDic setValue:[dic objectForKey:@"i_use"] forKey:@"i_use"];
                [self.mainArr replaceObjectAtIndex:indexPath.row withObject:mainDic];
            };
            cell.addUseBlock = ^(NSString *name) {
                NSDictionary *dic = [self.mainArr objectAtIndex:indexPath.row];
                NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]init];
                [mainDic setValue:[dic objectForKey:@"i_name"] forKey:@"i_name"];
                [mainDic setValue:name forKey:@"i_use"];
                [self.mainArr replaceObjectAtIndex:indexPath.row withObject:mainDic];
            };
            return cell;
        }
#pragma mark 辅料
    }else if (indexPath.section==2)
    {
        if (self.supplementaryArr.count>0) {
            static NSString *identifierstring = @"SupplementaryMaterialTableViewCell";
            MaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
            if (cell == nil) {
                cell = [[MaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierstring];
            }
            NSDictionary *dic= [self.supplementaryArr objectAtIndex:indexPath.row];
            cell.txtname.text=[dic objectForKey:@"i_name"];
            cell.txtDosage.text=[dic objectForKey:@"i_use"];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, BXScreenW);
            BXWeakSelf(cell);
            cell.deleteAction=^(UITableViewCell *cell){
                [self.supplementaryArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView reloadData];
            };
            cell.addNameBlock =^(NSString *name){
                NSDictionary *dic = [self.supplementaryArr objectAtIndex:indexPath.row];
                NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]init];
                [mainDic setValue:name forKey:@"i_name"];
                [mainDic setValue:[dic objectForKey:@"i_use"] forKey:@"i_use"];
                [self.supplementaryArr replaceObjectAtIndex:indexPath.row withObject:mainDic];
            };
            cell.addUseBlock = ^(NSString *name) {
                NSDictionary *dic = [self.supplementaryArr objectAtIndex:indexPath.row];
                NSMutableDictionary *mainDic=[[NSMutableDictionary alloc]init];
                [mainDic setValue:[dic objectForKey:@"i_name"] forKey:@"i_name"];
                [mainDic setValue:name forKey:@"i_use"];
                [self.supplementaryArr replaceObjectAtIndex:indexPath.row withObject:mainDic];
            };
            return cell;
        }
#pragma mark 步骤
    }else if (indexPath.section==3)
    {
        if (self.stepArr.count>0) {
            static NSString *identifierstring = @"Step";
            StepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
            if (cell == nil) {
                cell = [[StepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierstring];
            }
            [cell initData];
            [cell setTitle:indexPath.row+1 detail:[[self.stepArr objectAtIndex:indexPath.row]objectForKey:@"step_detail"] time:[[self.stepArr objectAtIndex:indexPath.row]objectForKey:@"step_time"] material:[[self.stepArr objectAtIndex:indexPath.row]objectForKey:@"step_material"]];
            NSData *data=[[self.stepArr objectAtIndex:indexPath.row]objectForKey:@"cook_step_pic"];
            if (data) {
                UIImage *image= [[UIImage alloc] initWithData:data];
                [cell.image setImage:image];
            }
            BXWeakSelf(cell);
            cell.deleteAction=^(UITableViewCell *cell){
                [self.stepArr removeObjectAtIndex:indexPath.row];
                [weakcell initData];
                [self.tableView reloadData];
            };
            cell.stepImgAcion=^(void){
                self.stepImgIndex=indexPath.row;
                self.IMGTYPE=STEPIMG;
                NSLog(@"添加步骤图片");
                [self showWithPreview];
                //                [self directGoPhotoViewController:indexPath.row];
                
            };
            cell.stepDetailBolck = ^(NSString *str) {
                NSMutableDictionary *dic=(NSMutableDictionary*)[self.stepArr objectAtIndex:indexPath.row];
                [dic setObject:str forKey:@"step_detail"];
                [self.stepArr replaceObjectAtIndex:indexPath.row withObject:dic];
            };
            cell.stepTimeBolck = ^{
                NSMutableArray *hourArr=[NSMutableArray array];
                NSMutableArray *minArr=[NSMutableArray array];
                NSMutableArray *secondArr=[NSMutableArray array];
                for (int i=0; i<24; i++) {
                    [hourArr addObject:[NSString stringWithFormat:@"%d时",i]];
                }
                for (int i=0; i<60; i++) {
                    [minArr addObject:[NSString stringWithFormat:@"%d分",i]];
                    [secondArr addObject:[NSString stringWithFormat:@"%d秒",i]];
                }
                [BRStringPickerView showStringPickerWithTitle:@"" dataSource:@[hourArr,minArr,secondArr] defaultSelValue:@"" isAutoSelect:NO themeColor:nil resultBlock:^(id selectValue) {
                    NSArray *arr=selectValue;
                    [weakcell.stepTimeBtn setTitle:[NSString stringWithFormat:@"%@%@%@",[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2]] forState:UIControlStateNormal];
                    NSMutableDictionary *dic=(NSMutableDictionary*)[self.stepArr objectAtIndex:indexPath.row];
                    [dic setObject:weakcell.stepTimeBtn.titleLabel.text forKey:@"step_time"];
                    [self.stepArr replaceObjectAtIndex:indexPath.row withObject:dic];
                }];
            };
            cell.stepUseNumBolck = ^{
                NSMutableArray *step_use=[NSMutableArray array];
                if (self.mainArr.count>0) {
                    if ([[[self.mainArr objectAtIndex:0]objectForKey:@"i_name"] isEqualToString:@""]) {
                        return ;
                    }
                    for (int i=0; i<self.mainArr.count; i++) {
                        NSString *name=[[self.mainArr objectAtIndex:i]objectForKey:@"i_name"];
                        if (![name isEqualToString:@""]) {
                            [step_use addObject:name];
                            
                        }
                        
                    }
                }
                [CDCSheetService shared].dataArr=step_use;
                [CDCSheetService shared].shareBtnClickBlock = ^(NSIndexPath *index) {
                    [weakcell.stepUseNumBtn setTitle:[step_use objectAtIndex:index.item] forState:UIControlStateNormal];
                    NSMutableDictionary *dic=(NSMutableDictionary*)[self.stepArr objectAtIndex:indexPath.row];
                    [dic setObject:weakcell.stepUseNumBtn.titleLabel.text forKey:@"step_material"];
                    [self.stepArr replaceObjectAtIndex:indexPath.row withObject:dic];
                };
                [[CDCSheetService shared] showInViewController:self];
            };
            return cell;
        }
#pragma mark 成品图
    }else if (indexPath.section==4)
    {
        if (self.imgArr.count>0) {
            static NSString *identifierstring = @"FootImgTableViewCell";
            FootImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
            if (cell == nil) {
                cell = [[FootImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierstring];
            }
            [cell setTitle:indexPath.row+1];
            NSData *data=[self.imgArr objectAtIndex:indexPath.row];
            if (data) {
                UIImage *image= [[UIImage alloc] initWithData:data];
                [cell.image setImage:image];
            }
            BXWeakSelf(cell);
            cell.deleteAction=^(UITableViewCell* cell){
                [self.imgArr removeObjectAtIndex:indexPath.row];
                [weakcell initData];
                [self.tableView reloadData];
            };
            cell.foodImgAction=^(void){
                self.finishFoodImgIndex=indexPath.row;
                self.IMGTYPE=FOODIMG;
                NSLog(@"添加成品图图片");
                [self showWithPreview];
                
                //                [self directGoPhotoViewController:indexPath.row];
                
            };
            return cell;
        }
    }
    else if (indexPath.section==5)
    {
        static NSString *identifierstring = @"TipsTableViewCell";
        TipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
        if (cell == nil) {
            cell = [[TipsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierstring];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        if(![self.tipStr isEqualToString:@""]||self.tipStr!=nil){
            cell.txtView.text=self.tipStr;
        }
        cell.textStrBlock = ^(NSString *textStr) {
            self.tipStr=textStr;
        };
        //        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LABELARR"] isEqual:[NSArray class]]) {
        NSArray *labelArr= [[NSUserDefaults standardUserDefaults]objectForKey:@"LABELARR"];
        if (labelArr!=nil&&labelArr.count>0) {
            [cell setLabelStr:labelArr];
        }
        //        }
        cell.chooseCategoryBlock=^(){
            NSLog(@"chooseCategoryBlock");
        };
        return cell;
    }
    else{
        static NSString *identifierstring = @"AddTableViewCell";
        AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierstring];
        if (cell == nil) {
            cell = [[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierstring];
        }
        cell.addBtnAction = ^(NSString *identifier){
            NSLog(@"添加%@",identifier);
        };
        return cell;
    }
    return nil;
}
-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
    if (oldPath.section==newPath.section) {
        // NSString *title = [[self.categoryList objectAtIndex:oldPath.row] retain];
        NSString *str=[self.array objectAtIndex:oldPath.row];
        [self.array removeObjectAtIndex:oldPath.row];
        [self.array insertObject:str atIndex:newPath.row];
        
        
        [self.tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *arr=[NSMutableArray array];
        NSMutableArray *arr1=[NSMutableArray array];
        [arr1 removeAllObjects];
        [arr removeAllObjects];
        if(indexPath.row==0){
            for (int i=0; i<self.processArr.count; i++) {
                [arr addObject:[[self.processArr objectAtIndex:i] objectForKey:@"cp_name"]];
                [arr1 addObject:[[self.processArr objectAtIndex:i] objectForKey:@"cp_id"]];
            }
            
        }else if (indexPath.row==1)
        {
            for (int i=0; i<self.tasteArr.count; i++) {
                [arr addObject:[[self.tasteArr objectAtIndex:i] objectForKey:@"cta_name"]];
                [arr1 addObject:[[self.tasteArr objectAtIndex:i] objectForKey:@"cta_id"]];
                
            }
        }else if (indexPath.row==2)
        {
            for (int i=0; i<self.timeArr.count; i++) {
                [arr addObject:[[self.timeArr objectAtIndex:i] objectForKey:@"cct_name"]];
                [arr1 addObject:[[self.timeArr objectAtIndex:i] objectForKey:@"cct_id"]];
                
            }
        }else if (indexPath.row==3)
        {
            for (int i=0; i<self.quantityArr.count; i++) {
                [arr addObject:[[self.quantityArr objectAtIndex:i] objectForKey:@"cn_name"]];
                [arr1 addObject:[[self.quantityArr objectAtIndex:i] objectForKey:@"cn_id"]];
            }
        }else if (indexPath.row==4)
        {
            for (int i=0; i<self.difficultyArr.count; i++) {
                [arr addObject:[[self.difficultyArr objectAtIndex:i] objectForKey:@"cde_name"]];
                [arr1 addObject:[[self.difficultyArr objectAtIndex:i] objectForKey:@"cde_id"]];
            }
        }
        [CDCSheetService shared].dataArr=arr;
        @weakify(self)
        [CDCSheetService shared].shareBtnClickBlock = ^(NSIndexPath *index) {
            @strongify(self)
            [self.processShowArr replaceObjectAtIndex:indexPath.row withObject:[arr objectAtIndex:index.row]];
            [self.processShowIdArr replaceObjectAtIndex:indexPath.row withObject:[arr1 objectAtIndex:index.row]];
            [self.tableView reloadData];
        };
        [[CDCSheetService shared] showInViewController:self];
    }
}
//去掉UItableview的section的headerview、footView黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_keyBoardlsVisible) {
        //        [self.view endEditing:YES];
    }
}
#pragma mark -- 封面图
-(void)coverImgGesture:(UITapGestureRecognizer *)gesture{
    self.IMGTYPE=COVERIMG;
    NSLog(@"添加封面图");
    [self showWithPreview];
    //    [self directGoPhotoViewController:0];
}
#pragma mark - Button Action
-(BOOL)dataCheck
{
    return NO;
}
-(void)testData{
    _recipeNameStr=@"胡萝卜炒莴笋叶";
    self.titleTxtFiled.text=_recipeNameStr;
    self.cover=[UIImage imageNamed:@"fengmiantu"];
    _storyStr=@"胡萝卜炒莴笋叶背后的故事！胡萝卜炒莴笋叶背后的故事！胡萝卜炒莴笋叶背后的故事！胡萝卜炒莴笋叶背后的故事！胡萝卜炒莴笋叶背后的故事！胡萝卜炒莴笋叶背后的故事！";
    self.storyView.text=_storyStr;
    NSArray *proId=@[@"2",@"7",@"3",@"2",@"2"];
    for (int i=0; i<proId.count; i++) {
        [self.processShowIdArr replaceObjectAtIndex:i withObject:[proId objectAtIndex:i]];
    }
    [self.mainArr removeAllObjects];
    NSMutableDictionary *mainDic1=[NSMutableDictionary dictionary];
    [mainDic1 setValue:@"胡萝卜" forKey:@"i_name"];
    [mainDic1 setValue:@"100克" forKey:@"i_use"];
    [self.mainArr addObject:mainDic1];
    NSMutableDictionary *mainDic2=[NSMutableDictionary dictionary];
    [mainDic2 setValue:@"莴笋叶" forKey:@"i_name"];
    [mainDic2 setValue:@"100克" forKey:@"i_use"];
    [self.mainArr addObject:mainDic2];
    
    NSMutableDictionary *supplementDic=[NSMutableDictionary dictionary];
    [supplementDic setValue:@"盐" forKey:@"i_name"];
    [supplementDic setValue:@"适量" forKey:@"i_use"];
    [self.supplementaryArr replaceObjectAtIndex:0 withObject:supplementDic];
    
    [self.stepArr removeAllObjects];
    NSMutableDictionary *stepDic1=[NSMutableDictionary dictionary];
    [stepDic1 setValue:@"根据人数准备好适量的食材。" forKey:@"step_detail"];
    [stepDic1 setValue:UIImagePNGRepresentation([UIImage imageNamed:@"step1"]) forKey:@"cook_step_pic"];
    [stepDic1 setValue:@"" forKey:@"step_time"];
    [stepDic1 setValue:@"" forKey:@"step_material"];
    [self.stepArr addObject:stepDic1];
    NSMutableDictionary *stepDic2=[NSMutableDictionary dictionary];
    [stepDic2 setValue:@"切好。" forKey:@"step_detail"];
    [stepDic2 setValue:UIImagePNGRepresentation([UIImage imageNamed:@"step2"]) forKey:@"cook_step_pic"];
    [stepDic2 setValue:@"" forKey:@"step_time"];
    [stepDic2 setValue:@"" forKey:@"step_material"];
    [self.stepArr addObject:stepDic2];
    NSMutableDictionary *stepDic3=[NSMutableDictionary dictionary];
    [stepDic3 setValue:@"胡萝卜和莴笋叶焯水，之后捞起备用。" forKey:@"step_detail"];
    [stepDic3 setValue:UIImagePNGRepresentation([UIImage imageNamed:@"published_step"]) forKey:@"cook_step_pic"];
    [stepDic3 setValue:@"" forKey:@"step_time"];
    [stepDic3 setValue:@"" forKey:@"step_material"];
    [self.stepArr addObject:stepDic3];
    NSMutableDictionary *stepDic4=[NSMutableDictionary dictionary];
    [stepDic4 setValue:@"1汤匙油翻炒胡萝卜和莴笋叶，加入适量盐，\n\n拌匀就可以起锅了 。" forKey:@"step_detail"];
    [stepDic4 setValue:UIImagePNGRepresentation([UIImage imageNamed:@"step4"]) forKey:@"cook_step_pic"];
    [stepDic4 setValue:@"" forKey:@"step_time"];
    [stepDic4 setValue:@"" forKey:@"step_material"];
    [self.stepArr addObject:stepDic4];
    
    
    [self.imgArr removeAllObjects];
    NSData *imgData1=UIImagePNGRepresentation([UIImage imageNamed:@"chengp1"]);
    [self.imgArr addObject:imgData1];
    NSData *imgData2=UIImagePNGRepresentation([UIImage imageNamed:@"chengp2"]);
    [self.imgArr addObject:imgData2];
    
    self.tipStr=@"技巧技巧技巧技巧技巧\n2技巧技巧技巧技巧技巧";
}
-(NSDictionary *)setUploadDataDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.titleTxtFiled.text forKey:@"cook_name"];
    [dic setValue:[self base64Str:self.cover] forKey:@"cook_logo"];
    [dic setValue:self.storyView.text forKey:@"cook_logo_describe"];
    NSArray *arr=@[@"cp_id",@"cta_id",@"cct_id",@"cn_id",@"cde_id"];
    for (int i=0; i<5; i++) {
        [dic setValue:[self.processShowIdArr objectAtIndex:i] forKey:[arr objectAtIndex:i]];
    }
    [dic setValue:self.mainArr forKey:@"main_ingredient"];
    [dic setValue:self.supplementaryArr forKey:@"accessories"];
    NSMutableArray *dataStepArr=[NSMutableArray array];
    for (int i=0; i<self.stepArr.count; i++) {
        NSDictionary *dic= [self.stepArr objectAtIndex:i];
        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
        [dicM setDictionary:dic];
        NSData *data=[dic objectForKey:@"cook_step_pic"];
        UIImage *initimage=[UIImage imageNamed:@"published_step"];
        NSData *imageData = UIImagePNGRepresentation(initimage);
        if ([data isEqual:imageData]) {
            [dicM setValue:@"" forKey:@"cook_step_pic"];
        }else{
            UIImage *image= [[UIImage alloc] initWithData:data];
            [dicM setValue:[self base64Str:image] forKey:@"cook_step_pic"];
        }
        [dataStepArr addObject:dicM];
        //        [self.stepArr replaceObjectAtIndex:i withObject:dicM];
    }
    [dic setValue:dataStepArr forKey:@"cook_step"];
    NSMutableArray *imgArr1=[NSMutableArray array];
    for (int i=0; i<self.imgArr.count; i++) {
        NSData *data= [self.imgArr objectAtIndex:i];
        UIImage *initimage=[UIImage imageNamed:@"published_step"];
        NSData *imageData = UIImagePNGRepresentation(initimage);
        if ([data isEqual:imageData]) {
            [imgArr1 addObject:@""];
            
        }else
        {
            UIImage *image= [[UIImage alloc] initWithData:data];
            [imgArr1 addObject:[self base64Str:image]];
        }
    }
    
    [dic setValue:imgArr1 forKey:@"cook_product_pic"];
    [dic setValue:self.tipStr forKey:@"cook_jiqiao"];
    
    NSArray*labelArr= [[NSUserDefaults standardUserDefaults]objectForKey:@"LABELARR"];
    NSMutableArray *labarr=[NSMutableArray array];
    for (int i=0; i<labelArr.count; i++) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:[[labelArr objectAtIndex:i]objectForKey:@"ct_pid"] forKey:@"ct_pid"];
        [dic setValue:[[labelArr objectAtIndex:i]objectForKey:@"ct_id"] forKey:@"ct_id"];
        [labarr addObject:dic];
    }
    [dic setValue:labarr forKey:@"cook_label"];
    NSLog(@"%@",dic);
    
    return [dic copy];
}
-(void)backAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goSuccecc
{
  
}
-(void)previewBtnAction:(id)sender
{
 
}
-(void)publicBtnAction:(id)sender
{
 
    
}
-(NSString*)base64Str:(UIImage*)image{
    NSData * imgData = UIImageJPEGRepresentation(image, 0.3);
    NSLog(@"%ld",imgData.length);
    NSString *str=[self base64Encoding:imgData];
    return str;
}
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";//设置编码
-(NSString *)base64Encoding:(NSData*)_data
{//调用base64的方法,返回的对象需要release
    
    if ([_data length] == 0)
        return @"";
    
    char *characters = malloc((([_data length] + 2) / 3) * 4);
    
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [_data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [_data length])
            buffer[bufferLength++] = ((char *)[_data bytes])[i++];
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] ;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.storyView]) {
        self.storyStr=textView.text;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.titleTxtFiled]) {
        self.recipeNameStr=textField.text;
    }
}
#pragma mark 图片选择
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.configuration.sortAscending = NO;
    actionSheet.configuration.allowSelectImage = YES;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowSelectLivePhoto = NO;
    //    actionSheet.configuration.allowForceTouch = self.allowForceTouchSwitch.isOn;
    //    actionSheet.configuration.allowEditImage = self.allowEditSwitch.isOn;
    //    actionSheet.configuration.allowEditVideo = self.allowEditVideoSwitch.isOn;
    //    actionSheet.configuration.allowSlideSelect = self.allowSlideSelectSwitch.isOn;
    //    actionSheet.configuration.allowMixSelect = self.mixSelectSwitch.isOn;
    //    actionSheet.configuration.allowDragSelect = self.allowDragSelectSwitch.isOn;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount = 20;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount = 1;
    //设置允许选择的视频最大时长
    actionSheet.configuration.maxVideoDuration = 120;
    //设置照片cell弧度
    actionSheet.configuration.cellCornerRadio = 0;
    //单选模式是否显示选择按钮
    //    actionSheet.configuration.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    actionSheet.configuration.editAfterSelectThumbnailImage = YES;
    //是否保存编辑后的图片
    actionSheet.configuration.saveNewImageAfterEdit = NO;
    //设置编辑比例
    //    actionSheet.configuration.clipRatios = @[GetClipRatio(7, 1)];
    //是否在已选择照片上显示遮罩层
    //    actionSheet.configuration.showSelectedMask = self.maskSwitch.isOn;
    //颜色，状态栏样式
    actionSheet.configuration.selectedMaskColor = [UIColor purpleColor];
    actionSheet.configuration.navBarColor = RGB(205, 30, 30);
    actionSheet.configuration.navTitleColor = [UIColor whiteColor];
    actionSheet.configuration.bottomBtnsNormalTitleColor =RGB(203, 30, 30);
    actionSheet.configuration.bottomBtnsDisableBgColor = RGB(203, 30, 30);
    actionSheet.configuration.bottomViewBgColor = RGB(205, 30, 30);
    actionSheet.configuration.statusBarStyle = UIStatusBarStyleDefault;
    //裁剪比例
    actionSheet.configuration.clipRatios=@[GetClipRatio(4, 3)];
    //是否允许框架解析图片
    //    actionSheet.configuration.shouldAnialysisAsset = self.allowAnialysisAssetSwitch.isOn;
    //框架语言
    //    actionSheet.configuration.languageType = self.languageSegment.selectedSegmentIndex;
    //自定义多语言
    //    actionSheet.configuration.customLanguageKeyValue = @{@"ZLPhotoBrowserCameraText": @"没错，我就是一个相机"};
    
    //是否使用系统相机
    actionSheet.configuration.useSystemCamera = YES;
    actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
    actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
    actionSheet.configuration.allowRecordVideo = NO;
    
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    //记录上次选择的图片
    //    actionSheet.arrSelectedAssets =
    
    @weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @strongify(self)
        NSLog(@"%@",images);
        if (images.count>0) {
            if (self.IMGTYPE==STEPIMG) {
                NSData *imageData = UIImagePNGRepresentation(images.firstObject);
                NSMutableDictionary *dic=(NSMutableDictionary*)[self.stepArr objectAtIndex:self.stepImgIndex];
                [dic setObject:imageData forKey:@"cook_step_pic"];
                [self.stepArr replaceObjectAtIndex:self.stepImgIndex withObject:dic];
            }else if (self.IMGTYPE==FOODIMG)
            {
                NSData *imageData = UIImagePNGRepresentation(images.firstObject);
                [self.imgArr replaceObjectAtIndex:self.finishFoodImgIndex withObject:imageData];
                
            }else
            {
                self.cover=images.firstObject;
            }
            [self.tableView reloadData];
        }
        
    }];
    
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    
    return actionSheet;
}
- (void)showWithPreview
{
    ZLPhotoActionSheet *a = [self getPas];
    [a showPhotoLibrary];
    
}


@end
