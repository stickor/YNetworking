//
//  ViewController.m
//  YNetworking
//
//  Created by onsail on 2018/9/28.
//  Copyright © 2018 Y. All rights reserved.
//

#import "ViewController.h"
#import "YNetworkRequestBase.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YNetworkRequestBase requestUrl:@"" requestMethod:YRequestTypeGET param:@{} andhandler:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        
    }];
    
    
}


@end
