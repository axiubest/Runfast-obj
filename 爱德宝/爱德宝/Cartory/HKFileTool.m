//
//  HKFileTool.m
//  我的百思
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "HKFileTool.h"

@implementation HKFileTool
+(NSString *)hk_handelFileSize:(NSInteger)fileSize{
    CGFloat result;
    if (fileSize>1024*1024) {
        //M
        result = fileSize/(1024*1024*1.0);
        return [NSString stringWithFormat:@"%.1fM",result];
    }else if(fileSize>1024){
        //KB
        result = fileSize/1024.0;
        return [NSString stringWithFormat:@"%.1fKB",result];
    }else {
        
        return [NSString stringWithFormat:@"%ldB",fileSize];
    }
}
+(void)hk_removeFile:(NSString *)filePath containSelf:(BOOL)isContainSelf complete:(void (^)())complete{
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isExist) {
        return;
        NSException *exception = [NSException exceptionWithName:@"删除文件失败" reason:@"文件不存在" userInfo:nil];
        [exception raise];
    }
    //filePath是文件,不是目录
    if (!isDirectory||isContainSelf) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [mgr removeItemAtPath:filePath error:nil];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete();
                }
            });
        });
        
    }
    //filePath是目录不是文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = [mgr contentsOfDirectoryAtPath:filePath error:nil];
        for (NSString *path in paths) {
            NSString *fullPath = [filePath stringByAppendingPathComponent:path];
            [mgr removeItemAtPath:fullPath error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    });

}
+(void)hk_getFileSize:(NSString *)filePath complete:(void (^)(NSInteger))complete{
    NSFileManager *mgr = [NSFileManager defaultManager];
    //判断文件是否存在
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isExist) {
        NSException *exception = [NSException exceptionWithName:@"获取文件大小失败" reason:@"文件不存在" userInfo:nil];
        [exception raise];
    }
    //filePath不是目录是文件
    if (!isDirectory) {
        NSDictionary *dic = [mgr attributesOfItemAtPath:filePath error:nil];
        if (complete) {
            complete(dic.fileSize);
        }
        return;
    }
    //filePath是目录
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = [mgr subpathsAtPath:filePath];
        NSInteger size = 0;
        for (NSString *subPath in paths) {
            NSString *path = [filePath stringByAppendingPathComponent:subPath];
            
            BOOL direcoty;
            BOOL exist = [mgr fileExistsAtPath:path isDirectory:&direcoty];
            if (direcoty||!exist) continue;
            
            //隐藏文件夹
            if ([filePath containsString:@".DS"]) continue;
            
            
            NSDictionary *dic = [mgr attributesOfItemAtPath:path error:nil];
            size += dic.fileSize;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(size);
            }
        });
 
    });
}
@end
