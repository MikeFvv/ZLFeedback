//
//  FBNetManager.m
//  LQPhotoPickerDemo
//
//  Created by 朱乐乐 on 2017/7/19.
//  Copyright © 2017年 李庆. All rights reserved.
//

#import "FBNetManager.h"

@implementation FBNetManager


+ (void)postUploadWithUrl:(NSString *)urlStr myText: (NSString *)myText myContact: (NSString *)myContact voiceFileData:(NSData *)voiceFileData voiceFileName:(NSString *)voiceFileName voiceFileType:(NSString *)voiceFileTye andImgFileData:(NSData *)imgFileData imgFileName:(NSString *)imgFileName imgFileType:(NSString *)imgFileTye success:(void (^)(id responseObject))success fail:(void (^)())fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"mytext": myText,
                          @"mycontact": myContact
                          
                          
                          
                          };
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (imgFileData == nil ) {
        
        }else{
            [formData appendPartWithFileData:imgFileData name:@"myphoto" fileName:imgFileName mimeType: imgFileTye];
        }
        if (voiceFileData) {
            [formData appendPartWithFileData:voiceFileData name:@"myvoice" fileName: voiceFileName mimeType: voiceFileTye];

        }
        
        
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
