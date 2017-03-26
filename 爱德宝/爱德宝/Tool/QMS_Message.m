
//
//  QMS_Message.m
//  CHISLIM
//
//  Created by XIUDeveloper on 2016/12/3.
//  Copyright © 2016年 XIU. All rights reserved.
//

#import "QMS_Message.h"

@implementation QMS_Message
+(void)messageHttpWithNumber:(NSString *)number verification:(NSString *)verifiCode block:(void (^)(BOOL))block{
    NSString *httpUrl = @"http://apis.baidu.com/kingtto_media/106sms/106sms";
    
    NSString *hanHttpArg = [NSString stringWithFormat:@"mobile=%@&content=【凯信通】您的验证码：%@",number,verifiCode];
    NSString *httpArg = [hanHttpArg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:hanHttpArg]];
    NSLog(@"httpArg----%@",httpArg);
    
    [self request: httpUrl withHttpArg: httpArg WithBlock:^(BOOL isOk) {
        if (block) {
            block(isOk);
        }
    }];
}

+(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg WithBlock:(void (^)(BOOL))block{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue:@"467fa36385f73a29f31a6be49a221857" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
           queue: [NSOperationQueue mainQueue]
completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
   if (error) {
       NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
       if (block) {
           block(NO);
       }
   } else {
       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       NSLog(@"HttpResponseCode:%ld", responseCode);
       NSLog(@"HttpResponseBody %@",responseString);
       if ([responseString containsString:@"<message>ok</message>"]) {
           if (block) {
               block(YES);
           }
       }else{
           if (block) {
               block(NO);
           }

       }
   }
}];
}

@end
