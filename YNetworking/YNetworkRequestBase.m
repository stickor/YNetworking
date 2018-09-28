//
//  YNetworkRequestBase.m
//  YNetworking
//
//  Created by onsail on 2018/9/27.
//  Copyright © 2018  All rights reserved.
//

#import "YNetworkRequestBase.h"


#if DEBUG
NSString *const kBaseUrl = @"https://www.baidu.com";
#else
NSString *const kBaseUrl = @"https://www.baidu.com";
#endif

@implementation YNetworkRequestBase

+(void)requestUrl:(NSString *)url requestMethod:(YRequestType)method param:(NSDictionary *)aParam andhandler:(YHandlerBlock)handlerBlock
{
    YNetworkRequest *request = [YNetworkRequest new];
    //request.requestHeaderField = @{};
    //request.requestSerializerJSON = YES;
//    __weak __typeof(self)weakSelf = self;
    [request requestTypeMethod:method url:[NSString stringWithFormat:@"%@%@",kBaseUrl,url] parameters:aParam handler:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (anError == nil && aResponseObject != nil) {
            handlerBlock(aResponseObject,anError);
        }else{
            [YNetworkRequestBase errorActionWithErrror:anError andhandler:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
                handlerBlock(nil,anError);
            }];
        }
    }];
}

+(void)errorActionWithErrror:(NSError *)error andhandler:(YHandlerBlock)handlerBlock
{
    /// 和后台约定的指定code码比如：-99 token失效
    if (error.code == -99) {
        NSLog(@"跳转到登录");
        return;
    }else{
        handlerBlock(nil,error);
    }
    
}


@end
