//
//  NewPlanVC.m
//  Interview
//
//  Created by fei on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "NewPlanVC.h"
#import "PlanItemModel.h"
#import "PlanItemCell.h"
#import "PlanModel.h"
@interface NewPlanVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlanModel *planModel;
@property (nonatomic, strong) NSArray *itemsArray;
@end

@implementation NewPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

// 初始化模型
- (void)loadData {
    // 新建模型
    if (self.planModel == nil) {
        PlanItemModel *model0 =[[PlanItemModel alloc] init];
        model0.title = @"采访主题";
        model0.detail = @"";
        
        PlanItemModel *model1 =[[PlanItemModel alloc] init];
        model1.title = @"策划日期";
        model1.detail = @"";
        
        PlanItemModel *model2 =[[PlanItemModel alloc] init];
        model2.title = @"发生时间";
        model2.detail = @"";
        
        PlanItemModel *model3 =[[PlanItemModel alloc] init];
        model3.title = @"报道形式";
        model3.detail = @"";
        
        PlanItemModel *model4 =[[PlanItemModel alloc] init];
        model4.title = @"主题策划";
        model4.detail = @"";
        
        PlanItemModel *model5 =[[PlanItemModel alloc] init];
        model5.title = @"工作出勤";
        model5.detail = @"";
        
        PlanItemModel *model6 =[[PlanItemModel alloc] init];
        model6.title = @"发稿栏目";
        model6.detail = @"";
        
        PlanItemModel *model7 =[[PlanItemModel alloc] init];
        model7.title = @"策划内容";
        model7.detail = @"";
        
        _itemsArray = @[model0,
                        model1,
                        model2,
                        model3,
                        model4,
                        model5,
                        model6,
                        model7];
    }
}

- (void)initUI {
    self.title = @"新建策划";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemsArray.count;
}

#pragma mark -- tableView delegate 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10.0f;
    } else {
        return 0.1f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlanItemModel *model = self.itemsArray[indexPath.section];
    PlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell"];
    cell.titleLabel.text = model.title;
    cell.detailLabel.text = model.detail;
    return cell;
}








@end
