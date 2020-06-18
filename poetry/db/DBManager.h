//
//  DBManager.h
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poem.h"
#import "Ci.h"
#import "Author.h"

NS_ASSUME_NONNULL_BEGIN

#define DB_NAME @"shici.db"
#define TAB_POEM @"poem"
#define TAB_CI @"songci"
#define TAB_AUTHOR @"author"
#define TAB_TAG @"tag"

#define PAGE_SIZE 20

@interface DBManager : NSObject

//打开数据库
-(BOOL)openDatabase;

//统计表数据
-(int)count:(NSString*)table;

//根据id 获取唐诗
-(Poem*) getPoemById:(int) poemId;

//根据id获取宋词
-(Ci*) getCiById:(int) ciId;

//根据作者获取唐诗
-(NSArray*) getPoemByAuthor:(NSString*) author;

//根据作者获取宋词
-(NSArray*) getCiByAuthor:(NSString*) auhtor;

//根据名称获取作者信息
-(Author*)getAuthorByName:(NSString*) name;

//根据tag获取唐诗
-(NSArray*) getPoemByTag:(NSString*) tag;

//根据tag获取宋词
-(NSArray*) getCiByTag:(NSString*) tag;

//分页获取唐诗
-(NSArray*) getPoemByPage:(int) page;

//分页获取宋词
-(NSArray*) getCiByPage:(int) page;

//搜索唐诗
-(NSArray*) searchPoem:(NSString*) searchInfo;

//搜索宋词
-(NSArray*) searchCi:(NSString*) searchInfo;

-(NSArray*) getAllTag;

//搜索tag
-(NSArray*) searchTag:(NSString*) searchInfo;

//根据搜索唐诗宋词
-(NSArray*) searchByTag:(NSString*) searchInfo;

//删除tag
-(BOOL)deleteTag:(NSString*)tag;

//跟新tag
-(int)updateTag:(NSString*)tag forTable:(NSString*)table andId:(int)uid;
@end

NS_ASSUME_NONNULL_END
