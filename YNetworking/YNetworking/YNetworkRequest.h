//
//  YNetworkRequest.h
//  YNetworking
//
//  Created by osnail on 2018/9/27.
//  Copyright © 2018 PH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNetworkHelper.h"


@interface YNetworkRequest : NSObject

@property (nonatomic, assign) YRequestType requestType;
/// HTTPHeaderField
@property (nonatomic, strong) NSDictionary *requestHeaderField;
/// 请求使用json格式 默认json
@property (nonatomic, assign) BOOL requestSerializerJSON;
/// 返回jsonh格式  默认json
@property (nonatomic, assign) BOOL responseSerializerJSON;
/// 请求超时时间
@property (nonatomic, assign) NSTimeInterval timeoutTime;
/// 无法连接网的重试次数
@property (nonatomic) int retryTimes;
/// 过几秒后重试
@property (nonatomic) int intervalInSeconds;
/// BDEBUG 状态下是否显示打印
@property (nonatomic) BOOL showLog;

/**
 普通请求通用方法

 @param method 请求方式
 @param url 请求的url
 @param parameters 请求参数
 @param handlerBlock 请求的回调
 */
-(void)requestTypeMethod:(YRequestType )method url:(NSString *)url
              parameters:(id)parameters
                 handler:(YHandlerBlock)handlerBlock;

/**
 *  上传单/多张图片
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param handlerBlock 请求的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(YHttpProgress)progress
                                           handler:(YHandlerBlock)handlerBlock;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param handlerBlock 请求的回调(回调参数filePath:文件的路径)
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(YHttpProgress)progress
                                        handler:(YHandlerBlock)handlerBlock;




@end


