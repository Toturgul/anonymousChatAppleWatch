//
//  KJDChatRoom.h
//  Vegas


#import <Foundation/Foundation.h>
#import "KJDUser.h"
#import <Firebase/Firebase.h>
#import <QuickLook/QuickLook.h>

@interface KJDChatRoom : NSObject

@property(strong,nonatomic)KJDUser *user;
@property(strong,nonatomic)NSMutableArray *messages;
@property(strong,nonatomic)NSString *firebaseRoomURL;
@property(strong,nonatomic)NSString *firebaseURL;
@property(strong,nonatomic)Firebase *firebase;

-(instancetype)initWithUser:(KJDUser *)user;
-(instancetype)init;

-(void)setupFirebaseWithCompletionBlock:(void (^)(BOOL completed))completionBlock;
-(void)fetchMessagesFromCloud:(FDataSnapshot *)snapshot withBlock:(void (^)(NSMutableArray *messages))completionBlock;
@end
