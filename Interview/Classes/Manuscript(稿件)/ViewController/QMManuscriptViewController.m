//
//  QMManuscriptViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/1.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMManuscriptViewController.h"
#import "NewManuscriptVC.h"
#import "QMManuscriptListViewController.h"


@interface QMManuscriptViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation QMManuscriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"新建稿件", @"未发稿件", @"已发稿件"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view  Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return  _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ManuscriptCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _titleArray[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 新建稿件
        NewManuscriptVC *vc = [[UIStoryboard storyboardWithName:@"Manuscript" bundle:nil] instantiateViewControllerWithIdentifier:@"NewManuscriptVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        QMManuscriptListViewController *vc = [[UIStoryboard storyboardWithName:@"Manuscript" bundle:nil] instantiateViewControllerWithIdentifier:@"QMManuscriptListViewController"];
        if (indexPath.section == 1) {
            vc.isSendToServer = NO;
        } else {
            vc.isSendToServer = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
