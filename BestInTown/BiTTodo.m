//
//  BiTTodos.m
//  BestInTown
//
//  Created by Craig McNamara on 7/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTTodo.h"
#import "BiTApiController.h"

@implementation BiTTodo
@synthesize todoId, businessId, business, userId, complete, dateAdded;

+ (void)getTodosForUser:(int)userId 
              onSuccess:(void (^)(NSArray *todos))success 
                failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/todos/user_id/%d", userId];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Todos RESPONSE OBJECT %@", responseObject);
        
        success([BiTTodo buildTodosFromData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

+ (void)addTodoForBusiness:(int)businessId 
                       user:(int)userId 
                  onSuccess:(void (^)(BiTTodo *visit))success 
                    failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/todo"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                            [NSNumber numberWithInt:userId], @"user_id",
                            [NSNumber numberWithInt:businessId], @"business_id",
                            nil];
    
    [[BiTApiController sharedApi] postPath:apiPath parameters:params OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Todo RESPONSE OBJECT %@", responseObject);
        
        BiTTodo *todo = [BiTTodo buildTodofromDict:responseObject];
        success(todo);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

/**
 Creates an array of BitBusiness objects for an array of business data
 */
+ (NSArray *)buildTodosFromData:(NSArray *)todosData
{
    NSMutableArray *todosArray = [NSMutableArray array];
    for(NSDictionary *todoData in todosData) {
        
        BiTTodo *todo = [BiTTodo buildTodofromDict:todoData];
        [todosArray addObject:todo];
    }
    
    return [todosArray copy];
}


/**
 Creates a BitVisit object for a Dictionary of data
 */
+ (BiTTodo *)buildTodofromDict:(NSDictionary *)todoData
{
    BiTTodo *todo = [[BiTTodo alloc] init];
    
    todo.todoId = [(NSNumber*)[todoData objectForKey:@"id"] intValue];
    todo.businessId = [(NSNumber*)[todoData objectForKey:@"business_id"] intValue];
    todo.userId = [(NSNumber*)[todoData objectForKey:@"user_id"] intValue];
    if([todoData objectForKey:@"business"] != [NSNull null]) {
        NSLog(@"wtf %@", [todoData objectForKey:@"business"]);
        todo.business = [BiTBusiness buildBusinessfromDict:[todoData objectForKey:@"business"]];
    }
    

    todo.complete = [(NSNumber*)[todoData objectForKey:@"complete"] boolValue];
    todo.dateAdded = [todoData objectForKey:@"date_added"];
    
    return todo;
}


@end
