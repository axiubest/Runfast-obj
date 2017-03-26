//
//  HKFileTool.h
//  我的百思
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKFileTool : NSObject
/**
 *  获得文件大小
 *
 *  @param filePath 文件路径
 *  @param complete 返回文件大小
 */
+(void)hk_getFileSize:(NSString *)filePath complete:(void (^)(NSInteger fileSize))complete;
/**
 *  删除文件
 *
 *  @param filePath      文件路径
 *  @param isContainSelf 删除文件时候要包涵文件本身
 *  @param complete      
 */
+(void)hk_removeFile:(NSString *)filePath containSelf:(BOOL)isContainSelf complete:(void(^)())complete;
/**
 *  处理文件的大小 将B转变成KB或者M
 *
 *  @return
 */
+(NSString *)hk_handelFileSize:(NSInteger)fileSize;
@end
