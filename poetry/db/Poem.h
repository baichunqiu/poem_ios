//
//  Poem.h
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "Base.h"

NS_ASSUME_NONNULL_BEGIN

@interface Poem : Base

+(instancetype)poemWithFMResult:(FMResultSet *)resultSet;
@end

NS_ASSUME_NONNULL_END
