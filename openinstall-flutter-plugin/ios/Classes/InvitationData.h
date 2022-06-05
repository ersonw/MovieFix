
#import <Foundation/Foundation.h>

extern NSString *const app_Idfa_Id;
extern NSString *const app_ASA_Token;

@interface InvitationData : NSObject<NSCopying>

- (instancetype)initWithData:(NSDictionary *)data
                 channelCode:(NSString *)channelCode;
                

@property (nonatomic,strong) NSDictionary *data;//动态参数
@property (nonatomic,copy) NSString *channelCode;//渠道编号


@end
