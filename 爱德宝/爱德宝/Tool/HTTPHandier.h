//
//  HTTPHandier.h
//  AFNetWorking封装
//
//  Created by mac on 15/12/20.
//  Copyright © 2015年 XIU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPHandier : NSObject

+(void)getDataByString:(NSString *)urlString WithBodyString:(NSString *)bodyString WithDataBlock:(void(^)(id responceObject))dataBlock;





@end
