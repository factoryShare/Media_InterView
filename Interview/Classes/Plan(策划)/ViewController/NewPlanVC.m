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
#import "DatePickView.h"
#import "TimePickView.h"
#import "CustomPickView.h"
#import "PlanModel.h"
#import "CommonUI.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface NewPlanVC () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DatePickViewDelegate, TimePickViewDelegate, CustomPickViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlanModel *planModel;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) UIAlertView *subjectAlert;
@property (nonatomic, strong) UIAlertView *contentAlert;
@property (nonatomic, strong) UIPickerView *planTimePicker;
@property (nonatomic, strong) DatePickView *datePicker;
@property (nonatomic, strong) TimePickView *timePicker;
@property (nonatomic, strong) NSArray *reportFormArray;
@property (nonatomic, strong) NSArray *planSubjectArray;
@property (nonatomic, strong) NSArray *attendanceArray;
@property (nonatomic, strong) NSArray *columeArray;

@property (nonatomic, strong) CustomPickView *reportFormPicker;
@property (nonatomic, strong) CustomPickView *planSubjectPicker;
@property (nonatomic, strong) CustomPickView *attendancePicker;
@property (nonatomic, strong) CustomPickView *columePicker;


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
        model0.identifier = @"EventTitle";
        model0.title = @"采访主题";
        model0.detail = @"";
        
        PlanItemModel *model1 =[[PlanItemModel alloc] init];
        model1.identifier = @"EventDate";
        model1.title = @"策划日期";
        model1.detail = @"";
        
        PlanItemModel *model2 =[[PlanItemModel alloc] init];
        model2.identifier = @"OccurTime";
        model2.title = @"发生时间";
        model2.detail = @"";
        
        PlanItemModel *model3 =[[PlanItemModel alloc] init];
        model3.identifier = @"ReportType";
        model3.title = @"报道形式";
        model3.detail = @"";
        
        PlanItemModel *model4 =[[PlanItemModel alloc] init];
        model4.identifier = @"MainDesign";
        model4.title = @"主题策划";
        model4.detail = @"";
        
        PlanItemModel *model5 =[[PlanItemModel alloc] init];
        model5.identifier = @"WorkAttendance";
        model5.title = @"工作出勤";
        model5.detail = @"";
        
        PlanItemModel *model6 =[[PlanItemModel alloc] init];
        model6.identifier = @"SendPackets";
        model6.title = @"发稿栏目";
        model6.detail = @"";
        
        PlanItemModel *model7 =[[PlanItemModel alloc] init];
        model7.identifier = @"EventDescribe";
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
    
    _reportFormArray = @[@"现场", @"录音", @"评论", @"口头", @"消息", @"专题"];
    _planSubjectArray = @[@"整点连线", @"突发及追踪连线", @"主题直播策划"];
    _attendanceArray = @[@"早加班", @"晚加班", @"双休日", @"法定假日", @"休假", @"请假", @"请事假", @"请病假", @"秀年假"];
    _columeArray = @[@"编辑",@"品质车生活",@"经典正流行",@"政务监督热线",@"小说连播",@"1066城市爱生活",@"整点新闻2",@"女人花",@"家住济南",@"健康园地1",@"整点新闻1",@"整点新闻6",@"深夜故事",@"体育大世界",@"四点有话说（重播）",@"以案说法（重播）",@"含笑时间（重播）",@"以案说法",@"健康广场4点半",@"健康广场5点半",@"健康早班车",@"转中央台新闻报纸摘要",@"经广新闻网",@"846传真",@"第一时间",@"听说很好看",@"非想非非想",@"流行小说城",@"大力幻想秀",@"小罗罗崩木根重播",@"长书连播",@"健康广场14点",@"四点有话说",@"闲话闲说",@"财富直通车",@"健康广场22点",@"方言客栈",@"闲话闲说（重播）",@"健康广场20点半",@"刘成故事重播",@"含笑时间",@"闲话闲说23点",@"健康广场23点半-1",@"历史上的今天",@"汽车服务热线重播",@"刘敏热线重播",@"汽车音乐CD重播",@"在清华听演讲重播",@"交通雷达网",@"交广听吧2",@"汽车音乐CD",@"刘敏热线",@"一路领先",@"交广周末合家欢（周日",@"流行纪念册",@"汽车服务热线",@"小罗罗崩木跟",@"怀旧音乐时间晚间",@"都市顺风车",@"司机俱乐部",@"在清华听演讲",@"半点资讯9:30",@"半点资讯10：30",@"半点气象9：30",@"天天说事(重播)",@"女人花(重播)",@"泉城气象",@"转中央《新闻和报纸》",@"早安泉城",@"新闻六十分",@"Music",@"娱乐短讯",@"广告001",@"健康广场0点",@"博闻天下",@"国学天天学",@"健康广场23点半",@"政务监督热线（重播）",@"法理人生",@"怀旧音乐时间重播",@"半点气象10：30",@"半点气象15：30",@"半点气象16：30",@"半点气象17：30",@"半点气象18：30",@"怀旧音乐时间（周末）",@"小说连播（重播）",@"法理人生(重播)",@"爱情1+1",@"1066娱乐满天星",@"健康园地2",@"天天健康",@"整点新闻3",@"整点新闻4",@"整点新闻5",@"美食乐翻天",@"天天说事儿",@"八点聊天室",@"健康园地",@"金山夜话（第一时段）",@"金山夜话（第一重播）",@"综艺广告",@"金山夜话（第二时段）",@"济南新闻",@"我能赢",@"资讯全知道",@"抬杠",@"心理热线",@"恭喜发财",@"下一站幸福",@"天天养生",@"1",@"幸福歌会",@"小说连播午间版",@"曲山艺海",@"11",@"戏曲大舞台",@"聆听老歌",@"111",@"健康新生活",@"午夜收音机",@"非常记录",@"听书俱乐部",@"健康百分百",@"编辑",@"私家车听天下",@"顺风顺水私家车",@"00",@"0000",@"0000000",@"娱乐九号线",@"私家车爱音乐",@"私家车N0.1",@"私家车最动听",@"私家车爱兜风",@"我要去旅行",@"叮咚FM主播征集"];
}

