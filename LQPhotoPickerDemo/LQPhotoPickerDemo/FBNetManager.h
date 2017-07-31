//
//  FBNetManager.h
//  LQPhotoPickerDemo
//
//  Created by 朱乐乐 on 2017/7/19.
//  Copyright © 2017年 李庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface FBNetManager : NSObject
+ (void)postUploadWithUrl:(NSString *)urlStr myText: (NSString *)myText myContact: (NSString *)myContact voiceFileData:(NSData *)voiceFileData voiceFileName:(NSString *)voiceFileName voiceFileType:(NSString *)voiceFileTye andImgFileData:(NSData *)imgFileData imgFileName:(NSString *)imgFileName imgFileType:(NSString *)imgFileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;
@end
