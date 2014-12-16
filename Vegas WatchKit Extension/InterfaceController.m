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
            self.infoFromAppDel = [replyInfo objectForKey:@"response"];
            [self configureTableWithData:self.infoFromAppDel];
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
        [theRow.messageLabel setText:dataObj[@"message"]];
    }
    
    
}


@end



