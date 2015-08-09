//
//  DYImageProcessingViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/8/2.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import <map>
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/imgproc_c.h>
#include <opencv2/imgproc/imgproc.hpp>
#import "DYImageProcessingViewController.h"

using namespace std;
using namespace cv;

@interface DYImageProcessingViewController ()

@end

@implementation DYImageProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self processImage];
}

- (void)processImage
{
    Mat src;
    Mat src_gray;
    RNG rng(12345);
    vector<vector<cv::Point> > contours;
    vector<Vec4i> hierarchy;
    
    src = [self cvMatFromUIImage:self.originImage];
    //将彩色图像转为灰色图像
    cvtColor(src, src_gray, CV_BGR2GRAY);
    //转为二值图像
    Mat bw;
    threshold(src_gray, bw, 50.0, 255.0, CV_THRESH_BINARY_INV);
    
    Mat copy_bw(bw);
    
    // connect horizontally oriented regions
    Mat connected;
    Mat morphKernel = getStructuringElement(MORPH_RECT, cv::Size(27, 1));
    morphologyEx(copy_bw, connected, MORPH_CLOSE, morphKernel);
    
    /// Find contours
    findContours( connected, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
    
    /// Draw contours
    Mat drawing = Mat::zeros( connected.size(), CV_8UC3 );
    
    int maxWidth = 0;
    int maxIndex = 0;

    for( int i = 0; i< contours.size(); i++ )
    {
        cv::Rect rect = boundingRect(contours[i]);
        if (rect.width > maxWidth) {
            maxWidth = rect.width;
            maxIndex = i;
        }
    }
    cv::Rect targetRect = boundingRect(contours[maxIndex]);

    /// Find contours
    findContours( copy_bw, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
    int idNum = 0;
    NSMutableDictionary *numberMap = [NSMutableDictionary dictionaryWithCapacity:18];
    for( int i = 0; i< contours.size(); i++ )
    {
        cv::Rect rect = boundingRect(contours[i]);
        if ((rect.x >= targetRect.x && rect.x <= targetRect.x + targetRect.width) && (rect.y >= targetRect.y)) {
            Scalar color = Scalar( rng.uniform(255, 255), rng.uniform(255,255), rng.uniform(255,255) );
            drawContours( drawing, contours, i, color, 2, 8, hierarchy, 0, cv::Point() );
            idNum++;
            cv::Mat roiImage;
            src(rect).copyTo(roiImage);
            NSInteger number = [self MatchingMethodWithRoiImage:roiImage];
            [numberMap setObject:@(number) forKey:@(rect.x)];
//            UIImage *image = [self UIImageFromCVMat:roiImage];
//            NSString *imageName = [NSString stringWithFormat:@"number_%d", i];
//            NSLog(@"imageName = %@", imageName);
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
    }
    NSString *str = @"";
    NSArray *array = [[numberMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i < array.count; i++) {
        NSLog(@"x=%ld, num=%ld", (long)[array[i] integerValue], (long)[[numberMap objectForKey:array[i]] integerValue]);
        str = [NSString stringWithFormat:@"%@%@",str, [numberMap objectForKey:array[i]]];
    }
    NSLog(@"%@",str);
    //self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.image = [self UIImageFromCVMat:drawing];

}

- (NSInteger)MatchingMethodWithRoiImage:(cv::Mat)roiImage
{
    double minValue = 1000;
    int matchIndex = 0;
    
//    NSLog(@"col = %d, row = %d", roiImage.cols, roiImage.rows);
    
    for (int i = 0; i < 10; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.JPG", i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image == nil) {
            continue;
        }
        Mat templ = [self cvMatFromUIImage:image];
        double colScale = (double)roiImage.cols/(double)templ.cols;
        double rowScale = (double)roiImage.rows/(double)templ.rows;
        double scale = (colScale < rowScale) ? colScale : rowScale;
        if (colScale < 1.0 || rowScale < 1.0) {
            cv::Size dsize = cv::Size((int)(templ.cols*scale),(int)(templ.rows*scale));
            Mat image2 = Mat(dsize, CV_32S);
            resize(templ, image2, dsize);
            templ = image2;
        }

        /// 创建输出结果的矩阵
        int result_cols =  roiImage.cols - templ.cols + 1;
        int result_rows = roiImage.rows - templ.rows + 1;
        
        Mat result;
        result.create( result_cols, result_rows, CV_32FC1 );
        
        /// 进行匹配和标准化
        int match_method = CV_TM_SQDIFF;
        matchTemplate( roiImage, templ, result, CV_TM_SQDIFF );
        normalize( result, result, 0, 1, NORM_MINMAX, -1, Mat() );
        
        /// 通过函数 minMaxLoc 定位最匹配的位置
        double minVal;
        double maxVal;
        cv::Point minLoc;
        cv::Point maxLoc;
        cv::Point matchLoc;
        
        minMaxLoc( result, &minVal, &maxVal, &minLoc, &maxLoc, Mat() );
        
        /// 对于方法 SQDIFF 和 SQDIFF_NORMED, 越小的数值代表更高的匹配结果. 而对于其他方法, 数值越大匹配越好
        if( match_method  == CV_TM_SQDIFF || match_method == CV_TM_SQDIFF_NORMED )
        {
            matchLoc = minLoc;
            if (minVal < minValue) {
                minValue = minVal;
                matchIndex = i;
            }
        }
        else {
            matchLoc = maxLoc;
        }
    }
    return matchIndex;
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (BOOL)saveImage:(UIImage *)image withFileName:(NSString *)imageName
{
    BOOL success = YES;
    NSString *imagePath;
    
    //create directory like .../Documents/URS Account/IdCardImage/
    imagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"image path = %@", imagePath);
    BOOL isDir;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        success = [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (success == NO) {
        NSLog(@"create Directory failed in IdCardImage");
        return success;
    }
    
    NSString *imageFile = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
    success = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageFile options:NSDataWritingAtomic error:nil];
    
    if (success) {
        NSLog(@"image write to file success!");
    } else {
        NSLog(@"image write to file failure!");
    }
    
    return success;
}
@end
