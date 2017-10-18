//
//  SettingTableViewCell.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 16/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell
@synthesize KeyTitle,BtnName,CommandName,BtnField,CommandField,BtnSave;

+ (SettingTableViewCell *)cell
{
    NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:nil options:nil];
    return items.lastObject;
}

- (void) EditSize:(NSInteger)CellRaw{
    if (CellRaw < 6) {
        BtnField.userInteractionEnabled = NO;
        BtnField.borderStyle = UIAccessibilityTraitNone;
    }
    else{
        [BtnField setFrame:CGRectMake(BtnField.frame.origin.x, BtnField.frame.origin.y, [UIScreen mainScreen].bounds.size.width - BtnName.bounds.size.width - 30, BtnField.bounds.size.height)];
        [CommandField setFrame:CGRectMake(CommandField.frame.origin.x, CommandField.frame.origin.y, [UIScreen mainScreen].bounds.size.width - CommandName.bounds.size.width - 30, CommandField.bounds.size.height)];
    }
    
    BtnSave.layer.borderWidth = 1.0f;
    BtnSave.layer.borderColor = [[UIColor grayColor]CGColor];
    BtnSave.layer.masksToBounds = YES;
    BtnSave.layer.cornerRadius = 5.0f;
    BtnSave.tag = CellRaw;
    [BtnSave addTarget:self action:@selector(SateData:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)SateData:(UIButton *)SaveBtn{
    NSLog(@"%ld",(long)SaveBtn.tag);
}

- (void) EditKeyTitle:(NSString *)TitleNumber{
    KeyTitle.text = [NSString stringWithFormat:@"Key %@",TitleNumber];
}

- (void) Editplaceholder:(NSString *)placeholdertext{
    BtnField.text = placeholdertext;
}

@end
