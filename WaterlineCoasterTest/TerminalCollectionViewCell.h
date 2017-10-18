//
//  TerminalCollectionViewCell.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 15/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerminalCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *CellTitle;

- (void)cellSetUpData:(NSString *)CellData;

@end
