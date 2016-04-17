//
//  QMManuscriptListViewController.m
//  Interview
//
//  Created by ChengFei on 16/4/17.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMManuscriptListViewController.h"
#import "ManuscriptModel.h"
#import "LKDBHelper.h"

@interface QMManuscriptListViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, assign) BOOL canEdit;
@end

@implementation QMManuscriptListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    _canEdit = YES;
    self.navigationController.title = _isSendToServer ? @"已发稿件":@"未发稿件";
    _editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editItemClicked)];
    _editItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _editItem;
}
- (void)editItemClicked {
    _canEdit = !_canEdit;
    NSString *imageName = _canEdit ? @"icon_edit" : @"nav_delete";
    _editItem.image = [UIImage imageNamed:imageName];
}

- (void)initData {
    _dataArray = [NSMutableArray array];
    NSString *where = _isSendToServer ? @"isSendToServer==1": @"isSendToServer==0" ;
    _dataArray = [ManuscriptModel searchWithWhere:where orderBy:nil offset:0 count:0];
}


#pragma mark ----UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Manuscript"];
    ManuscriptModel *scriptModel = _dataArray[indexPath.section];
    cell.textLabel.text = scriptModel.scriptTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1.0)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

@end
