//
//  DetailsViewController.h
//  poetry
//
//  Created by 白春秋 on 2019/9/26.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UILabel *lbTag;
//@property (weak, nonatomic) IBOutlet UILabel *lbTxt;

@property(nonatomic,strong) Base *data;

@end

NS_ASSUME_NONNULL_END
