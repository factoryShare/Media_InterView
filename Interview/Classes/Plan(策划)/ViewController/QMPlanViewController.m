//
//  QMPlanViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/1.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMPlanViewController.h"
#import "NewPlanVC.h"
#import "PlanListVC.h"
#import "PlanViewCell.h"

@interface QMPlanViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation QMPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _titleArray = @[@"新建策划", @"未发策划", @"已发策划"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"planViewCell"];
    cell.titleLabel.text = _titleArray[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 新建策划
    if (indexPath.row == 0) {
        NewPlanVC *newPlanVC = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"NewPlanVC"];
        [self.navigationController pushViewController:newPlanVC animated:YES];
    } else {
        PlanListVC *listVC = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"PlanListVC"];
        if (indexPath.row == 1) { // 未发策划
            listVC.isSendToServer = NO;
        } else { // 已发策划
            listVC.isSendToServer = YES;
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }

}


@end