- (void)initUI {
    self.title = @"新建策划";
    
    // 保存按钮
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClicked)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)saveBtnClicked {
    
    /*
     
     @property (nonatomic, copy) NSString *EventTitle;
     @property (nonatomic, copy) NSString *EventDate;
     @property (nonatomic, copy) NSString *OccurTime;
     @property (nonatomic, copy) NSString *ReportType;
     @property (nonatomic, copy) NSString *MainDesign;
     @property (nonatomic, copy) NSString *WorkAttendance;
     @property (nonatomic, copy) NSString *SendPackets;
     @property (nonatomic, copy) NSString *EventDescribe;
     
     */
    
    BOOL canSaveToDB = YES;
    _planModel = [[PlanModel alloc] init];
    for (PlanItemModel *itemModel in self.itemsArray) {
        NSString *identifier = itemModel.identifier;
        if (itemModel.detail.length <= 0) {
            canSaveToDB = NO;
        }
        if ([identifier isEqualToString:@"EventTitle"]) {
            _planModel.EventTitle = itemModel.detail;
        }
        if ([identifier isEqualToString:@"EventDate"]) {
            _planModel.EventDate = itemModel.detail;
        }
        if ([identifier isEqualToString:@"OccurTime"]) {
            _planModel.OccurTime = itemModel.detail;
        }
        if ([identifier isEqualToString:@"ReportType"]) {
            _planModel.ReportType = itemModel.detail;
        }
        if ([identifier isEqualToString:@"MainDesign"]) {
            _planModel.MainDesign = itemModel.detail;
        }
        if ([identifier isEqualToString:@"WorkAttendance"]) {
            _planModel.WorkAttendance = itemModel.detail;
        }
        if ([identifier isEqualToString:@"SendPackets"]) {
            _planModel.SendPackets = itemModel.detail;
        }
        if ([identifier isEqualToString:@"EventDescribe"]) {
            _planModel.EventDescribe = itemModel.detail;
        }
    }
    
    
    if (canSaveToDB) {
        // 保存到数据库
        [_planModel saveToDB];
    } else {
        [CommonUI showTextOnly:@"请填写完整信息"];
    }
    
    
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
    
    if ([model.title isEqualToString:@"发生时间"]) {
        [self addTimePicker];
    }
    
    if ([model.title isEqualToString:@"报道形式"]) {
        [self addReportPickerWithArray:_reportFormArray];
    }
    
    if ([model.title isEqualToString:@"主题策划"]) {
        [self addPlanSubjectPickerWithArray:_planSubjectArray];
    }
    if ([model.title isEqualToString:@"工作出勤"]) {
        [self addAttendancePickerWithArray:_attendanceArray];
    }
    if ([model.title isEqualToString:@"发稿栏目"]) {
        [self addColumePickerWithArray:_columeArray];
    }
}



