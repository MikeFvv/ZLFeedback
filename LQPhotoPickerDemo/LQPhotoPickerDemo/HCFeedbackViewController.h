//
//  HCFeedbackViewController.h
//  LQPhotoPickerDemo
//
//  Created by 朱乐乐 on 2017/8/4.
//  Copyright © 2017年 李庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPhotoPickerViewController.h"
#import "LVRecordView.h"


@interface HCFeedbackViewController : LQPhotoPickerViewController<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *hcView;
//@property (weak, nonatomic) IBOutlet LVRecordView *recordView;
@property (nonatomic, strong) LVRecordView *recordView;
@end
