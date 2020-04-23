//
//  ViewController.m
//  CameraPermission
//
//  Created by wanting_cheng on 2020/4/22.
//  Copyright © 2020 wanting_cheng. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.messageTextView.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"AVAuthorizationStatusAuthorized");
            self.messageTextView.text = @"";
            [self.cameraButton setEnabled:YES];
            break;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"AVAuthorizationStatusNotDetermined");
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    NSLog(@"Granted");
                }else {
                    NSLog(@"Not Granted");
                }
            }];
            break;
            
        case AVAuthorizationStatusDenied:
            NSLog(@"AVAuthorizationStatusDenied");
            self.messageTextView.text = @"相機權限已關閉，如要取得更好的服務品質，請至 設定 > 隱私權 > 相機 開啟相機功能";
            [self.cameraButton setEnabled:NO];
            break;
            
        case AVAuthorizationStatusRestricted:
            NSLog(@"AVAuthorizationStatusRestricted");
            self.messageTextView.text = @"相機權限已關閉，如要取得更好的服務品質，請至 設定 > 隱私權 > 相機 開啟相機功能";
            [self.cameraButton setEnabled:NO];
            break;
        default:
            break;
    }
}

- (AVAuthorizationStatus)getMediaTypeVideoStatus {
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

- (IBAction)onCameraClicked:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            NSLog(@"Camera can't use");
        }else {
            [self presentViewController:pickerController animated:YES completion:nil];
        }
    }else{
        NSLog(@"camera no");
    }
}

- (IBAction)onAlbumClicked:(id)sender {
    NSLog(@"onAlbumClicked");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
