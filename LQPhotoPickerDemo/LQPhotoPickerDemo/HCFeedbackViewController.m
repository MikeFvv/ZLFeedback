//
//  HCFeedbackViewController.m
//  LQPhotoPickerDemo
//
//  Created by 朱乐乐 on 2017/8/4.
//  Copyright © 2017年 李庆. All rights reserved.
//
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度

#import "HCFeedbackViewController.h"


@interface HCFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txView;

@end

@implementation HCFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LQPhotoPicker_superView = _hcView;
    self.txView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.txView.layer.borderWidth = 1;
    self.recordView = [LVRecordView recordView];
    [self.view addSubview: self.recordView];
    self.recordView.frame = CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH, 150);
    self.LQPhotoPicker_imgMaxCount = 1;
    
    [self LQPhotoPicker_initPickerView];
    [self LQPhotoPicker_updatePickerViewFrameY:200];
    
    self.LQPhotoPicker_delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
