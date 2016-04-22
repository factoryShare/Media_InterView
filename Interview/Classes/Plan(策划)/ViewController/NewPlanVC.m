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
#import "DatePickView.h"
#import "TimePickView.h"
#import "CustomPickView.h"
#import "PlanModel.h"
#import "CommonUI.h"
#import "AFNetworking.h"
#import "CustomTextView.h"
#import "MBProgressHUD.h"
#import "QMUserInfoViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define pathToService [[NSUserDefaults standardUserDefaults] objectForKey:@"pathToService"]

@interface NewPlanVC () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DatePickViewDelegate, TimePickViewDelegate, CustomPickViewDelegate, CustomTextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) UIAlertView *subjectAlert;
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
@property (nonatomic, strong) UIBarButtonItem *saveItem;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIAlertView *sendAlert;
@property (nonatomic, strong) CustomTextView *textView;


@property (nonatomic, assign) BOOL canEdit;

@end

@implementation NewPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canEdit = _planModel==nil ? YES:NO;
    [self initUI];
    [self loadData];
    _canEdit = YES;
   //获取新闻策划配置存在本地

}

// 获得新闻策划配置
#warning 服务器接口有问题, 这里就不调用了
- (void)getConfigs {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/accouts/getConfigs",pathToService];
    // 请求的参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *path = pathToService;
    if (token.length > 0 && path.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [parameters setObject: token forKey:@"token"];
        // 初始化Manager
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // post请求
        [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id  _Nonnull formData) {
            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            // 这里可以获取到目前的数据请求的进度
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            QMLog(@"result: %@", result);
            if ((![result[@"Data"] isKindOfClass:[NSNull class]] && [result[@"Error"] isKindOfClass:[NSNull class]])) {
                
            } else {
                [CommonUI showTextOnly:@"请登录"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            QMLog(@"error: %@", [error localizedDescription]);
        }];
    } else {
        [CommonUI showTextOnly:@"token 失效请重新登录"];
    }
    _canEdit = _planModel==nil ? YES:NO;
//    [self singnInWithAFN];
    [self initUI];
    [self loadData];

}

// 初始化模型
- (void)loadData {
    
    // 策划模型
    if (self.planModel == nil) {
        _planModel = [[PlanModel alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        //    设置日期转换格式
        df.dateFormat = @"yyyyMMddHHmmss";
        NSDate *date = [NSDate date];
        _planModel.planId = [NSString stringWithFormat:@"plan%@",[df stringFromDate:date]];
        _planModel.EventTitle = @"";
        _planModel.EventDate = @"";
        _planModel.OccurTime = @"";
        _planModel.ReportType = @"";
        _planModel.MainDesign = @"";
        _planModel.WorkAttendance = @"";
        _planModel.SendPackets = @"";
        _planModel.EventDescribe = @"";
        _planModel.isSendToServer = @"0";
    }
    
    // 策划 item 模型
    
    PlanItemModel *model0 =[[PlanItemModel alloc] init];
    model0.identifier = @"EventTitle";
    model0.title = @"采访主题";
    model0.detail = _planModel.EventTitle;
    
    PlanItemModel *model1 =[[PlanItemModel alloc] init];
    model1.identifier = @"EventDate";
    model1.title = @"策划日期";
    model1.detail = _planModel.EventDate;
    
    PlanItemModel *model2 =[[PlanItemModel alloc] init];
    model2.identifier = @"OccurTime";
    model2.title = @"发生时间";
    model2.detail = _planModel.OccurTime;
    
    PlanItemModel *model3 =[[PlanItemModel alloc] init];
    model3.identifier = @"ReportType";
    model3.title = @"报道形式";
    model3.detail = _planModel.ReportType;
    
    PlanItemModel *model4 =[[PlanItemModel alloc] init];
    model4.identifier = @"MainDesign";
    model4.title = @"主题策划";
    model4.detail = _planModel.MainDesign;
    
    PlanItemModel *model5 =[[PlanItemModel alloc] init];
    model5.identifier = @"WorkAttendance";
    model5.title = @"工作出勤";
    model5.detail = _planModel.WorkAttendance;
    
    PlanItemModel *model6 =[[PlanItemModel alloc] init];
    model6.identifier = @"SendPackets";
    model6.title = @"发稿栏目";
    model6.detail = _planModel.SendPackets;
    
    PlanItemModel *model7 =[[PlanItemModel alloc] init];
    model7.identifier = @"EventDescribe";
    model7.title = @"策划内容";
    model7.detail = _planModel.EventDescribe;
    
    _itemsArray = @[model0,
                    model1,
                    model2,
                    model3,
                    model4,
                    model5,
                    model6,
                    model7];
    
    
    _reportFormArray = @[@"现场", @"录音", @"评论", @"口头", @"消息", @"专题"];
    _planSubjectArray = @[@"整点连线", @"突发及追踪连线", @"主题直播策划"];
    _attendanceArray = @[@"早加班", @"晚加班", @"双休日", @"法定假日", @"休假", @"请假", @"请事假", @"请病假", @"秀年假"];
    _columeArray = @[@"编辑",@"品质车生活",@"经典正流行",@"政务监督热线",@"小说连播",@"1066城市爱生活",@"整点新闻2",@"女人花",@"家住济南",@"健康园地1",@"整点新闻1",@"整点新闻6",@"深夜故事",@"体育大世界",@"四点有话说（重播）",@"以案说法（重播）",@"含笑时间（重播）",@"以案说法",@"健康广场4点半",@"健康广场5点半",@"健康早班车",@"转中央台新闻报纸摘要",@"经广新闻网",@"846传真",@"第一时间",@"听说很好看",@"非想非非想",@"流行小说城",@"大力幻想秀",@"小罗罗崩木根重播",@"长书连播",@"健康广场14点",@"四点有话说",@"闲话闲说",@"财富直通车",@"健康广场22点",@"方言客栈",@"闲话闲说（重播）",@"健康广场20点半",@"刘成故事重播",@"含笑时间",@"闲话闲说23点",@"健康广场23点半-1",@"历史上的今天",@"汽车服务热线重播",@"刘敏热线重播",@"汽车音乐CD重播",@"在清华听演讲重播",@"交通雷达网",@"交广听吧2",@"汽车音乐CD",@"刘敏热线",@"一路领先",@"交广周末合家欢（周日",@"流行纪念册",@"汽车服务热线",@"小罗罗崩木跟",@"怀旧音乐时间晚间",@"都市顺风车",@"司机俱乐部",@"在清华听演讲",@"半点资讯9:30",@"半点资讯10：30",@"半点气象9：30",@"天天说事(重播)",@"女人花(重播)",@"泉城气象",@"转中央《新闻和报纸》",@"早安泉城",@"新闻六十分",@"Music",@"娱乐短讯",@"广告001",@"健康广场0点",@"博闻天下",@"国学天天学",@"健康广场23点半",@"政务监督热线（重播）",@"法理人生",@"怀旧音乐时间重播",@"半点气象10：30",@"半点气象15：30",@"半点气象16：30",@"半点气象17：30",@"半点气象18：30",@"怀旧音乐时间（周末）",@"小说连播（重播）",@"法理人生(重播)",@"爱情1+1",@"1066娱乐满天星",@"健康园地2",@"天天健康",@"整点新闻3",@"整点新闻4",@"整点新闻5",@"美食乐翻天",@"天天说事儿",@"八点聊天室",@"健康园地",@"金山夜话（第一时段）",@"金山夜话（第一重播）",@"综艺广告",@"金山夜话（第二时段）",@"济南新闻",@"我能赢",@"资讯全知道",@"抬杠",@"心理热线",@"恭喜发财",@"下一站幸福",@"天天养生",@"1",@"幸福歌会",@"小说连播午间版",@"曲山艺海",@"11",@"戏曲大舞台",@"聆听老歌",@"111",@"健康新生活",@"午夜收音机",@"非常记录",@"听书俱乐部",@"健康百分百",@"编辑",@"私家车听天下",@"顺风顺水私家车",@"00",@"0000",@"0000000",@"娱乐九号线",@"私家车爱音乐",@"私家车N0.1",@"私家车最动听",@"私家车爱兜风",@"我要去旅行",@"叮咚FM主播征集"];
    
    
    
}

- (void)initUI {
    self.title = @"新建策划";
    
    // 保存按钮
    _saveItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveItemClicked)];
    _saveItem.tintColor = [UIColor whiteColor];
    
    
    _editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editItemClicked)];
    _editItem.tintColor = [UIColor whiteColor];
    
    
    if (_canEdit) {
        self.navigationItem.rightBarButtonItem = _saveItem;
    } else {
        self.navigationItem.rightBarButtonItem = _editItem;
    }
    
    
}

