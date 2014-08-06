//
//  CTItemModel.h
//  CameraTask
//
//  Created by Vencoo on 14-8-5.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTItemModel : NSObject

@property (nonatomic) NSString *itemNo;//编号
@property (nonatomic) NSString *name;//名称
@property (nonatomic) NSInteger type;//类型
@property (nonatomic) float size;//大小
@property (nonatomic) float length;//视频或者录音长度
@property (nonatomic) NSDate *date;//创建时间

@end
