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
#define getNewMessage         @"life/apthm/view"                                              //最新留言
#define likeMetto                    @"life/apthm/enshrine"                                         //箴言收藏
#define commentLike              @"life/apthm/cmts/favour"                                   //评论点赞
#define LikeMettoList              @"life/user/enshrine"                                            //个人收藏列表
#define getYearsMetto             @"life/apthm/age"                                                 //按年龄获取箴言
#define updataYears                 @"life/user/info/update"                                       //更新年龄
#define getPersonMetto            @"life/user/apthms"                                               //个人箴言uid
#define delMetto                       @"/life/user/apthms/del"                                        //箴言删除
#define delMessage                   @"/life/user/cmts/del"                                            //评论删除
#define conReport                     @"/life/user/report"                                                 //举报
#endif /* API_h */
