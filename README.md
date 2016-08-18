# DSCPopMenu
弹出视图

![image](https://github.com/ShaochongDu/DSCPopMenu/raw/master/DSCPopMenu/Others/DemoScreenShot.gif)

### 使用方法
```
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
```
