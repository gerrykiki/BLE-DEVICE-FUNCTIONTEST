//
//  WWLTermainalViewController.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 14/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalCollectionViewCell.h"
#import "BlueToothObject.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface WWLTermainalViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
}

@property (strong ,nonatomic) NSString *State;
@property (strong ,nonatomic) NSString *ConnectName;

@property (strong ,nonatomic) UITextView *RawDataTerminal;
@property (strong ,nonatomic) UITextView *OutDataTermainal;

@property (strong ,nonatomic) NSMutableArray *cellitemarray;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UITextView *RowDataTerminal;
@property (strong, nonatomic) IBOutlet UITextView *AnalysisDataTerminal;


@property (strong, nonatomic) BlueToothObject *bluetoothobject;
@end
