//
//  SettingTerminalUITaTableViewController.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 16/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandData.h"

@interface SettingTerminalUITaTableViewController : UITableViewController

@property (strong, nonatomic) UILabel *KeyTitle;
@property (strong, nonatomic) UILabel *BtnName;
@property (strong, nonatomic) UILabel *CommandName;
@property (strong, nonatomic) UITextField *BtnTextField;
@property (strong, nonatomic) UITextField *CommandTextField;

@property (strong, nonatomic) CommandData *commanddata;

@end
