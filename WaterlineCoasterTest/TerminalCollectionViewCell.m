//
//  TerminalCollectionViewCell.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 15/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "TerminalCollectionViewCell.h"

@implementation TerminalCollectionViewCell

- (void)cellSetUpData:(NSString *)CellData
{
    NSLog(@"%@",CellData);
    
    self.CellTitle.text = CellData;
    //self.CellTitle.adjustsFontSizeToFitWidth = YES;
}

@end
