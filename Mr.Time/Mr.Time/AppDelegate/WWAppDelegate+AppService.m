//
//  WWAppDelegate+AppService.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWAppDelegate+AppService.h"
#import "API.h"

@implementation WWAppDelegate (AppService)

- (void)loadWechatLoginInformation:(NSString *)code {
    [XMCenter sendRequest:^(XMRequest *request) {
        request.server = AppApi;
        request.api = userLogin;
        request.parameters = @{@"code": code};
        request.httpMethod = kXMHTTPMethodGET;
    } onSuccess:^(id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatLoginSucess" object:responseObject];
    } onFailure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatLoginFailure" object:nil];
    }];
}

@end
