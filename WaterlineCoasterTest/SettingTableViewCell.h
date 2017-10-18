//
//  SettingTableViewCell.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 16/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *KeyTitle;
@property (strong, nonatomic) IBOutlet UILabel *BtnName;
@property (strong, nonatomic) IBOutlet UILabel *CommandName;
@property (strong, nonatomic) IBOutlet UITextField *BtnField;
@property (strong, nonatomic) IBOutlet UITextField *CommandField;
@property (strong, nonatomic) IBOutlet UIButton *BtnSave;


+ (SettingTableViewCell *)cell;
- (void) EditSize:(NSInteger)CellRaw;
- (void) EditKeyTitle:(NSString *)TitleNumber;
- (void) Editplaceholder:(NSString *)placeholdertext;

@end
