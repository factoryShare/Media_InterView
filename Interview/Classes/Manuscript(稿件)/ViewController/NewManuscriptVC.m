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
#import "QMRecorderListViewController.h"
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
    _isEdit = _manuscriptModel==nil ? YES:NO;
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
}

- (void)setControlsStatus {
    self.titleTextField.userInteractionEnabled = _isEdit;
    self.textView.userInteractionEnabled = _isEdit;
    self.collectionView.userInteractionEnabled = _isEdit;
}


- (void)initData {
    
    if (self.manuscriptModel) {
        _isEdit = NO;
    } else {
        _isEdit = YES;
    }
    
    _attachmentArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        AttachmentModel *model = [[AttachmentModel alloc] init];
        model.isEdit = _isEdit;
        model.attachmentType = AttachmentTypeNo;
        model.image = nil;
        model.amrPath = nil;
        model.index = i;
        [_attachmentArray addObject:model];
    }
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

// 成功获得图片
- (void)successGetPhoto:(UIImage *)image {
    //更新附件模型
    for (AttachmentModel *model in _attachmentArray) {
        if (model.index == _attachmentIndex) {
            model.image = image;
            model.attachmentType = AttachmentTypeImage;
        }
    }
    [self.collectionView reloadData];
}

- (void)showRecoderList {
    QMRecorderListViewController *listVC = [[QMRecorderListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}

// 成功获得录音
- (void)successGetRecord:(NSString *)recordPath {
    
}


#pragma  mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //压缩图片
        image = [self imageCompressForWidth:image targetWidth:480];
        //写入到本地相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self successGetPhoto:image];
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




@end
