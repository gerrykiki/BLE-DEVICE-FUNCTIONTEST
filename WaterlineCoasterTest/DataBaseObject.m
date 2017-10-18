//
//  DataBaseObject.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 18/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "DataBaseObject.h"
static DataBaseObject *sharedInstance = nil;

@implementation DataBaseObject

+ (DataBaseObject *)sharedInstance {
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[DataBaseObject alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

-(BOOL) createDatabase:(NSString *)databaseName{
    NSString *docsDir;
    NSArray *dirPath;
    sqlite3 *db;
    
    // Get the documents directory
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPath objectAtIndex:0];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: databaseName]];
    _database_filepath = databasePath;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &db) == SQLITE_OK) {
            char *errMsg;
            // create SQL statements
            const char *sql = "CREATE TABLE IF NOT EXISTS CommandTable (command_id TEXT PRIMARY KEY, Command_Name TEXT, Command_String TEXT)";
            
            if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog( @"Failed to create table");
                return NO;
            }
            sqlite3_close(db);
            return YES;
        }
        else {
            NSLog( @"Failed to open/create database");
            return NO;
        }
    }else{
        NSLog(@"Database already created.");
        return YES;
    }
}

- (int) addcommandName : (NSString *)commandid{
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([_database_filepath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO CommandTable (command_id) VALUES ('%@')", commandid];
        char * errMsg;
        rc = sqlite3_exec(db, query.UTF8String,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert CommandTable rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    return rc;
}
/*
- (void) UpdateTheCommandName : (NSString *)commandname keynumber : (NSString *)commandid {
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([_database_filepath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *update = [NSString stringWithFormat:@"Update CommandTable Set Command_Name='%@' Where command_id='%@'",commandname,commandid];
        
        if (sqlite3_prepare_v2(db, update, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"prepare update beverage profile failed");
        }
        if (sqlite3_bind_text(stmt, 1, s_id.UTF8String, -1, NULL) != SQLITE_OK) {
            NSLog(@"bind update beverage id failed");
            
        }
        if (sqlite3_bind_text(stmt, 2, local_id.UTF8String, -1, NULL) != SQLITE_OK) {
            NSLog(@"bind where beverage local id failed");
        }
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"update beverage update successed");
        } else {
            NSLog(@"update beverage update failed");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(db);
    }
    
}
*/
- (int) UpdateTheCommandName : (NSString *)commandname keynumber : (NSString *)commandid{
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([_database_filepath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = [NSString stringWithFormat:@"Update CommandTable Set Command_Name='%@' Where command_id='%@'",commandname,commandid];
        char * errMsg;
        rc = sqlite3_exec(db, query.UTF8String,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert CommandTable rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    return rc;
}

@end
