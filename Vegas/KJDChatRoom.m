//
//  KJDChatRoom.m
//  Vegas

#import "KJDChatRoom.h"
#import <Firebase/Firebase.h>
#import "KJDChatRoomViewController.h"


@implementation KJDChatRoom

-(instancetype)initWithUser:(KJDUser *)user{
    self=[super init];
    if (self) {
        _user=user;
        _messages=[[NSMutableArray alloc]init];
    }
    return self;
}

-(instancetype)init{
    return [self initWithUser:self.user];
}

-(void)fetchMessagesFromCloud:(FDataSnapshot *)snapshot withBlock:(void (^)(NSMutableArray *messages))completionBlock{
   
    NSMutableArray *messagesArray=[[NSMutableArray alloc]init];
   if ([snapshot.value isKindOfClass:[NSArray class]]) {
      [messagesArray addObjectsFromArray:snapshot.value];
//      NSLog(@"snapshot contains array : %@", snapshot.value);
   }
   else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
      [messagesArray addObject:snapshot.value];
//      NSLog(@"snapshot contains dict : %@", snapshot.value);
   }
   else if ([snapshot.value isKindOfClass:[NSString class]]){
//      NSLog(@"snapshot contains string : %@", snapshot.value);
      [messagesArray addObject:snapshot.value];
   }
    completionBlock(messagesArray);
}

- (void)setupFirebaseWithCompletionBlock:(void (^)(BOOL completed))completionBlock{
    self.firebaseURL = [NSString stringWithFormat:@"https://vivid-inferno-6756.firebaseio.com/%@", self.firebaseRoomURL];

    self.firebase = [[Firebase alloc] initWithUrl:self.firebaseURL];

    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
   {
//       NSLog(@"****** 2: %@", snapshot);
      
        [self fetchMessagesFromCloud:snapshot withBlock:^void(NSMutableArray *messages)
      {
//           NSLog(@"***** 1: %@", messages);
         
            [self.messages addObjectsFromArray:messages];
         
         

//           NSLog(@"***** 3: %@", self.messages);
         

            completionBlock(YES);
        }];
    }];
}

@end
