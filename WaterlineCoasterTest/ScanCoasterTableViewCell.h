//
//  ScanCoasterTableViewCell.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 19/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCoasterTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *DeviceName;
@property (strong, nonatomic) IBOutlet UILabel *DeviceIdentifier;
@property (strong, nonatomic) IBOutlet UILabel *DeviceRSSI;


+ (ScanCoasterTableViewCell *)cell;
- (void) EditCellString:(NSDictionary *)deviceinfo;

@end
