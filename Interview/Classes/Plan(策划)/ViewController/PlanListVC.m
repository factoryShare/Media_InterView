//
//  PlanListVC.m
//  Interview
//
//  Created by fei on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "PlanListVC.h"
#import "LKDBUtils.h"
#import "LKDBHelper.h"
#import "PlanModel.h"
#import "FMDB.h"
#import "NewPlanVC.h"

@interface PlanListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, assign) BOOL canEdit;
@end

@implementation PlanListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"DBUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"SendPlanSuccess" object:nil];
}

- (void)refresh {
    [self initData];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DBUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendPlanSuccess" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)initUI {
    _canEdit = YES;
    self.navigationController.title = _isSendToServer ? @"已发策划":@"未发策划";
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
    _dataArray = [PlanModel searchWithWhere:where orderBy:@"EventDate desc" offset:0 count:0];
    for (PlanModel *planModel in _dataArray) {
        NSLog(@"eventTitle:%@  planId:%@",planModel.EventTitle, planModel.planId);
    }
}

#pragma mark ----UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanListCell"];
    PlanModel *planModel = _dataArray[indexPath.section];
    cell.textLabel.text = planModel.EventTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_canEdit) {
        PlanModel *planModel = _dataArray[indexPath.section];
        NewPlanVC *newPlanVC = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"NewPlanVC"];
        newPlanVC.planModel = planModel;
        [self.navigationController pushViewController:newPlanVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

@end
