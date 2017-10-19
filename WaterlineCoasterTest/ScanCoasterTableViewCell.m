//
//  ScanCoasterTableViewCell.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 19/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "ScanCoasterTableViewCell.h"

@implementation ScanCoasterTableViewCell

+ (ScanCoasterTableViewCell *)cell
{
    NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"ScanCoasterTableViewCell" owner:nil options:nil];
    return items.lastObject;
}

- (void) EditCellString:(NSDictionary *)deviceinfo{
    NSLog(@"%@",deviceinfo);
    _DeviceName.text = [deviceinfo objectForKey:@"devicename"];
    _DeviceIdentifier.text = [deviceinfo objectForKey:@"deviceidentifier"];
    _DeviceIdentifier.adjustsFontSizeToFitWidth = YES;
    _DeviceRSSI.text = [[deviceinfo objectForKey:@"DevcieRSSI"] stringValue];
}

@end
