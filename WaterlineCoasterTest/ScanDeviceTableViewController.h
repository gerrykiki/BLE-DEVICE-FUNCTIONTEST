//
//  ScanDeviceTableViewController.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 19/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothObject.h"

@interface ScanDeviceTableViewController : UITableViewController

@property (strong, nonatomic) BlueToothObject *bluetoothobject;
@property (strong, nonatomic) NSMutableArray *itemarray;

@end
