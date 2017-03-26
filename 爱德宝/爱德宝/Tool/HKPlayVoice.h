//
//  HKPlayVoice.h
//  CHISLIM
//
//  Created by Mac on 17/2/15.
//  Copyright © 2017年 XIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKPlayVoice;
@interface HKPlayVoice : NSObject
+(HKPlayVoice *)playVoiceManager;
//语音播报
- (void)VoiceAnnouncements:(NSString *)str;
- (void)playVoiceStr:(NSString *)str rate:(CGFloat)rate;
- (void)playDistace:(CGFloat)distance totalSeconds:(NSInteger)seconds;

//清空当前距离
- (void)clearPlayVoice;


//处理每公里的配速(第1公里配速，第2公里配速。。。。。。)
@property (nonatomic,strong)NSString *averagePace;

@end
