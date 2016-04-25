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
#import "NewManuscriptVC.h"

#import "LZFileHandle.h"

@interface QMManuscriptListViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, assign) BOOL canEdit;
@property(nonatomic,strong) LZFileHandle *handle;
@end

@implementation QMManuscriptListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"manuscriptDbUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"SendManuscriptSuccess" object:nil];
    
}

- (void)refresh {
    [self initData];
    [self.tableView reloadData];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"manuscriptDbUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendManuscriptSuccess" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    _canEdit = YES;
    self.title = _isSendToServer ? @"已发稿件":@"未发稿件";
    _editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(editItemClicked)];
    _editItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _editItem;
}
- (void)editItemClicked {
    _canEdit = !_canEdit;
    NSString *imageName = _canEdit ? @"icon_edit" : @"nav_delete";
    _editItem.image = [UIImage imageNamed:imageName];
    [self.tableView setEditing:!_canEdit animated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ManuscriptModel *scriptModel = _dataArray[indexPath.section];
    NewManuscriptVC *vc = [[UIStoryboard storyboardWithName:@"Manuscript" bundle:nil] instantiateViewControllerWithIdentifier:@"NewManuscriptVC"];
    vc.manuscriptModel = scriptModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ManuscriptModel *scriptModel = _dataArray[indexPath.section];
        [self.dataArray removeObject:scriptModel];
        // 删除图片
        NSArray *array = scriptModel.attachmentArray;
        /*
         NSDictionary *dict = @{@"attachmentTyp":attachModel.attachmentType,
         @"imageName":attachModel.imageName,
         @"recordName":attachModel.recordName};
         */
        for (NSDictionary *attachment in array) {
            if ([attachment[@"attachmentTyp"] isEqualToString:AttachmentTypeImage]) {
                NSString *path = attachment[@"imageName"];
                NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                // 初始化格式地址
                NSString *imagePath = [tempDir stringByAppendingPathComponent:path];
                NSLog(@"%@",imagePath);
                [self.handle removeFileAtPath:imagePath];
            }
        }
        
        // 删除本地数据库
        [ManuscriptModel deleteToDB:scriptModel];
        [self.tableView reloadData];
    }
}

- (LZFileHandle *)handle {
    if (!_handle) {
        _handle = [[LZFileHandle alloc]init];
    }
    return _handle;
}

@end
