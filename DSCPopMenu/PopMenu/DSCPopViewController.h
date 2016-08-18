//
//  DSCPopViewController.h
//  DSCPopMenu
//
//  Created by Shaochong Du on 16/4/13.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MenuTypeArrow) {
    MenuTypeArrowRight, //  右上角箭头
    MenuTypeArrowCenter,    //  中间箭头
    MenuTypeArrowLeft,  //  左上角箭头
};
/**
 *  完成回调
 *
 *  @param indexPath  当前选择的行索引
 */
typedef void(^DSCPopSelectBlock)(NSIndexPath *indexPath);
typedef void(^DSCPopCancelBlock)();

@interface DSCPopViewController : UIViewController

@property (nonatomic, copy) DSCPopSelectBlock selectBlock;
@property (nonatomic, copy) DSCPopCancelBlock cancelBlock;

@property (nonatomic, assign) MenuTypeArrow menuType;   //
@property (nonatomic, strong) NSMutableArray *dataSourceArray;    //  数据源 DSCPopMenuItem模型
@property (nonatomic, assign) id clikedObject;  //  当前点击的视图，如：UIButton按钮
@property (nonatomic, strong) UIView *objectParentView; //  承载点击视图的父视图，如：navigationController.navigationBar，默认为controller的view，

- (void)showMenu;

@end
