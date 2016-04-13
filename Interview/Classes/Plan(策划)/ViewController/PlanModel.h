//
//  PlanModel.h
//  Interview
//
//  Created by fei on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"


// EventTitle, EventDate,OccurTime,ReportType,MainDesign,WorkAttendance,SendPackets,EventDescribe
@interface PlanModel : NSObject
@property (nonatomic, copy) NSString *EventTitle;
@property (nonatomic, copy) NSString *EventDate;
@property (nonatomic, copy) NSString *OccurTime;
@property (nonatomic, copy) NSString *ReportType;
@property (nonatomic, copy) NSString *MainDesign;
@property (nonatomic, copy) NSString *WorkAttendance;
@property (nonatomic, copy) NSString *SendPackets;
@property (nonatomic, copy) NSString *EventDescribe;
@property (nonatomic, assign) BOOL isSendToServer;
@end

