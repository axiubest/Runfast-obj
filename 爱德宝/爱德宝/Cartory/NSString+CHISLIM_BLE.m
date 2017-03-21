//
//  NSString+CHISLIM_BLE.m
//  BuleToothText
//
//  Created by XIUDeveloper on 2016/11/22.
//  Copyright © 2016年 TRY. All rights reserved.
//



#import "NSString+CHISLIM_BLE.h"

//ASCII  "IDchislim" of Dec
/*
 73 68 99 104 105 115 108 105 109
 */
// “EE,p10.5,IDchislim,048,FF”

static const int IDchislim = 886;
static int ASCIINUMBER;

@implementation NSString (CHISLIM_BLE)

+ (NSString *)XIU_BLEStringAppendingHaracteristics:(NSString *)baseString  WithFunc:(NSString *)func {

    
    NSString *i = [self changeToASCII:baseString WithFunc:func];
        
    return [NSString stringWithFormat:@"EE,%@%@,IDchislim,%@,FF", func, baseString,i];

}



//转换成10进制ASCII码
+ (NSString *)changeToASCII:(NSString *)string WithFunc:(NSString *)func{
    
    //    dec of baseString
    
    const char *baseValueChar = [string cStringUsingEncoding:NSASCIIStringEncoding];
    ASCIINUMBER = 0;
    for (int i = 0; i < strlen(baseValueChar); i++) {
        ASCIINUMBER += (int)baseValueChar[i];

    }
    
    
    //    dec of function
    const char *functionChar = [func cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i = 0; i < strlen(functionChar); i++) {
        ASCIINUMBER += (int)functionChar[i];
        
    }
    
    /**********************************************/
    
    // 44 + functionChar ASCII + 44 + baseValueChar ASCII + 44 + 838 + 44
    ASCIINUMBER = ASCIINUMBER + 44 + 44 + IDchislim + 44;
    NSLog(@"%d", ASCIINUMBER);
    //截取16进制后三位不足用0补全????
    
    
//    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",ASCIINUMBER]];
//    NSLog(@"%@", hexString);
    
    NSString *uint16 = [self ToHex:ASCIINUMBER];
    
    
   uint16 =  [uint16 substringFromIndex:uint16.length- 2];

//    NSLog(@"%@", uint16);---------2e;
    //16进制字符串转换成十进制
    NSString *decStr = [NSString stringWithFormat:@"%lu",strtoul([uint16 UTF8String],0,16)];
    if (decStr.length<=1) {
        decStr = [NSString stringWithFormat:@"00%@",decStr];
        return decStr;
    }
    
   decStr = decStr.length <= 2 ? [NSString stringWithFormat:@"0%@",decStr] : decStr;

    return decStr;
}




+ (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

@end
