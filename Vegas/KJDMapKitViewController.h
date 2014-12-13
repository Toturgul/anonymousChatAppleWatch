//
//  KJDMapKitViewController.h
//  ChatCode
//
//  Created by Karim Mourra on 11/26/14.
//  Copyright (c) 2014 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KJDUser.h"
#import "KJDChatRoom.h"

@interface KJDMapKitViewController : UIViewController <CLLocationManagerDelegate>

@property(strong,nonatomic) CLLocationManager* locationManager;

@property(strong,nonatomic)KJDUser *user;
@property(strong,nonatomic)KJDChatRoom *chatRoom;

@end
