//
//  DYCustomCameraViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/6/10.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "DYCustomCameraViewController.h"
#import "ReactiveCocoa.h"
#import "PBJVision.h"


@interface DYCustomCameraViewController () <PBJVisionDelegate>

@property (strong, nonatomic) UIView *preview;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation DYCustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preview = [[UIView alloc] initWithFrame:CGRectZero];
    self.preview.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 60.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    self.preview.frame = previewFrame;
    self.previewLayer = [[PBJVision sharedInstance] previewLayer];
    self.previewLayer.frame = self.preview.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.preview.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.preview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)resetCapture
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        vision.cameraDevice = PBJCameraDeviceBack;
    } else {
        vision.cameraDevice = PBJCameraDeviceFront;
    }
    vision.cameraMode = PBJCameraModePhoto; // PHOTO: uncomment to test photo capture
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeContinuousAutoFocus;
}

// photo

- (void)visionWillCapturePhoto:(PBJVision *)vision
{
    
}

- (void)visionDidCapturePhoto:(PBJVision *)vision
{
    
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    if (error) {
        // handle error properly
        return;
    }
//    _currentPhoto = photoDict;
//    
//    // save to library
//    NSData *photoData = _currentPhoto[PBJVisionPhotoJPEGKey];
//    NSDictionary *metadata = _currentPhoto[PBJVisionPhotoMetadataKey];
//    [_assetLibrary writeImageDataToSavedPhotosAlbum:photoData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error1) {
//        if (error1 || !assetURL) {
//            // handle error properly
//            return;
//        }
//        
//        NSString *albumName = @"PBJVision";
//        __block BOOL albumFound = NO;
//        [_assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//            if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
//                albumFound = YES;
//                [_assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                    [group addAsset:asset];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Saved!" message: @"Saved to the camera roll."
//                                                                   delegate:nil
//                                                          cancelButtonTitle:nil
//                                                          otherButtonTitles:@"OK", nil];
//                    [alert show];
//                } failureBlock:nil];
//            }
//            if (!group && !albumFound) {
//                __weak ALAssetsLibrary *blockSafeLibrary = _assetLibrary;
//                [_assetLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group1) {
//                    [blockSafeLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                        [group1 addAsset:asset];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Photo Saved!" message: @"Saved to the camera roll."
//                                                                       delegate:nil
//                                                              cancelButtonTitle:nil
//                                                              otherButtonTitles:@"OK", nil];
//                        [alert show];
//                    } failureBlock:nil];
//                } failureBlock:nil];
//            }
//        } failureBlock:nil];
//    }];
//    
//    _currentPhoto = nil;
}


@end
