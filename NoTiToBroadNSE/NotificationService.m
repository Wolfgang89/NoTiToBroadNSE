//
//  NotificationService.m
//  NoTiToBroadNSE
//
//  Created by WGPawn on 2021/11/16.
//

#import "NotificationService.h"
#import "PGAudioManager.h"


@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    if ( @available(iOS 12.1, *)) {

//        if ( @available(iOS 15.0, *)) {

        // 接口取出base64的字符串。转化成mp3文件， 设置UNNotificationSoundName。
        
        NSString * base64Str = @"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";
        
        NSData * baseData = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
        
//    #To Do 替换你的bundle id NSE bundle id，app group等。
        
        __block double timegap  = 0;
        
        NSString *sound = [PGAudioManager.sharedInstance getViceNameWith:baseData audioDuration:^(float dur) {
             timegap = dur;
        }];
     
        self.bestAttemptContent.sound = [UNNotificationSound soundNamed:sound];
        self.contentHandler(self.bestAttemptContent);
        ///   播放完成在继续下一条
        [NSThread sleepForTimeInterval:timegap];
            
        
    }else{
        
        //  使用系统的文字转语音播报
        [PGAudioManager.sharedInstance speechWalllentMessage:@"某某某收款多少元"];
        
        PGAudioManager.sharedInstance.finshBlock = ^{
            // 播报完成  开始弹出本地通知栏
            self.contentHandler(self.bestAttemptContent);
        };
        
        // 在语音文件30s 以内没用拿到时， 在serviceExtensionTimeWillExpire 处理播放一段默认语音
        
    }
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end