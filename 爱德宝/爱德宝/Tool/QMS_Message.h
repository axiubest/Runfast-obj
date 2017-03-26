//
//  QMS_Message.h
//  CHISLIM
//
//  Created by XIUDeveloper on 2016/12/3.
//  Copyright © 2016年 XIU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMS_Message : NSObject
+(void)messageHttpWithNumber:(NSString *)number verification:(NSString *)verifiCode block:(void(^)(BOOL isOK))block;

@end
