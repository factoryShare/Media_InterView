//
//  NewManuscriptVC.h
//  Interview
//
//  Created by ChengFei on 16/4/15.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManuscriptModel.h"
@interface NewManuscriptVC : UIViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) ManuscriptModel *manuscriptModel;
@end
