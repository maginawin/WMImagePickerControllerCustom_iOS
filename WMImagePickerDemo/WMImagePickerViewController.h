//
//  WMImagePickerViewController.h
//  WMImagePickerDemo
//
//  Created by wangwendong on 16/1/27.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMImagePickerViewControllerDelegate <NSObject>

@optional

- (void)wmImagePickerViewControllerDidPickImage:(UIImage *)image;

@end

@interface WMImagePickerViewController : UIViewController

@property (strong, nonatomic) UIImage *editImage;

@property (nonatomic) UIImagePickerControllerSourceType sourceType;

@property (weak, nonatomic) id<WMImagePickerViewControllerDelegate> delegate;

@end
