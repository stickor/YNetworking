//
//  YNetworkRequestBase.h
//  YNetworking
//
//  Created by onsail on 2018/9/27.
//  Copyright © 2018  All rights reserved.
//


#import "YNetworkRequest.h"

/** 接口前缀-开发服务器*/
UIKIT_EXTERN NSString *const kBaseUrl;

@interface YNetworkRequestBase : NSObject

// denglu ndsjkfhk;sadhfk;dsja;
+(void)requestUrl:(NSString *)url requestMethod:(YRequestType)method param:(NSDictionary *)aParam andhandler:(YHandlerBlock)handlerBlock;


@end


