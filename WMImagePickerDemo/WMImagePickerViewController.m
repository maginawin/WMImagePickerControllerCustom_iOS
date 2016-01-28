//
//  WMImagePickerViewController.m
//  WMImagePickerDemo
//
//  Created by wangwendong on 16/1/27.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import "WMImagePickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+WM.h"

@interface WMImagePickerViewController ()
@property (weak, nonatomic) IBOutlet UIView *cutView;
@property (weak, nonatomic) IBOutlet UIView *moveView;
@property (weak, nonatomic) IBOutlet UIImageView *originImageView;

@property (nonatomic) CGFloat lastScale;

@end

@implementation WMImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDidLoad];
}

- (IBAction)cancelClicked:(id)sender {
    if (_sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)confirmClicked:(id)sender {
    // Cut Image
    if (_editImage) {
        CGRect rect = _moveView.frame;
        CGFloat diffY = _originImageView.transform.ty;
        rect.origin.y -= diffY;
//        UIImage *cutImage = [_editImage imageByScalingAndCroppingForSize:_moveView.frame.size];
        
        UIImage *cutImage = [_editImage captureView:_originImageView frame:rect];
//        UIImage *cutImage = [_editImage crop:_moveView.frame];
        
        if ([_delegate respondsToSelector:@selector(wmImagePickerViewControllerDidPickImage:)]) {
            [_delegate wmImagePickerViewControllerDidPickImage:cutImage];
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - ------- Private -------

- (void)setupDidLoad {
    _moveView.layer.borderColor = [UIColor orangeColor].CGColor;
    _moveView.layer.borderWidth = 2.f;
    _moveView.layer.backgroundColor = [UIColor clearColor].CGColor;

    // Pan in origin image view
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(originImageViewPan:)];
    [self.view addGestureRecognizer:pan];
    
    // Pinch in origin image view
    _lastScale = 1.f;
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(originImageViewPinch:)];
    // 暂时不用
//    [self.view addGestureRecognizer:pinch];
    
    _originImageView.image = _editImage;
}

- (void)originImageViewPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    
    if (point.y != 0) {
        CGAffineTransform transform = CGAffineTransformTranslate(_originImageView.transform, 0, point.y);
        
        
        CGFloat maxDiffY = _moveView.frame.origin.y;
        int actualY = round(transform.ty);
        if (abs(actualY) <= maxDiffY ) {
            [UIView animateWithDuration:.1f animations:^ {
                _originImageView.transform = transform;
            }];
        }
    }
    
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)originImageViewPinch:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateEnded) {
        _lastScale = 1.f;
        
        return;
    }
    
    CGFloat scale = 1.f - (_lastScale - pinch.scale);
    CGAffineTransform currentTransform = _originImageView.transform;
    CGAffineTransform newTransfrom = CGAffineTransformScale(currentTransform, scale, scale);
    
    _originImageView.transform = newTransfrom;
    
    _lastScale = pinch.scale;
}


@end
