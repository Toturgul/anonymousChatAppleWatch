//
//  InterfaceController.m
//  Vegas WatchKit Extension
//
//  Created by Levan Toturgul on 12/16/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import "InterfaceController.h"
#import "MainRowType.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *myTable;
- (IBAction)myButton;


@end


@implementation InterfaceController

-(instancetype) initWithContext:(id)context{
    self = [super initWithContext:context];
    if (self) {
        NSLog(@"%@ initWithContext", self);
        
        //        self.messagesFromApp = [[NSMutableArray alloc] init];
        //[self configureTableWithData:self.messagesFromApp];
        
        
    }
    return self;
}




- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    
    
    // Configure interface objects here.
    NSLog(@"%@ awakeWithContext", self);
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myButton)
                                                     name:@"dataToWatch"
                                                   object:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myButton) userInfo:nil repeats:YES];
    
    NSLog(@"%@ will activate", self);
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}


- (IBAction)myButton {
    NSDictionary *requst = @{@"request":@"Hello"};
    
    [InterfaceController openParentApplication:requst reply:^(NSDictionary *replyInfo, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            
            //         [self.label setText:[replyInfo objectForKey:@"response"]];
          //  NSLog(@"*********** %@",[replyInfo objectForKey:@"response"]);
            self.infoFromAppDel = [[NSMutableArray alloc] init];
            NSArray *tempArray = [replyInfo objectForKey:@"response"];
            
//            if (! self.userName) {
//                self.userName = replyInfo[@"userName"];
//            }
            for (NSDictionary *tempDict in tempArray) {
                [self.infoFromAppDel insertObject:tempDict atIndex:0];
            }
            
            if ([self.infoFromAppDel count] > [self.oldInfo count])
            {
            [self configureTableWithData:self.infoFromAppDel];
                self.oldInfo = self.infoFromAppDel;
            }
        }
        
    }];
    
}

- (void)configureTableWithData:(NSArray*)dataObjects {
    
    NSLog(@"configureTablewithData activated num of rows %ld",[dataObjects count]);
    
    [self.myTable setNumberOfRows:[dataObjects count] withRowType:@"firstRC"];
    for (NSInteger i = 0; i < self.myTable.numberOfRows; i++) {
        MainRowType* theRow = [self.myTable rowControllerAtIndex:i];
        NSDictionary* dataObj = [dataObjects objectAtIndex:i];
        
        
        [theRow.usernameLabel setText:dataObj[@"user"]];
//        if (dataObj[@"user"] != self.userName) {
//            [theRow.usernameLabel setTextColor:[UIColor blueColor]];
//            [theRow.messageLabel setTextColor:[UIColor blueColor]];
//        }
        if (i==0) {
            [theRow.messageLabel setTextColor:[UIColor redColor]];
            [theRow.usernameLabel setTextColor:[UIColor redColor]];
        }
        
        if (dataObj[@"video"])
        {
            [theRow.messageLabel setText:@"[Video shared]"];
        }
        else if (dataObj[@"image"])
        {
            [theRow.messageLabel setText:@"[Image shared]"];
        }
        else if (dataObj[@"map"])
        {
            [theRow.messageLabel setText:@"[Map shared]"];
        }
        else
        {
            [theRow.messageLabel setText:dataObj[@"message"]];
        }
        
    }
    
    
}


@end



