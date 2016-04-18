//
//  NewManuscriptVC.m
//  Interview
//
//  Created by ChengFei on 16/4/15.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "NewManuscriptVC.h"
#import "AttachmentCell.h"
#import "AttachmentModel.h"
#import "QMManuscriptAMRListViewController.h"
#import "QMRecoderDBModel.h"
#define marginX 10.0
#define numPerLine 3
#define itemWidth ([UIScreen mainScreen].bounds.size.width - (numPerLine+1) * marginX) / numPerLine

@interface NewManuscriptVC () <UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy) NSString *scriptTitle;
@property (nonatomic, copy) NSString *scriptContent;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@property (nonatomic, strong) NSMutableArray *attachmentArray;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, assign) NSInteger attachmentIndex;
@end

@implementation NewManuscriptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successGetRecordFile:) name:@"SelectAMRFile" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.title = @"新建稿件";
    _textView.layoutManager.allowsNonContiguousLayout=NO;
    _rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_save"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
    _rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _rightItem;
    NSString *imageName = _isEdit ? @"icon_save":@"icon_edit";
    _rightItem.image = [UIImage imageNamed:imageName];
    [self setControlsStatus];
}

- (void)rightItemClicked{
    _isEdit = !_isEdit;
    NSString *imageName = _isEdit ? @"icon_save":@"icon_edit";
    _rightItem.image = [UIImage imageNamed:imageName];
    [self setControlsStatus];
    
    // 附件删除(叉叉按钮)状态变化
    for (AttachmentModel *model in _attachmentArray) {
        model.isEdit = _isEdit;
    }
    [self.collectionView reloadData];
    
    // 更新稿件模型 保存到数据库
    if (!_isEdit) {
        _manuscriptModel.scriptTitle = self.titleTextField.text;
        _manuscriptModel.scriptContent = self.textView.text;
        NSMutableArray *array = [NSMutableArray array];
        for (AttachmentModel *attachModel in _attachmentArray) {
            NSDictionary *dict = @{@"AttachmentTyp":attachModel.attachmentType,
                                   @"imageName":attachModel.imageName,
                                   @"recordName":attachModel.recordName};
            [array addObject:dict];
            
        }
        NSArray *attachs = [array copy];
        _manuscriptModel.attachmentArray = attachs;
        [ManuscriptModel insertWhenNotExists:_manuscriptModel];
        [ManuscriptModel updateToDB:_manuscriptModel where:nil];
    }
    
//     测试数据库有没有保存成功
    NSMutableArray *array = [NSMutableArray array];
    array = [ManuscriptModel searchWithWhere:nil orderBy:nil offset:0 count:0];
    for (ManuscriptModel *scriptModel in array) {
        NSLog(@"title: %@",scriptModel.scriptTitle);
        NSArray *array = scriptModel.attachmentArray;
        for (NSDictionary *dict in array) {
            NSString *imageName = dict[@"imageName"];
            NSString *recordName = dict[@"recordName"];
            if (dict[@"imageName"]) {
                NSLog(@"imageName: %@ recordName: %@", imageName, recordName);
            }
        }
    }
    
}

- (void)setControlsStatus {
    self.titleTextField.userInteractionEnabled = _isEdit;
    self.textView.userInteractionEnabled = _isEdit;
    self.collectionView.userInteractionEnabled = _isEdit;
}


