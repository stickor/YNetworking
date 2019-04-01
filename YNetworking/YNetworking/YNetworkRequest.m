//
//  YNetworkRequest.m
//  YNetworking
//
//  Created by osnail on 2018/9/27.
//  Copyright © 2018 PH. All rights reserved.
//

#import "YNetworkRequest.h"
#import "AFNetworking.h"
@implementation YNetworkRequest


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.requestSerializerJSON = YES;
        self.responseSerializerJSON = YES;
        
#if DEBUG
        self.timeoutTime = 20.0;
        self.retryTimes = 0;
        self.intervalInSeconds = 0;
        self.showLog = YES;
#else
        self.timeoutTime = 30.0;
        self.retryTimes = 1;
        self.intervalInSeconds = 2;
        self.showLog = NO;
#endif
    }
    return self;
}

-(void)requestTypeMethod:(YRequestType)method url:(NSString *)url parameters:(id)parameters handler:(YHandlerBlock)handlerBlock
{
    __weak __typeof(self)weakSelf = self;
    if (![NSURL URLWithString:url]) {
        NSLog(@"url is nil");
        return ;
    }
    //是否允许开启代理
    if (self.unAllowProxy && [self getProxyStatusURL:[NSURL URLWithString:url]]) {
        return;
    }    
    // 是否需要打印
    if (self.showLog) {
        NSLog(@"Request URL is: %@",url);
        NSArray *methodArr = @[@"GET",@"POST",@"PUT",@"PATCH",@"DELETE"];
        NSLog(@"Request Method: %@", methodArr[method]);
        if (parameters) {
            if ([NSJSONSerialization isValidJSONObject:parameters]) {
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"Parameter is: %@",jsonStr);
            }
        }
    }
    if (self.requestHeaderField) {
        [self.requestHeaderField enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            [YNetworkHelper setValue:value forHTTPHeaderField:key];
        }];
    }
    [YNetworkHelper setRequestTimeoutInterval:self.timeoutTime];
    if (self.requestSerializerJSON) {
        [YNetworkHelper setRequestSerializer:YRequestSerializerJSON];
    }else{
        [YNetworkHelper setRequestSerializer:YRequestSerializerHTTP];
    }
    
    [YNetworkHelper requestTypeMethod:method url:url parameters:parameters handler:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.showLog) {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:aResponseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"aResponseObject is: %@",jsonStr);
        }
        if (anError == nil && aResponseObject != nil) {
            // aResponseObject not dictionary
            if (![aResponseObject isKindOfClass:[NSDictionary class]]) {
                NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:@{NSLocalizedDescriptionKey:@"数据格式返回错误!"}];
                handlerBlock(nil, err);
                return;
            }else{
                handlerBlock(aResponseObject,anError);
            }
        }else{
            if (anError.code == NSURLErrorNotConnectedToInternet) {
                if (strongSelf.retryTimes > 0) {
                    strongSelf.retryTimes -= 1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(strongSelf.intervalInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __strong __typeof(weakSelf)strongSelf = weakSelf;
                        [strongSelf requestTypeMethod:method url:url parameters:parameters handler:nil];
                    });
                }else{
                    handlerBlock(aResponseObject,anError);
                    return;
                }
            }else{
                handlerBlock(aResponseObject,anError);
                return;
            }
            
        }
    }];
}

+(__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(YHttpProgress)progress handler:(YHandlerBlock)handlerBlock
{
    return [YNetworkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:^(NSProgress *progres) {
        progress(progres);
    } success:^(id responseObject) {
        handlerBlock(responseObject,nil);
    } failure:^(NSError *error) {
        handlerBlock(nil,error);
    }];
    
}

+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(YHttpProgress)progress handler:(YHandlerBlock)handlerBlock
{
    return [YNetworkHelper downloadWithURL:URL fileDir:fileDir progress:^(NSProgress *progres) {
        progress(progres);
    } success:^(NSString *filePath) {
        handlerBlock(filePath,nil);
    } failure:^(NSError *error) {
        handlerBlock(nil,error);
    }];
}

/// 网络代理验证（防代理抓包）
- (BOOL)getProxyStatusURL:(NSURL *)url {
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)(url), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    
    NSDictionary *settings = proxies[0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        // NSLog(@"没设置代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
}


@end
