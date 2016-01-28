//
//  ViewController.m
//  WMImagePickerDemo
//
//  Created by wangwendong on 16/1/27.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import "ViewController.h"
#import "WMImagePickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, WMImagePickerViewControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)albumClicked:(id)sender {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (IBAction)cameraClicked:(id)sender {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.showsCameraControls = YES;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)setupDidLoad {
    // ImagePickerController
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.view.frame = [UIScreen mainScreen].bounds;
    _imagePickerController.delegate = self;
    // _imagePickerController.allowsEditing = NO;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        WMImagePickerViewController *cutVC = [[WMImagePickerViewController alloc] initWithNibName:@"WMImagePickerViewController" bundle:nil];
        cutVC.editImage = original;
        cutVC.sourceType = picker.sourceType;
        cutVC.delegate = self;
        
        [picker pushViewController:cutVC animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WMImagePickerViewControllerDelegate

- (void)wmImagePickerViewControllerDidPickImage:(UIImage *)image {
    if (image) {
        _resultImageView.image = image;
    }
}

@end