#pragma  mark  --DatePickView日期选择
- (void)addDatePicker {
    _datePicker = [[DatePickView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _datePicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker];
}
- (void)datePickViewDelegateCancle {
    [_datePicker removeFromSuperview];
    _datePicker.hidden = YES;
}
- (void)datePickViewDelegateConfirm:(NSString *)dateString {
    NSLog(@"dateString:%@",dateString);
    [_datePicker removeFromSuperview];
    _datePicker.hidden = YES;
    
    //更新模型
    for (PlanItemModel *model in self.itemsArray) {
        if ([model.title isEqualToString:@"策划日期"]) {
            model.detail = dateString;
        }
    }
    [self.tableView reloadData];
}

#pragma mark  -- TimePickView 时间选择
- (void)addTimePicker {
    _timePicker = [[TimePickView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _timePicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_timePicker];
}

- (void)timePickViewDelegateCancle {
    [_timePicker removeFromSuperview];
    _timePicker.hidden = YES;
}
- (void)timePickViewDelegateConfirm:(NSString *)timeString {
    NSLog(@"timeString:%@",timeString);
    [_timePicker removeFromSuperview];
    _timePicker.hidden = YES;
    
    for (PlanItemModel *model in self.itemsArray) {
        if ([model.title isEqualToString:@"发生时间"]) {
            model.detail = timeString;
        }
    }
    [self.tableView reloadData];
    
}

#pragma mark 自定义选择器
- (void)addReportPickerWithArray:(NSArray *)dataArray {
    _reportFormPicker = [[CustomPickView alloc] initWithFrame:[UIScreen mainScreen].bounds WithData:_reportFormArray];
    _reportFormPicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_reportFormPicker];
}

- (void)addPlanSubjectPickerWithArray:(NSArray *)dataArray {
    _planSubjectPicker = [[CustomPickView alloc] initWithFrame:[UIScreen mainScreen].bounds WithData:_planSubjectArray];
    _planSubjectPicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_planSubjectPicker];
}

- (void)addAttendancePickerWithArray:(NSArray *)dataArray {
    _attendancePicker = [[CustomPickView alloc] initWithFrame:[UIScreen mainScreen].bounds WithData:_attendanceArray];
    _attendancePicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_attendancePicker];
}

- (void)addColumePickerWithArray:(NSArray *)dataArray {
    _columePicker = [[CustomPickView alloc] initWithFrame:[UIScreen mainScreen].bounds WithData:_columeArray];
    _columePicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_columePicker];
}

- (void)customPickViewCancle:(CustomPickView *)pickView {
    [pickView removeFromSuperview];
}

- (void)customPickViewConfirm:(NSString *)selectedString pickView:(CustomPickView *)pickView {
    NSLog(@"selected string : %@",selectedString);
    [pickView removeFromSuperview];
    if (pickView == _reportFormPicker) {
        for (PlanItemModel *model in self.itemsArray) {
            if ([model.title isEqualToString:@"报道形式"]) {
                model.detail = selectedString;
            }
        }
    }
    
    if (pickView == _planSubjectPicker) {
        for (PlanItemModel *model in self.itemsArray) {
            if ([model.title isEqualToString:@"主题策划"]) {
                model.detail = selectedString;
            }
        }
    }

    if (pickView == _attendancePicker) {
        for (PlanItemModel *model in self.itemsArray) {
            if ([model.title isEqualToString:@"工作出勤"]) {
                model.detail = selectedString;
            }
        }
    }

    if (pickView == _columePicker) {
        for (PlanItemModel *model in self.itemsArray) {
            if ([model.title isEqualToString:@"发稿栏目"]) {
                model.detail = selectedString;
            }
        }
    }
    [self.tableView reloadData];
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
