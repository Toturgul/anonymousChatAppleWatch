//
//  KJDUser.h
//  Vegas

#import <Foundation/Foundation.h>

@interface KJDUser : NSObject

extern NSString *const lettersAndNumbersString;

@property (strong, nonatomic) NSString *name;

-(instancetype)init;
-(instancetype)initWithRandomName;
-(NSString *)createRandomUsername;

@end
