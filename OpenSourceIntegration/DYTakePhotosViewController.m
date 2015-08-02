//
//  DYTakePhotosViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/6/15.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "DYTakePhotosViewController.h"
#import "ReactiveCocoa.h"
#import "DYImageProcessingViewController.h"

@interface DYTakePhotosViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *image;

@end

@implementation DYTakePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.takePhotosBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.processImageBtn addTarget:self action:@selector(processPhoto:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)takePhoto:(UIButton *)button
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}


//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.image == nil)
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = self.image;
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)processPhoto:(UIButton *)button
{
    DYImageProcessingViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DYImageProcessingViewController"];
    controller.originImage = self.image;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
