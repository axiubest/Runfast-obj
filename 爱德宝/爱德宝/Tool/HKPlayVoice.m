//
//  HKPlayVoice.m
//  CHISLIM
//
//  Created by Mac on 17/2/15.
//  Copyright © 2017年 XIU. All rights reserved.
//



#import "HKPlayVoice.h"
#import <AVFoundation/AVFoundation.h>




@interface HKPlayVoice()
@property (nonatomic,assign) CGFloat currentDis;
@property (nonatomic,assign) NSInteger currentSecond;
//计算配速用的
@property (nonatomic,assign) CGFloat currentPaceDis;
@end
@implementation HKPlayVoice

+ (HKPlayVoice *)playVoiceManager
{
    static HKPlayVoice *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
-(void)playDistace:(CGFloat)distance totalSeconds:(NSInteger)seconds{
    NSInteger MaxDis = [[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Voice_Time"] length] > 0 ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Voice_Time"] : @"1000"] integerValue];
    
    
    if(distance<=self.currentDis) return;
    CGFloat margin = distance - self.currentDis;
    if(margin>=MaxDis){
        NSString *disStr = [NSString stringWithFormat:@"您跑了%.2f公里",distance/1000];
        NSString *timeStr = [self dealTime:seconds];
        //当前配速
        CGFloat currentPace = ((seconds-self.currentSecond)/margin)*100/6;
        NSLog(@"huangkun--%f",currentPace);
        NSString *paceStr = [NSString stringWithFormat:@"当前配速%.1f分钟每公里",currentPace];
        
        NSString *playStr = [NSString stringWithFormat:@"%@%@%@",disStr,timeStr,paceStr];
        [self VoiceAnnouncements:playStr];
        self.currentDis = distance;
        
        
    }
    CGFloat paceMargin = distance - self.currentPaceDis;
    if (paceMargin>=1000){
        if (!self.averagePace) {
            self.averagePace = [self dealPaceTime:seconds-self.currentSecond];
        }else{
            self.averagePace = [NSString stringWithFormat:@"%@,%@",self.averagePace,[self dealPaceTime:seconds-self.currentSecond]];
        }
        self.currentSecond = seconds;
        self.currentPaceDis = distance;
    }
}

-(NSString *)dealPaceTime:(NSInteger)seconds{
    NSString *str;
    if (seconds<60) {
        str = [NSString stringWithFormat:@"00#%02ld##",(long)seconds];
    }else if (seconds<3600){
        
        str = [NSString stringWithFormat:@"%02ld#%02ld#",seconds/60,seconds%60];
        
    }
    return str;
}

-(NSString *)dealTime:(NSInteger)seconds{
    NSString *str;
    if (seconds<60) {
        str = [NSString stringWithFormat:@"用时%ld秒",(long)seconds];
    }else if (seconds<3600){
        
        str = [NSString stringWithFormat:@"用时%ld分%02ld秒",seconds/60,seconds%60];
        
    }else if (seconds<60*60*24){
        NSInteger h = seconds/(60*60);
        NSInteger m = seconds/60%60;
        NSInteger s = seconds%60;
        str = [NSString stringWithFormat:@"用时%ld小时%02ld分%02ld秒",(long)h,(long)m,(long)s];
    }
    return str;
}

-(int)add:(int)a num2:(int)b{
    return  a+b;
}

#pragma mark 语音播报
- (void)VoiceAnnouncements:(NSString *)str {
    
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc]init];
    
    //设置播报的内容
    
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:str];
    
    //设置语言类别
    
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    utterance.voice = voiceType;
    
    [av speakUtterance:utterance];
}

-(void)playVoiceStr:(NSString *)str rate:(CGFloat)rate{
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc]init];
    
    //设置播报的内容
    
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:str];
    
    //设置语言类别
    
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    utterance.voice = voiceType;
    utterance.rate = rate;
    [av speakUtterance:utterance];
}
-(void)clearPlayVoice{
    self.currentDis = 0;
}
@end
