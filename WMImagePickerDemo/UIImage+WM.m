//
//  UIImage+WM.m
//  WMImagePickerDemo
//
//  Created by wangwendong on 16/1/28.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import "UIImage+WM.h"

@implementation UIImage (WM)

- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    frame.origin.x *= scale;
    frame.origin.y *= scale;
    frame.size.width *= scale;
    frame.size.height *= scale;
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return result;
}

@end
