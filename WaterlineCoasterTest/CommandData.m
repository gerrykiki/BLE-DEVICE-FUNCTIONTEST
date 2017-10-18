//
//  CommandData.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 17/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "CommandData.h"
#import "DataBaseObject.h"
static CommandData *sharedInstance = nil;

@implementation CommandData{
    NSMutableArray *TableItemArray;
    NSMutableArray *CommandTableArray;
    NSString *teststring;
}

+ (CommandData *)sharedInstance {
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[CommandData alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        //initialization environment
        CommandTableArray = [[NSMutableArray alloc]init];
        TableItemArray = [[NSMutableArray alloc]init];
        [TableItemArray addObject:@"Get Data"];
        [TableItemArray addObject:@"Battery"];
        [TableItemArray addObject:@"Reset"];
        [TableItemArray addObject:@"Test Weight"];
        [TableItemArray addObject:@"LED Remind"];
        [TableItemArray addObject:@"Setting Pin Code"];
        for (int i=1; i < 15; i++) {
            [[DataBaseObject sharedInstance]addcommandName:[NSString stringWithFormat:@"Btn %d",i]];
        }
        for (int i=1; i <= TableItemArray.count; i++) {
            [[DataBaseObject sharedInstance]UpdateTheCommandName:[TableItemArray objectAtIndex:i-1] keynumber:[NSString stringWithFormat:@"Btn %d",i]];
        }
    }
    return self;
}




- (NSArray *)DataBaseBtn{
    return TableItemArray;
}

- (NSString *)DataCommandBtn{
    return @"41";
}

- (NSString *)ReturnTableArray:(int)indexArray{
    if (TableItemArray.count < indexArray + 1) {
        return @"";
    }
    else return [TableItemArray objectAtIndex:indexArray];
}



@end