- (void)saveItemClicked {

    BOOL canSaveToDB = YES;
   
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
        [PlanModel insertWhenNotExists:_planModel];
        [PlanModel updateToDB:_planModel where:nil];
        _canEdit = NO;
        self.navigationItem.rightBarButtonItem = _editItem;
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DBUpdated" object:nil];
        
        
        // 测试数据库有没有保存成功
//        NSMutableArray *array = [NSMutableArray array];
//        array = [PlanModel searchWithWhere:nil orderBy:nil offset:0 count:0];
//        for (PlanModel *model in array) {
//            QMLog(@"db back EventTitle : %@",model.EventTitle);
//        }
        
    } else {
        [CommonUI showTextOnly:@"请填写完整信息"];
    }
}

- (void)editItemClicked {
    _canEdit = YES;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = _saveItem;
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
    if (_canEdit) {
        return self.itemsArray.count;
    } else {
        return self.itemsArray.count + 1;
    }
    
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
    if (indexPath.section < self.itemsArray.count) {
        PlanItemModel *model = self.itemsArray[indexPath.section];
        PlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell"];
        cell.titleLabel.text = model.title;
        cell.detailLabel.text = model.detail;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendCell"];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_canEdit) {
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
            [self addTextViewWithDetail:model.detail];
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
    
    // 发送策划到服务器
    if (indexPath.section == self.itemsArray.count) {
        
        _sendAlert = [[UIAlertView alloc] initWithTitle:@"是否上传" message: nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
        [_sendAlert show];
        
    }
    
}


#pragma mark --- 网络
- (void)sendPlanToServer {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/eventDesign/uploadEventDesign",pathToService];
    // 请求的参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *path = pathToService;
    if (token.length > 0 && path.length > 0) {
        [parameters setObject: token forKey:@"token"];
        [parameters setObject:_planModel.EventTitle forKey:@"EventTitle"];
        [parameters setObject:_planModel.EventDate  forKey:@"EventDate"];
        [parameters setObject:_planModel.OccurTime forKey:@"OccurTime"];
        [parameters setObject:_planModel.ReportType forKey:@"ReportType"];
        [parameters setObject:_planModel.MainDesign forKey:@"MainDesign"];
        [parameters setObject:_planModel.WorkAttendance forKey:@"WorkAttendance"];
        [parameters setObject:_planModel.SendPackets forKey:@"SendPackets"];
        [parameters setObject:_planModel.EventDescribe forKey:@"EventDescribe"];
        
        // 初始化Manager
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // post请求
        [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id  _Nonnull formData) {
            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            // 这里可以获取到目前的数据请求的进度
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            QMLog(@"result: %@", result);
            if ((![result[@"Data"] isKindOfClass:[NSNull class]] && [result[@"Error"] isKindOfClass:[NSNull class]])) {
                _planModel.isSendToServer = @"1";
                [_planModel updateToDB];
                [CommonUI showTextOnly:@"上传成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SendPlanSuccess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];

            } else {
//                [CommonUI showTextOnly:@"请登录"];
                [MBProgressHUD showError:@"请重新登录"];
                QMUserInfoViewController *loginVC = [[QMUserInfoViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            // 请求失败
            QMLog(@"error: %@", [error localizedDescription]);
        }];
    } else {
//        [CommonUI showTextOnly:@"token 失效请重新登录"];
        [MBProgressHUD showError:@"请重新登录"];
        QMUserInfoViewController *loginVC = [[QMUserInfoViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];

    }
    
}

#pragma mark   --CustomTextView

- (void)addTextViewWithDetail:(NSString *)detail {
    _textView = [[CustomTextView alloc] initWithFrame:[UIScreen mainScreen].bounds andText:detail];
    _textView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_textView];
}
- (void)customTextViewDelegateCancle {
    [_textView removeFromSuperview];
}

- (void)customTextViewDelegateConfirm:(NSString *)text {
    [_textView removeFromSuperview];
    // 更新模型 , 更新 tabelView
    for (PlanItemModel *model in self.itemsArray) {
        if ([model.title isEqualToString:@"策划内容"]) {
            if (text) {
                model.detail = text;
            }
        }
    }
    [self.tableView reloadData];
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
    QMLog(@"dateString:%@",dateString);
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
    QMLog(@"timeString:%@",timeString);
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
    QMLog(@"selected string : %@",selectedString);
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
    
    if (alertView == _sendAlert) {
        if (buttonIndex == 1) {
            [self sendPlanToServer];
        }
    }
    
    
}


@end
