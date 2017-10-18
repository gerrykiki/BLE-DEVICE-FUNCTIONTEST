//
//  CommandData.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 17/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommandData : NSObject



+ (instancetype)sharedInstance;
- (NSArray *)DataBaseBtn;
- (NSString *)ReturnTableArray:(int)indexArray;


@end
