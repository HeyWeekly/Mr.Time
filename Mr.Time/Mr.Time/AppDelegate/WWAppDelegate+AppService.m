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
    NSLog(@"%@",code);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.server = AppApi;
        request.api = userLogin;
        request.parameters = @{@"code": code};
        request.httpMethod = kXMHTTPMethodGET;
    } onSuccess:^(id responseObject) {
        NSLog(@"onSuccess: %@", responseObject);
    } onFailure:^(NSError *error) {
        NSLog(@"onFailure: %@", error);
    }];
}
@end
