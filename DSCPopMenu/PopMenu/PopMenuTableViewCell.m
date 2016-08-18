//
//  PopMenuTableViewCell.m
//  DSCPopMenu
//
//  Created by Shaochong Du on 16/4/20.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "PopMenuTableViewCell.h"
#import "UIView+Addition.h"

@implementation PopMenuTableViewCell
{
    UIView *seperateLineView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 0, 0.5)];
    seperateLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:seperateLineView];
    
//    self.contentView.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    seperateLineView.width = self.contentView.width - 10;
    seperateLineView.bottom = self.contentView.bottom - 0.5;
}

@end
