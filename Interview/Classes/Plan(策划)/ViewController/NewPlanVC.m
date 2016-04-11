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
@interface NewPlanVC () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlanModel *planModel;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) UIAlertView *subjectAlert;
@property (nonatomic, strong) UIAlertView *contentAlert;
@property (nonatomic, strong) UIPickerView *planTimePicker;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanItemModel *model = self.itemsArray[indexPath.section];
    if ([model.title isEqualToString:@"采访主题"]) {
        _subjectAlert = [[UIAlertView alloc] initWithTitle:@"请输入标题" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _subjectAlert.delegate = self;
        _subjectAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_subjectAlert show];
        //得到输入框
        UITextField *tf = [_subjectAlert textFieldAtIndex:0];
        tf.text = model.detail;
    }
    
    if ([model.title isEqualToString:@"策划内容"]) {
        _contentAlert = [[UIAlertView alloc] initWithTitle:@"请输入内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _contentAlert.delegate = self;
        _contentAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_contentAlert show];
        //输入框
        UITextField *tf = [_contentAlert textFieldAtIndex:0];
        tf.text = model.detail;
    }
    
    if ([model.title isEqualToString:@"策划日期"]) {
        [self addDatePicker];
        
    }
}

- (void)addDatePicker {
    
    UIView *pickerBack = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216, 0, 216)];
    pickerBack.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:pickerBack];
    //    这里设置width和height是无效的
    UIDatePicker *datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    //    设置本地化
    datePicker.locale=[NSLocale localeWithLocaleIdentifier:@"zh"];
    //    设置显示模式
    datePicker.datePickerMode=UIDatePickerModeDate;
    [pickerBack addSubview:datePicker];
    //    设置时区
    datePicker.timeZone=[NSTimeZone localTimeZone];
    //    最小最大时间
    //    日期转换类
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    NSString * dateStr=@"2000-01-01";
    //    设置日期转换格式
    df.dateFormat=@"yyyy-MM-dd";
    //    dateFromString从字符串转日期
    NSDate * date=[df dateFromString:dateStr];
    datePicker.minimumDate=date;
    //    设置最大时间
    datePicker.maximumDate=[NSDate date];
    [datePicker addTarget:self action:@selector(datePickerViewChange:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark datePicker值改变后执行的方法
-(void)datePickerViewChange:(UIDatePicker *)datePicker {
    NSLog(@"datePicker值改变");
    NSDateFormatter * df=[[NSDateFormatter alloc]init];
    //    日期转化为字符串
    //    设置转换格式
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSString * strDate=[df stringFromDate:datePicker.date];
    NSLog(@"%@",strDate);
}


#pragma mark --------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 采访主题
    if (alertView == _subjectAlert) {
       // 确定
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            // 更新模型 , 更新 tabelView
            for (PlanItemModel *model in self.itemsArray) {
                if ([model.title isEqualToString:@"采访主题"]) {
                    if (tf.text) {
                        model.detail = tf.text;
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
   
    // 策划内容
    if (alertView == _contentAlert) {
        // 确定
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            // 更新模型 , 更新 tabelView
            for (PlanItemModel *model in self.itemsArray) {
                if ([model.title isEqualToString:@"策划内容"]) {
                    if (tf.text) {
                        model.detail = tf.text;
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
    
}



@end
