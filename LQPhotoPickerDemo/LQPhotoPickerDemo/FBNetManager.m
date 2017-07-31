//
//  FBNetManager.m
//  LQPhotoPickerDemo
//
//  Created by 朱乐乐 on 2017/7/19.
//  Copyright © 2017年 李庆. All rights reserved.
//

#import "FBNetManager.h"

@implementation FBNetManager


+ (void)postUploadWithUrl:(NSString *)urlStr fileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id))success fail:(void (^)())fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"mytext":@"hhahhahahh",
                          @"mycontact": @"suibian"
                          
                          
                          
                          };
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.jpeg" withExtension:nil];
//        
//        // 要上传保存在服务器中的名称
//        // 使用时间来作为文件名 2014-04-30 14:20:57.png
//        // 让不同的用户信息,保存在不同目录中
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                // 设置日期格式
//                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//                NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        
        [formData appendPartWithFileData:UIImagePNGRepresentation([UIImage imageNamed:@"锁"]) name:@"myvoice" fileName:@"333.png" mimeType:fileTye];
        [formData appendPartWithFileData:fileData name:@"myphoto" fileName:fileName mimeType:fileTye];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }  
    }];
    
}
@end
