//
//  API.h
//  Mr.Time
//
//  Created by steaest on 2017/8/14.
//  Copyright © 2017年 Offape. All rights reserved.
//

#ifndef API_h
#define API_h

#define AppApi                       @"https://soda666.com/"                                        // 测试
#define userLogin                   @"life/oauth2/wx/login"                                         //用户登录
#define postMotto                  @"life/apthm/add"                                                //发表箴言
#define postComment            @"life/apthm/cmts/save"                                       //发表评论
#define getAllMotto                @"life/apthm/list"                                                //获取全部箴言列表
#define getMessageCmt          @"life/apthm/getcmts"                                         //获取评论
#define getNewMessage         @"life/apthm/view"                                              //最新留言
#define getCustomMetto         @"life/apthm/list"                                                  //个人箴言列表
#define likeMetto                    @"life/apthm/enshrine"                                         //箴言收藏
#define commentLike              @"life/apthm/cmts/favour"                                   //评论点赞
#define LikeMettoList              @"life/user/enshrine"                                            //个人收藏列表
#define getYearsMetto             @"life/apthm/age"                                                 //按年龄获取箴言
#define updataYears                 @"life/user/info/update"                                       //更新年龄
#define getPersonMetto            @"life/user/apthms"                                               //个人箴言uid
#endif /* API_h */
