
#import <Foundation/Foundation.h>
#import "InvitationData.h"

@protocol InvitationDelegate<NSObject>

@optional

/**
 * 唤醒时获取h5页面动态参数（如果是渠道链接，渠道编号会一起返回）
 * @param appData 动态参数对象
 */
- (void)getWakeUpParams:(nullable InvitationData *)appData;

@end

@interface InvitationSDK : NSObject

/**
 * 获取sdk当前版本号
 */
+ (NSString *_Nullable)sdkVersion;


/**
 * SDK单例
 */
+(instancetype _Nullable)defaultManager;


///-------------
/// @name 初始化
///-------------

/**
 * 初始化Invitation SDK
 * ***调用该方法前，需在Info.plist文件中配置键值对***
 
 <key>com.Invitation.APP_KEY</key>
 <string>你的appKey</string>
 
 * @param delegate 委托方法所在的类的对象
 */
+(void)initWithDelegate:(id<InvitationDelegate> _Nonnull)delegate;


/**
 * 初始化sdk并传入广告标识符id（可选）
 *
 * @param adid 广告标识符，需用户自己获取并传入，默认为空，传入nil则与初始化方法 initwithDelegate: 一致
 * @param delegate 委托方法所在的类的对象
 * @discussion 1、只有需要使用“广告平台渠道”进行广告效果监测的用户才需调用，2、需开启后台开关，位置："iOS集成"->"iOS应用配置"->"广告平台对接"
 */
+ (void)initWithDelegate:(nullable id<InvitationDelegate>)delegate advertisingId:(NSString *_Nullable)adid;



/**
 * 初始化sdk，并传入广告相关参数
 *
 * @param delegate 委托方法所在的类的对象
 * @param attribution 广告相关参数，如ASA token，idfa等，@{app_ASA_Token:@"your ASA Token"}
 */
+ (void)initWithDelegate:(nullable id<InvitationDelegate>)delegate adsAttribution:(NSDictionary *_Nullable)attribution;


///----------------------
/// @name 获取安装的动态参数
///----------------------

/**
 * 开发者在需要获取用户安装app后由web网页传递过来的”动态参数“（如邀请码、游戏房间号，渠道编号，ASA渠道编号等）时调用该方法
 *
 *
 * @param completedBlock 回调block，在主线程（UI线程）回调
 *
 */
-(void)getInstallParmsCompleted:(void (^_Nullable)(InvitationData*_Nullable appData))completedBlock;


/**
 * 开发者在需要获取用户安装app后由web网页传递过来的”动态参数“（如邀请码、游戏房间号，渠道编号，ASA渠道编号等）时调用该方法,可第一时间返回数据，可在任意位置调用
 *
 * @param timeoutInterval 可设置回调超时时长，单位秒(s)
 * @param completedBlock 回调block，在主线程（UI线程）回调
 *
 */
-(void)getInstallParmsWithTimeoutInterval:(NSTimeInterval)timeoutInterval
                                completed:(void (^_Nullable)(InvitationData*_Nullable appData))completedBlock;



///---------------------
/// @name 一键拉起回调处理
///---------------------

/**
 * 处理 URI schemes
 * @param URL 系统回调传回的URL
 * @return bool URL是否被Invitation识别
 */
+(BOOL)handLinkURL:(NSURL *_Nullable)URL;


/**
 * 处理 通用链接
 * @param userActivity 存储了页面信息，包括url
 * @return bool URL是否被Invitation识别
 */
+(BOOL)continueUserActivity:(NSUserActivity *_Nullable)userActivity;



///--------------
/// @name 统计相关
///--------------


/**
 * 注册量统计
 *
 * 使用Invitation 控制中心提供的渠道统计时，在App用户注册完成后调用，可以统计渠道注册量。
 * 必须在注册成功的时再调用该方法，避免重复调用，否则可能导致注册统计不准
 */
+(void)reportRegister;

/**
 * 渠道效果统计
 *
 * 目前SDK采用定时上报策略，时间间隔由服务器控制
 * e.g.可统计用户支付消费情况,点击次数等
 *
 * @param effectID 效果点ID
 * @param effectValue 效果点值（如果是人民币金额，请以分为计量单位）
 */
-(void)reportEffectPoint:(NSString *_Nonnull)effectID effectValue:(long)effectValue;



@end

