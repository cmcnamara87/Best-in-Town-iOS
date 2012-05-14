//
//  BiTTodos.h
//  BestInTown
//
//  Created by Craig McNamara on 7/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiTBusiness.h"
@interface BiTTodo : NSObject
@property (nonatomic, assign) int todoId;
@property (nonatomic, assign) int businessId;
@property (nonatomic, strong) BiTBusiness *business;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, strong) NSDate *dateAdded;

+ (void)getTodosForUser:(int)userId 
              onSuccess:(void (^)(NSArray *todos))success 
                failure:(void (^)(NSError *error))failure;

+ (void)addTodoForBusiness:(int)businessId 
                      user:(int)userId 
                 onSuccess:(void (^)(BiTTodo *visit))success 
                   failure:(void (^)(NSError *error))failure;
/*
 id INTEGER AUTO_INCREMENT,
 business_id INTEGER,
 complete BOOL DEFAULT 0,
 date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 user_id INTEGER,
 */
@end
