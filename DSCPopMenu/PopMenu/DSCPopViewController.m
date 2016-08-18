//
//  DSCPopViewController.m
//  DSCPopMenu
//
//  Created by Shaochong Du on 16/4/13.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "DSCPopViewController.h"
#import "UIView+Addition.h"
#import "DSCPopMenuItem.h"
#import "PopMenuTableViewCell.h"

#define kCELLHEIGHT 35  //  cell 高度
#define kCELLWIDTH  120  //  menu 宽度
#define WEAKSELF typeof(self) __weak weakSelf = self;
@interface DSCPopViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UIView *showFromView;   //  记录点击视图
    
    UIImageView *dialogImgView;
    UITableView *myTableView;
}

@end

@implementation DSCPopViewController

-(instancetype)init
{
    if (self = [super init]) {
        showFromView = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *color = [UIColor blackColor];
    self.view.backgroundColor = [color colorWithAlphaComponent:0.25];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
    tap.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    [self addImageView];
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - show
- (void)showMenu
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect viewFrame = self.view.frame;
    viewFrame = window.frame;
    viewFrame.origin = CGPointMake(0, 0);
    self.view.frame = viewFrame;
    [window addSubview:self.view];
}

-(void)setClikedObject:(id)clikedObject
{
    UIView *view;
    if ([clikedObject isKindOfClass:[UIView class]]) {
        view = (UIView *)clikedObject;
        showFromView = view;
    } else {
        NSLog(@"非view子类");
        return;
    }
}

#pragma mark - gesture
- (void)cancelAction
{
    __weak DSCPopViewController *weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        dialogImgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        dialogImgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
    }];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - UITapGestureRecognizer
//  为了解决cell不能响应点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //如果当前是tableView
        return NO;
    }
    
    return YES;
}

#pragma mark - load view
- (void)addImageView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //  默认使用self.view转换坐标
    CGRect rect = [self.view convertRect:showFromView.frame toView:nil];
    if (self.objectParentView) {
        rect = [self.objectParentView convertRect:showFromView.frame toView:nil];
    }
    NSLog(@"%@",NSStringFromCGRect(rect));

    
    CGFloat imgX = showFromView.right - kCELLWIDTH;
    if (showFromView.width - kCELLWIDTH > 0) {
        imgX = (showFromView.width - kCELLWIDTH)/2.0 + showFromView.left;
    }
    CGFloat imgY = showFromView.height + rect.origin.y;
    CGFloat height = self.dataSourceArray.count * kCELLHEIGHT > window.height/2.0 ? window.height/2.0 : self.dataSourceArray.count * kCELLHEIGHT;
    dialogImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, kCELLWIDTH, height)];
    dialogImgView.userInteractionEnabled = YES;
    [self.view addSubview:dialogImgView];
    
    [self setImgView];
    
    dialogImgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    dialogImgView.alpha = 0;
    [UIView animateWithDuration:.15 animations:^{
        dialogImgView.alpha = 1;
        dialogImgView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

//  设置背景图片
- (void)setImgView
{
    UIImage *image;
    UIEdgeInsets insets;
    if (self.menuType == MenuTypeArrowRight) {
        image = [UIImage imageNamed:@"dialogueTopRight"];
        /*  该图片尺寸为343*106
         **  1、凸起部分左侧距离图片右侧边缘大概为22，因此UIEdgeInsets中left和right值>= 22即可.(此值若不合适继续调大)
         **  2、凸起部分底部图片高度（除去凸起高度）大概为98，因此UIEdgeInsets中top和bottom值<= 49即可.(此值若不合适继续调小)
         */
        insets = UIEdgeInsetsMake(40, 22, 40, 22);
    } else if (self.menuType == MenuTypeArrowCenter) {
        image = [UIImage imageNamed:@"dialogueTopCenter"];
        /*  该图片尺寸为343*106
         **  1、凸起部分左侧距离图片右侧边缘大概为171.5，因此UIEdgeInsets中left和right值>= 171.5即可.(此值若不合适继续调大)
         **  2、凸起部分底部图片高度（除去凸起高度）大概为98，因此UIEdgeInsets中top和bottom值<= 49即可.(此值若不合适继续调小)
         */
        insets = UIEdgeInsetsMake(40, 171.5, 40, 171.5);
    } else {
        image = [UIImage imageNamed:@"dialogueTopLeft"];
        /*  该图片尺寸为343*106
         **  1、凸起部分右侧距离图片左侧边缘大概为27，因此UIEdgeInsets中left和right值>= 27即可.(此值若不合适继续调大)
         **  2、凸起部分底部图片高度（除去凸起高度）大概为98，因此UIEdgeInsets中top和bottom值<= 49即可.(此值若不合适继续调小)
         */
        insets = UIEdgeInsetsMake(40, 27, 40, 27);
    }
    
    UIImage *insetImage = [image resizableImageWithCapInsets:insets];
    dialogImgView.image = insetImage;
}

- (void)addTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    //  10为底图中箭头的高度
    CGFloat arrowHeight = 5;
    myTableView.frame = CGRectMake(0, arrowHeight, dialogImgView.width, dialogImgView.height - arrowHeight);
    //  圆角尽量跟背景图保持一致
    myTableView.layer.masksToBounds = YES;
    myTableView.layer.cornerRadius = 3.0;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.rowHeight = kCELLHEIGHT;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [dialogImgView addSubview:myTableView];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    PopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PopMenuTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    DSCPopMenuItem *menuItem = self.dataSourceArray[indexPath.row];
    cell.leftImgView.image = [UIImage imageNamed:menuItem.menuIcon];
    cell.menuTitleLabel.text = menuItem.menuName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
    [self cancelAction];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
