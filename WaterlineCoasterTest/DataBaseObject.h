//
//  DataBaseObject.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 18/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseObject : NSObject

@property (strong, nonatomic) NSString *database_filepath;

+ (DataBaseObject *)sharedInstance;
-(BOOL) createDatabase:(NSString *)databaseName;
- (int) addcommandName : (NSString *)commandid;
- (int) UpdateTheCommandName : (NSString *)commandname keynumber : (NSString *)commandid;

@end
