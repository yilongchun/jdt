//
//  DBUtil.m
//  jdt
//
//  Created by Stephen Chin on 17/2/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "DBUtil.h"
#import "FMDB.h"

@implementation DBUtil

+(NSString *)getPath{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSError *createDicError;
//    
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir = YES;
//    BOOL isDirExist  = [fileManager fileExistsAtPath:[docsPath stringByAppendingString:@"/database"] isDirectory:&isDir];
//    if (!isDirExist) {
//        BOOL createDirectoryFlag = [[NSFileManager defaultManager] createDirectoryAtPath:[docsPath stringByAppendingString:@"/database"]
//                                                             withIntermediateDirectories:NO
//                                                                              attributes:nil
//                                                                                   error:&createDicError];
//        if (createDirectoryFlag) {
//            NSLog(@"createDirectory success");
//        }else{
//            NSLog(@"createDirectory filed:%@",createDicError);
//        }
//    }else{
//        NSLog(@"database is exist");
//    }
    
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"/jdt.db"];
    return dbPath;
}

+(void)createTableIfNotExists{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if ([db open]) {
        NSString *existsSql = [NSString stringWithFormat:@"select count(*) as countNum from sqlite_master where type = 'table' and name = '%@'", @"jdt" ];
        FMResultSet *rs = [db executeQuery:existsSql];
        
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            NSLog(@"The table count: %li", count);
            if (count == 1) {
                NSLog(@"table jdt 存在");
                
            }else{
                NSLog(@"table jdt 不存在");
                
                NSString *sqlCreateTable =  @"create table if not exists jdt (id INTEGER PRIMARY KEY AUTOINCREMENT,userid text, name text, code text, phone text, address text,no text,pic1 text,pic2 text,state integer)";
                BOOL res = [db executeUpdate:sqlCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"success to creating db table");
                }
            }
        }
        [rs close];
        [db close];
    }

}

+(NSNumber *)queryCount:(NSString *)userid{
    NSNumber *num = [NSNumber numberWithInteger:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if ([db open]) {
        NSString *existsSql = [NSString stringWithFormat:@"select count(*) as count from jdt where userid = '%@'", userid ];
        FMResultSet *rs = [db executeQuery:existsSql];
        
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];
            NSLog(@"The table count: %li", count);
            num = [NSNumber numberWithInteger:count];
        }
        [rs close];
        [db close];
    }
    return num;
}

+(BOOL)insertData:(NSDictionary *)param{
    
    BOOL flag;
    [self createTableIfNotExists];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if ([db open]) {
        [db beginTransaction];
        //state 1正常 2提交失败
        flag = [db executeUpdate:@"insert into jdt (userid,name,code,phone,address,no,pic1,pic2,state) values (?,?,?,?,?,?,?,?,?)" ,
                     [param objectForKey:@"userid"],[param objectForKey:@"name"],[param objectForKey:@"code"],[param objectForKey:@"phone"],[param objectForKey:@"address"],[param objectForKey:@"no"],[param objectForKey:@"pic1"],[param objectForKey:@"pic2"],[NSNumber numberWithInt:1]];
        if (flag) {
            NSLog(@"insert to jdt success");
        }else{
            NSLog(@"insert to jdt error");
        }
        
        [db commit];
        [db close];
    }
    return flag;
}

+(BOOL)deleteData:(NSDictionary *)param{
    
    BOOL flag;
    DLog(@"delete data id:%d",[[param objectForKey:@"id"] intValue]);
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if ([db open]) {
        [db beginTransaction];
        int ids = [[param objectForKey:@"id"] intValue];
        NSString *sql = [NSString stringWithFormat:@"delete from jdt where id = %d", ids];
        flag = [db executeUpdate:sql];
        if (flag) {
            NSLog(@"delete from jdt success");
        }else{
            NSLog(@"delete from jdt error");
        }
        NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db commit];
        [db close];
    }
    return flag;
}

+(NSArray *)queryData:(NSString *)userid{
    NSMutableArray *arr = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from jdt where userid = '%@'", userid ];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            // just print out what we've got in a number of formats.
            NSLog(@"%d %@ %@ %@ %@ %@ %@ %@ %@ %d",
                  [rs intForColumn:@"id"],
                  [rs stringForColumn:@"userid"],
                  [rs stringForColumn:@"name"],
                  [rs stringForColumn:@"code"],
                  [rs stringForColumn:@"phone"],
                  [rs stringForColumn:@"address"],
                  [rs stringForColumn:@"no"],
                  [rs stringForColumn:@"pic1"],
                  [rs stringForColumn:@"pic2"],
                  [rs intForColumn:@"state"]);
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:[NSNumber numberWithInt:[rs intForColumn:@"id"]] forKey:@"id"];
            [resultDic setObject:[rs stringForColumn:@"userid"] forKey:@"userid"];
            [resultDic setObject:[rs stringForColumn:@"name"] forKey:@"name"];
            [resultDic setObject:[rs stringForColumn:@"code"] forKey:@"code"];
            [resultDic setObject:[rs stringForColumn:@"phone"] forKey:@"phone"];
            [resultDic setObject:[rs stringForColumn:@"address"] forKey:@"address"];
            [resultDic setObject:[rs stringForColumn:@"no"] forKey:@"no"];
            [resultDic setObject:[rs stringForColumn:@"pic1"] forKey:@"pic1"];
            [resultDic setObject:[rs stringForColumn:@"pic2"] forKey:@"pic2"];
            [resultDic setObject:[NSNumber numberWithInt:[rs intForColumn:@"state"]] forKey:@"state"];
            [arr addObject:resultDic];
        }
        [rs close];
        [db close];
    }
    return arr;
    
}


@end
