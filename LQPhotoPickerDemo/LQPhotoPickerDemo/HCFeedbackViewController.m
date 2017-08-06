//
//  HCFeedbackViewController.m
//  LQPhotoPickerDemo
//
//  Created by 朱乐乐 on 2017/8/4.
//  Copyright © 2017年 李庆. All rights reserved.
//
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度
#define MAX_LIMIT_NUMS     10

#import "HCFeedbackViewController.h"
#import "FBNetManager.h"

@interface HCFeedbackViewController ()<LQPhotoPickerViewDelegate>{
    
    NSString *myText;
    NSString *myContact;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextView *txView;

@property (weak, nonatomic) IBOutlet UILabel *textNumberLabel;

@end

@implementation HCFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.LQPhotoPicker_superView = _hcView;
    self.txView.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] CGColor];
    self.txView.layer.borderWidth = 1;
    self.recordView = [LVRecordView recordView];
    [self.view addSubview: self.recordView];
    self.recordView.frame = CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH, 150);
    self.LQPhotoPicker_imgMaxCount = 1;
    
    [self LQPhotoPicker_initPickerView];
    [self LQPhotoPicker_updatePickerViewFrameY:200];
    
    self.LQPhotoPicker_delegate = self;
}
- (void)viewTapped{
    [self.view endEditing:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textNumberLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    if (![self checkInput]) {
        return;
    }
    [self submitToServer];
}
#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    
    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    //大图数据
    NSMutableArray *bigImageDataArray = [self LQPhotoPicker_getBigImageDataArray];
    
    //小图数组
    NSMutableArray *smallImageArray = [self LQPhotoPicker_getSmallImageArray];
    
    //小图数据
    NSMutableArray *smallImageDataArray = [self LQPhotoPicker_getSmallDataImageArray];
    NSLog(@"%@++%@", _phoneTF.text,_txView.text);
    NSData *imgData = nil;
    if (bigImageArray.count == 0) {
            }else{
        imgData = bigImageDataArray[0];
    }
    
    NSString *recoStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"rPath"];
    NSData *voiceData = [NSData dataWithContentsOfFile: recoStr];
    
    NSString *url = @"https://www.pigo-tech.com/feedback/postFeedback.php";
    
    NSLog(@"录音文件地址%@",recoStr);
    NSString *voiceN = [NSString stringWithFormat:@"voice%@",[self getCurrentTimestamp]];
   NSString *imgN = [NSString stringWithFormat:@"image%@",[self getCurrentTimestamp]];
    
    [FBNetManager postUploadWithUrl:url myText:myText myContact:myContact voiceFileData:voiceData voiceFileName:voiceN voiceFileType:@"audio/wav" andImgFileData:imgData imgFileName:imgN imgFileType:@"image/png" success:^(id responseObject) {
        NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"22222  %@",s);
    } fail:^{
        NSLog(@"hahah");
    }];

    
}
//获取当前时间的时间戳
-(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

- (BOOL)checkInput{
    if (_phoneTF.text.length == 0) {
        //MBhudText(self.view, @"请添加记录备注", 1);
        // 提示 手机号必填
        myContact = @"";
        return NO;
    }else{
        myContact = _phoneTF.text;
    }
    if (_txView.text.length == 0) {
        myText = @"";
    }else{
        myText = _txView.text;
    }
    
    return YES;
}

@end
