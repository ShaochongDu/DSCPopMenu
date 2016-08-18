//
//  ViewController.m
//  DSCPopMenu
//
//  Created by Shaochong Du on 16/4/13.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ViewController.h"
#import "DSCPopViewController.h"
#import "DSCPopMenuItem.h"

@interface ViewController ()
@property (nonatomic , strong) DSCPopViewController *popVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"pop view" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barBtn1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  显示弹出视图
//  普通视图
- (IBAction)popMenu:(id)sender
{
    [self showPopMenu:sender superView:self.view];
}

//  navigationbar上的视图
- (void)rightBtnAction:(UIButton *)sender
{
    [self showPopMenu:sender superView:self.navigationController.navigationBar];
}

//  显示弹出视图
- (void)showPopMenu:(id)clickObject superView:(UIView *)superView
{
    if (self.popVC) {
        self.popVC = nil;
    }
    self.popVC = [[DSCPopViewController alloc] init];
    //    [[[UIApplication sharedApplication] delegate].window.rootViewController addChildViewController:self.popVC];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        DSCPopMenuItem *menuItem = [[DSCPopMenuItem alloc] init];
        menuItem.menuId = [NSString stringWithFormat:@"%d",i];
        menuItem.menuIcon = [NSString stringWithFormat:@"menuIcon0%d",arc4random()%6 + 1];
        menuItem.menuName = [NSString stringWithFormat:@"菜单 %d",i];
        
        [dataArray addObject:menuItem];
    }
    self.popVC.dataSourceArray = dataArray;
    self.popVC.clikedObject = clickObject;
    self.popVC.objectParentView = superView;
    self.popVC.menuType = MenuTypeArrowRight;
    [self.popVC showMenu];
    
    self.popVC.selectBlock = ^(NSIndexPath *indexPath) {
        NSLog(@"indexPath->%@",indexPath);
    };
    __weak ViewController *weakSelf = self;
    self.popVC.cancelBlock = ^() {
        NSLog(@"%@",weakSelf.popVC);
    };
}






@end
