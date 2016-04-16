//
//  AttachmentCell.h
//  Interview
//
//  Created by ChengFei on 16/4/16.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachmentModel.h"
@class AttachmentCell;

@protocol AttachmentCellDelegate <NSObject>

@end

@interface AttachmentCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) AttachmentModel *model;
@property (nonatomic, weak) id<AttachmentCellDelegate>delegate;
@end