- (void)initData {
    _isEdit = _manuscriptModel==nil ? YES:NO;
    _attachmentArray = [NSMutableArray array];
    if (_manuscriptModel) {
        _scriptTitle = _manuscriptModel.scriptTitle;
        _scriptContent = _manuscriptModel.scriptContent;
        NSArray *attachsArray = _manuscriptModel.attachmentArray;
        for (int i = 0; i < attachsArray.count ; i ++) {
            NSDictionary *dict = attachsArray[i];
            AttachmentModel *model = [[AttachmentModel alloc] init];
            model.isEdit = _isEdit;
            model.index = i;
            NSString *type = dict[@"AttachmentTyp"];
            if ([type isEqualToString:AttachmentTypeNo]) {
                model.attachmentType = AttachmentTypeNo;
                model.imageName = @"";
                model.recordName = @"";
            }
            
            if ([type isEqualToString:AttachmentTypeImage]) {
                model.attachmentType = AttachmentTypeImage;
                NSString *imageName = dict[@"imageName"];
                if (imageName) {
                    model.imageName = imageName;
                }
                model.recordName = @"";
            }
            
            if ([type isEqualToString:AttachmentTypeRecord]) {
                model.attachmentType = AttachmentTypeRecord;
                NSString *recordName = dict[@"recordName"];
                if (recordName) {
                    model.recordName = recordName;
                }
                model.imageName = @"";
            }
            [_attachmentArray addObject:model];
        }
        
    } else {
        for (int i = 0; i < 6; i++) {
            AttachmentModel *model = [[AttachmentModel alloc] init];
            model.isEdit = _isEdit;
            model.attachmentType = AttachmentTypeNo;
            model.imageName = @"";
            model.recordName = @"";
            model.index = i;
            [_attachmentArray addObject:model];
        }
        _manuscriptModel = [[ManuscriptModel alloc] init];
        _manuscriptModel.isSendToServer = @"0";
    }
}


//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
// 图片解码
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}
#pragma mark ----UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark ----UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.holderLabel.hidden = YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark -----UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _attachmentArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttachmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttachmentCell" forIndexPath:indexPath];
    AttachmentModel *model = _attachmentArray[indexPath.row];
    cell.model = model;
    return cell;
    
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, itemWidth);
}
#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.titleTextField resignFirstResponder];
    [self.textView resignFirstResponder];
    AttachmentModel *attachmentModel = _attachmentArray[indexPath.row];
    _attachmentIndex = attachmentModel.index;
    [self pickAnAttachment];
}

-(void)pickAnAttachment{
    [self.textView resignFirstResponder];
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", @"添加录音", nil];
    }
    [_actionSheet showInView:self.view];
}

#pragma mark ----UIActionSheetDelegate
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"%i",(int)buttonIndex);
    // 相册
    if (buttonIndex == 0) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    }
    // 拍照
    if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"from camera");
            _imagePicker=[[UIImagePickerController alloc]init];
            _imagePicker.delegate=self;
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePicker.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
        
    }
    
    //添加录音
    if (buttonIndex == 2) {
        [self showRecoderList];
    }
    
    
}


// 成功获得 录音模型
- (void)successGetRecordFile:(NSNotification *)notification{
    NSString *recordName = notification.userInfo[@"recordName"];
    // 更新附件模型
    for (AttachmentModel *model  in _attachmentArray) {
        if (model.index == _attachmentIndex) {
            model.recordName = recordName;
            model.attachmentType = AttachmentTypeRecord;
        }
    }
    [self.collectionView reloadData];
}


- (void)showRecoderList {
    QMManuscriptAMRListViewController *vc = [[QMManuscriptAMRListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma  mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //写入到本地相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }
    //压缩图片
    image = [self imageCompressForWidth:image targetWidth:480];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    //  设置日期转换格式
    df.dateFormat = @"yyyyMMddHHmmss";
    NSDate *date = [NSDate date];
    NSString *imageName = [NSString stringWithFormat:@"image_%@.png",[df stringFromDate:date]];
    [self saveImage:image withName:imageName];
    [self successGetPhotoWithImageName:imageName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 成功获得图片
- (void)successGetPhotoWithImageName:(NSString *)imageName {
    //更新附件模型
    for (AttachmentModel *model in _attachmentArray) {
        if (model.index == _attachmentIndex) {
            model.imageName = imageName;
            model.attachmentType = AttachmentTypeImage;
        }
    }
    [self.collectionView reloadData];
}

//压缩图片
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


// 保存图片到本地
-(void)saveImage:(UIImage *)tempImage withName:(NSString *)imageName{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData=UIImagePNGRepresentation(tempImage);
        NSString *fullPath=[NSString stringWithFormat:@"%@/Documents/Images/%@",NSHomeDirectory(),imageName];
        [imageData writeToFile:fullPath atomically:YES];
        NSLog(@"写入沙盒成功");
    });
    
}



@end
