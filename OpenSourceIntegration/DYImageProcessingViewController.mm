//
//  DYImageProcessingViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/8/2.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

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
}

- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    //将彩色图像转为灰色图像
    cvtColor(image, image_copy, CV_BGR2GRAY);
    
    // invert image
    //bitwise_not(image_copy, image_copy);
    //cvtColor(image_copy, image, CV_BGR2BGRA);
    Mat grad;
    Mat morphKernel = getStructuringElement(MORPH_ELLIPSE, cv::Size(3, 3));
    morphologyEx(image_copy, grad, MORPH_GRADIENT, morphKernel);
    Mat bw;
    //转为二值图像
    threshold(grad, bw, 0.0, 255.0, THRESH_BINARY | THRESH_OTSU);
    // connect horizontally oriented regions
    Mat connected;
    morphKernel = getStructuringElement(MORPH_RECT, cv::Size(9, 1));
    morphologyEx(bw, connected, MORPH_CLOSE, morphKernel);
    
    // find contours
    Mat mask = Mat::zeros(bw.size(), CV_8UC1);
    vector<vector<cv::Point>> contours;
    vector<Vec4i> hierarchy;
    findContours(connected, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    vector<cv::Rect> mrz;
    double r = 0;
    // filter contours
    for(int idx = 0; idx >= 0; idx = hierarchy[idx][0])
    {
        cv::Rect rect = boundingRect(contours[idx]);
        r = rect.height ? (double)(rect.width/rect.height) : 0;
        if ((rect.width > connected.cols * .7) && /* filter from rect width */
            (r > 25) && /* filter from width:hight ratio */
            (r < 36) /* filter from width:hight ratio */
            )
        {
            mrz.push_back(rect);
            rectangle(image_copy, rect, Scalar(0, 255, 0), 1);
        }
        else
        {
            rectangle(image_copy, rect, Scalar(0, 0, 255), 1);
        }
    }
    if (2 == mrz.size())
    {
        // just assume we have found the two data strips in MRZ and combine them
        CvRect r1 = mrz[0];
        CvRect r2 = mrz[1];
        CvRect max = cvMaxRect(&r1, &r2);
        rectangle(image_copy, max, Scalar(255, 0, 0), 2);  // draw the MRZ
        
        vector<cv::Point2f> mrzSrc;
        vector<cv::Point2f> mrzDst;
        
        // MRZ region in our image
        mrzDst.push_back(Point2f((float)max.x, (float)max.y));
        mrzDst.push_back(Point2f((float)(max.x+max.width), (float)max.y));
        mrzDst.push_back(Point2f((float)(max.x+max.width), (float)(max.y+max.height)));
        mrzDst.push_back(Point2f((float)max.x, (float)(max.y+max.height)));
        
        // MRZ in our template
        mrzSrc.push_back(Point2f(0.23f, 9.3f));
        mrzSrc.push_back(Point2f(18.0f, 9.3f));
        mrzSrc.push_back(Point2f(18.0f, 10.9f));
        mrzSrc.push_back(Point2f(0.23f, 10.9f));
        
        // find the transformation
        Mat t = getPerspectiveTransform(mrzSrc, mrzDst);
        
        // photo region in our template
        vector<Point2f> photoSrc;
        photoSrc.push_back(Point2f(0.0f, 0.0f));
        photoSrc.push_back(Point2f(5.66f, 0.0f));
        photoSrc.push_back(Point2f(5.66f, 7.16f));
        photoSrc.push_back(Point2f(0.0f, 7.16f));
        
        // surname region in our template
        vector<Point2f> surnameSrc;
        surnameSrc.push_back(Point2f(6.4f, 0.7f));
        surnameSrc.push_back(Point2f(8.96f, 0.7f));
        surnameSrc.push_back(Point2f(8.96f, 1.2f));
        surnameSrc.push_back(Point2f(6.4f, 1.2f));
        
        vector<Point2f> photoDst(4);
        vector<Point2f> surnameDst(4);
        
        // map the regions from our template to image
        perspectiveTransform(photoSrc, photoDst, t);
        perspectiveTransform(surnameSrc, surnameDst, t);
        // draw the mapped regions
        for (int i = 0; i < 4; i++)
        {
            line(image_copy, photoDst[i], photoDst[(i+1)%4], Scalar(0,128,255), 2);
        }
        for (int i = 0; i < 4; i++)
        {
            line(image_copy, surnameDst[i], surnameDst[(i+1)%4], Scalar(0,128,255), 2);
        }
    }
}


@end
