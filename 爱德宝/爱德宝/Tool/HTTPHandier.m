//
//  HTTPHandier.m
//  AFNetWorking封装
//
//  Created by mac on 15/12/20.
//  Copyright © 2015年 XIU. All rights reserved.
//

#import "HTTPHandier.h"
#import "AFNetworking.h"
@implementation HTTPHandier

+(void)getDataByString:(NSString *)urlString WithBodyString:(NSString *)bodyString WithDataBlock:(void(^)(id responceObject))dataBlock
{
//    字符串转码
    NSString *string = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:urlString]];
//    创建AFN管理者对象
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];

//    设置请求类别
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
//    根据bodyString判断请求类型
    if (!bodyString) {
//       GET请求
        [manage GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            请求成功 使用block将数据回调给调用本方法的ViewController
            dataBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败%@", error);
        }];
    }else
    {
//      POST请求
        [manage POST:string parameters:[self getDicByBodyString:bodyString] progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            请求成功回调数据
            dataBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败%@", error);

        }];
        
        
    }
    
}


#pragma mark 进行字符串转化为字典的方法（bodyString的转化）
+(NSMutableDictionary *)getDicByBodyString:(NSString *)bodyString
{
    //     新建一个字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    对字符串按照& 进行分割
    NSArray *arrayFirst = [bodyString componentsSeparatedByString:@"&"];
    //    遍历数组进行拆分，将键值对分别取出放到字典里
    for (NSString *str in arrayFirst) {
        //        对每个小字符串按照＝分割
        NSArray *araySecond = [str componentsSeparatedByString:@"="];
        //        放入字典中
        [dic setObject:araySecond[1] forKey:araySecond[0]];
    }
    return dic;
}
@end
