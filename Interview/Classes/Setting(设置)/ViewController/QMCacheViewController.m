//
//  QMCacheViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/22.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMCacheViewController.h"

#import "QMRecorderDBManager.h"

#import "QMManuscriptDBManager.h"

@interface QMCacheViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *uselabel;

@property (weak, nonatomic) IBOutlet UILabel *freeLable;
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
@end

@implementation QMCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查看缓存";
 
    [self getFreeDiskspace];
}

- (IBAction)clearAllRercorderBtn:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清空缓存会删除所有录音稿件及采访策划" message: nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert setAlertViewStyle:(UIAlertViewStyleDefault)];
    
//    alert.delegate = self;
    
    
    [alert show];

}

/**
 *  计算存储空间
 */
- (void)getFreeDiskspace {
    float totalSpace;
    float totalFreeSpace;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    NSArray *paths12 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths12 objectAtIndex:0];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];

//        self.uselabel.text = [NSString stringWithFormat:@"%.3fGB",(((totalSpace/1024.0f)/1024.0f/1024.0f) - ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f)];
        
        self.uselabel.text = [NSString stringWithFormat:@"%.3fMB",[self folderSizeAtPath:documentsDirectory]];
        
        self.freeLable.text = [NSString stringWithFormat:@"%.3fGB",(((totalFreeSpace/1024.0f)/1024.0f)/1024.0f)];
        self.totleLabel.text = [NSString stringWithFormat:@"%dGB",(int)((totalSpace/1024.0f)/1024.0f/1024.0f)];
        
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
//        NSLog(@"Memory Capacity of %f GB with %f GB Free memory available.", ((totalSpace/1024.0f)/1024.0f/1024.0f), ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f);
    } else {
        QMLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %@", [error domain], [error code]);
    }
//    return totalFreeSpace;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        NSString *extension1 = @"amr";
        NSString *extension2 = @"wav";

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            
            if ([[filename pathExtension] isEqualToString:extension1] || [[filename pathExtension] isEqualToString:extension2]) {
                
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            }
        }
        
        QMRecorderDBManager *manager = [QMRecorderDBManager sharedQMRecorderDBManager];
        [manager deleteAllData];
        
        QMManuscriptDBManager *manager2 = [QMManuscriptDBManager sharedQMManuscriptDBManager];
        [manager2 deleteAllData];
        
        [MBProgressHUD showSuccess:@"清空缓存成功"];
    }

}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
