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
+ (void)postUploadWithUrl:(NSString *)urlStr fileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;
@end
