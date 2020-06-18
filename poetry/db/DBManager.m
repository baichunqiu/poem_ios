//
//  DBManager.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@interface DBManager()
@property(nonatomic,copy) NSString* dBPath;
@property(nonatomic,copy) FMDatabase* db;


@end
@implementation DBManager

- (NSString *)dBPath{
    if(!_dBPath){
        //文件类型
        NSString * resPath = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:nil];
        NSLog(@"resPath = %@",resPath);
        // 沙盒Documents目录
        NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [appDir stringByAppendingPathComponent:DB_NAME];
        NSLog(@"filePath = %@",filePath);
        if(![fileManager fileExistsAtPath:filePath]) {//如果不存在
            BOOL flag = [fileManager copyItemAtPath:resPath toPath:filePath error:nil];
            if (flag) {
                _dBPath = filePath;
            }else{
                NSLog(@"文件复制失败！");
            }
        }else{
            _dBPath = filePath;
            NSLog(@"文件已存在！");
        }
    }
    NSLog(@"db_path = %@",_dBPath);
    return _dBPath;
}

-(BOOL)openDatabase{
    if (!_db) {
        _db = [FMDatabase databaseWithPath: self.dBPath];
    }
    return [_db open];
}

-(int)count:(NSString*)table{
    int count = 0;
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",table];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        NSLog(@"result = %@",resultSet.columnNameToIndexMap);
        while ([resultSet next]) {
            count++;
        }
        [self.db close];
    }
    return count;
}

-(Poem*) getPoemById:(int) poemId{
    Poem* poem = nil;
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = %d",TAB_POEM,poemId];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        if(resultSet.next){
            poem = [Poem poemWithFMResult:resultSet];
        }
    }
    return poem;
}

- (Ci *)getCiById:(int)ciId{
    return nil;
}

- (NSArray *)getPoemByAuthor:(NSString *)author{
    NSMutableArray *poems = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE author like '%%%@%%'",TAB_POEM,author];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [poems addObject:[Poem poemWithFMResult:resultSet]];
        }
    }
    return poems;
}

- (NSArray *)getCiByAuthor:(NSString *)auhtor{
    return nil;
}

- (Author *)getAuthorByName:(NSString *)name{
    Author* auhto = nil;
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name like '%%%@%%'",TAB_AUTHOR,name];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        if(resultSet.next){
            auhto = [Author auhtorWithFMResult:resultSet];
        }
    }
    return auhto;
}

- (NSArray *)getPoemByTag:(NSString *)tag{
    NSMutableArray *poems = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE tag like '%%%@%%'",TAB_POEM,tag];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [poems addObject:[Poem poemWithFMResult:resultSet]];
        }
    }
    return poems;
}

- (NSArray *)getCiByTag:(NSString *)tag{
    NSMutableArray *songCis = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE tag like '%%%@%%'",TAB_CI,tag];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [songCis addObject:[Ci ciWithFMResult:resultSet]];
        }
    }
    return songCis;
    
}

- (NSArray *)getPoemByPage:(int)page{
    NSMutableArray *poems = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id >= %d AND id < %d",TAB_POEM,page*PAGE_SIZE,(page + 1)*PAGE_SIZE];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [poems addObject:[Poem poemWithFMResult:resultSet]];
        }
    }
    return poems;
}

- (NSArray *)getCiByPage:(int)page{
    NSMutableArray *songCis = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id >= %d AND id < %d",TAB_CI,page*PAGE_SIZE,(page + 1)*PAGE_SIZE];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [songCis addObject:[Ci ciWithFMResult:resultSet]];
        }
    }
    return songCis;
}

- (NSArray *)searchPoem:(NSString *)search{
    NSMutableArray *poems = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE author like '%%%@%%' OR title like '%%%@%%' OR txt like '%%%@%%' or tag like '%%%@%%'",TAB_POEM,search,search,search,search];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [poems addObject:[Poem poemWithFMResult:resultSet]];
        }
    }
    return poems;
}

- (NSArray *)searchCi:(NSString *)search{
    NSMutableArray *songCis = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE author like '%%%@%%' OR title like '%%%@%%' OR txt like '%%%@%%' or tag like '%%%@%%'",TAB_CI,search,search,search,search];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [songCis addObject:[Ci ciWithFMResult:resultSet]];
        }
    }
    return songCis;
}

- (NSArray *)getAllTag{
    NSMutableArray *tags = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ",TAB_TAG];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [tags addObject:[resultSet objectForColumn:@"name"]];
        }
    }
    return tags;
}

- (NSArray *)searchTag:(NSString *)search{
    NSMutableArray *tags = [[NSMutableArray alloc]init];
    if([self.db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name like '%%%@%%'",TAB_TAG,search];
        NSLog(@"sql= %@",sql);
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while(resultSet.next){
            [tags addObject:[resultSet objectForColumn:@"name"]];
        }
    }
    return tags;
}

- (NSArray *)searchByTag:(NSString *)tag{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self.db open]) {
        [array addObjectsFromArray:[self getCiByTag:tag]];
        [array addObjectsFromArray:[self getPoemByTag:tag]];
    }
    return array;
}

- (BOOL)deleteTag:(NSString *)tag{
    if([self.db open]){
        NSString *update_poem = [NSString stringWithFormat:@"UPDATE %@ SET tag = '%@' WHERE tag = '%@'",TAB_POEM,@"",tag];
        NSString *update_ci = [NSString stringWithFormat:@"UPDATE %@ SET tag = '%@' WHERE tag = '%@'",TAB_CI,@"",tag];
        NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",TAB_TAG,tag];
        NSLog(@"update_poem = %@",update_poem);
        NSLog(@"update_ci = %@",update_ci);
        NSLog(@"delete = %@",delete);
        [self.db executeUpdate:update_poem];
        [self.db executeUpdate:update_ci];
        [self.db executeUpdate:delete];
        return YES;
    }
    return NO;
}

- (int)updateTag:(NSString *)newTag forTable:(NSString *)table andId:(int)uid{
    if([self.db open]){
        //根据id查询oldTag
        NSString *select = [NSString stringWithFormat:@"SELECT tag FROM %@ WHERE id = %d",table,uid];
        NSLog(@"select = %@",select);
        FMResultSet *resultSet = [self.db executeQuery:select];
        if(resultSet.next){
            NSString *oldTag = [resultSet objectForColumn:@"tag"];
            NSLog(@"oldTag = %@",oldTag);
            if (![oldTag isEqual:[NSNull null]]){
                NSLog(@"oldTag = %@",oldTag);
                //删除Tag表中的tag
                NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",TAB_TAG,oldTag];
                NSLog(@"delete = %@",delete);
                [self.db executeUpdate:delete];
            }
        }
        //insert tag表
        [self insertTag:newTag];
        //update table 表中的tag
        NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET tag = '%@' WHERE id = %d",table,newTag,uid];
        NSLog(@"update = %@",update);
        return [self.db executeUpdate:update];
    }
    
    return 0;
}


-(void)insertTag:(NSString*)tag{
    if([self.db open]){
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name = '%@'",TAB_TAG,tag];
        NSLog(@"insert select = %@",select);
        FMResultSet *resultSet = [self.db executeQuery:select];
        if (!resultSet.next) {
            NSString *insert= [NSString stringWithFormat:@"INSERT INTO %@ ('name') VALUES ('%@')",TAB_TAG,tag];
            NSLog(@"insert = %@",insert);
            [self.db executeUpdate:insert];
        }
    }
}

@end
