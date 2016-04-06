//
//  QMRecorderListCell.h
//  Interview
//
//  Created by Mr.Right on 16/4/5.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMRecoderDBModel.h"

@interface QMRecorderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (strong, nonatomic) IBOutlet UIButton *cellPlayBtn;

@property(nonatomic,strong) QMRecoderDBModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
