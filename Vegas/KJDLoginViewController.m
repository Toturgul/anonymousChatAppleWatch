//
//  KJDLoginViewController.h
//  Vegas

#import "KJDLoginViewController.h"
#import "KJDChatRoomViewController.h"
#import <RNBlurModalView.h>
#import "KJDUser.h"
#import "KJDChatRoom.h"
#import "chatIDTextField.h"

@interface KJDLoginViewController ()

@property (strong, nonatomic) UILabel *enterLabel;
@property (strong, nonatomic) chatIDTextField *chatCodeField;
@property (strong, nonatomic) UIButton *enterButton;
@property (strong,nonatomic) KJDUser *user;
@property (strong,nonatomic) KJDChatRoom *chatRoom;

@end

@implementation KJDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImage.frame=self.view.frame;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.navigationController.navigationBarHidden = YES;
    [self setupViewsAndConstraints];
    
    if ( ! self.user)
    {
        self.user =[[KJDUser alloc]initWithRandomName];
    }
}
//
//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([self.chatCodeField.text length]<4) {
        RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self title:@"Invalid Chat ID!" message:@"The code must be at least 4 characters long"];
        [modal show];
        self.chatCodeField.text=@"";
    }else{
        self.chatRoom=[[KJDChatRoom alloc]initWithUser:self.user];
        self.chatRoom.firebaseRoomURL=self.chatCodeField.text;
//        self.chatRoom.user=self.user; // no era inecesario?
        KJDChatRoomViewController *destinationViewController = [[KJDChatRoomViewController alloc] init];
        destinationViewController.chatRoom=self.chatRoom;
//        destinationViewController.user=self.user;
        [self.navigationController pushViewController:destinationViewController animated:YES];
    }
    return YES;
}

- (void)setupViewsAndConstraints{
    [self setupLabel];
    [self setupChatCodeField];
    [self setupEnterButton];
}

- (void)setupLabel{
    self.enterLabel = [[UILabel alloc] init];
    [self.view addSubview:self.enterLabel];
    self.enterLabel.text = @"Enter Chat ID";
    self.enterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.enterLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSLayoutConstraint *enterLabelX = [NSLayoutConstraint constraintWithItem:self.enterLabel
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
    
    NSLayoutConstraint *enterLabelTop = [NSLayoutConstraint constraintWithItem:self.enterLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:0.40
                                                                      constant:0.0];
    
    NSLayoutConstraint *enterLabelWidth = [NSLayoutConstraint constraintWithItem:self.enterLabel
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.60
                                                                        constant:0.0];
    
    NSLayoutConstraint *enterLabelHeight = [NSLayoutConstraint constraintWithItem:self.enterLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.07
                                                                         constant:0.0];
    
    [self.view addConstraints:@[enterLabelX, enterLabelTop, enterLabelHeight, enterLabelWidth]];
}

- (void)setupChatCodeField
{
    self.chatCodeField = [[chatIDTextField alloc] init];
    [self.view addSubview:self.chatCodeField];
    self.chatCodeField.delegate=self;
    self.chatCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.chatCodeField.layer.cornerRadius=10.0f;
    self.chatCodeField.layer.masksToBounds=YES;
    UIColor *borderColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.chatCodeField.rightViewMode=UITextFieldViewModeAlways;
    self.chatCodeField.rightView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnifyingglass"]];
    self.chatCodeField.layer.borderColor=[borderColor CGColor];
    self.chatCodeField.layer.borderWidth=1.0f;
    self.chatCodeField.textAlignment=NSTextAlignmentCenter;
    self.chatCodeField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
    NSLayoutConstraint *chatCodeFieldX = [NSLayoutConstraint constraintWithItem:self.chatCodeField
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.enterLabel
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    NSLayoutConstraint *chatCodeFieldTop = [NSLayoutConstraint constraintWithItem:self.chatCodeField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.enterLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:7.0];
    
    NSLayoutConstraint *chatCodeFieldWidth = [NSLayoutConstraint constraintWithItem:self.chatCodeField
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.enterLabel
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:0.66
                                                                           constant:0.0];
    
    NSLayoutConstraint *chatCodeFieldHeight = [NSLayoutConstraint constraintWithItem:self.chatCodeField
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.enterLabel
                                                                           attribute:NSLayoutAttributeHeight
                                                                          multiplier:1.0
                                                                            constant:0.0];
    
    [self.view addConstraints:@[chatCodeFieldX, chatCodeFieldTop, chatCodeFieldWidth, chatCodeFieldHeight]];
}

- (void)setupEnterButton
{
    self.enterButton = [[UIButton alloc] init];
    [self.view addSubview:self.enterButton];
    [self.enterButton setTitle:@"Enter Chat" forState:UIControlStateNormal];
    self.enterButton.layer.cornerRadius=10.0f;
    self.enterButton.layer.masksToBounds=YES;
    self.enterButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    [self.enterButton addTarget:self action:@selector(enterButtonTappedForBackground) forControlEvents:UIControlEventTouchDown];
    [self.enterButton addTarget:self action:@selector(enterButtonReleased) forControlEvents:UIControlEventTouchUpInside];
    self.enterButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *enterButtonX = [NSLayoutConstraint constraintWithItem:self.enterButton
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.chatCodeField
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *enterButtonTop = [NSLayoutConstraint constraintWithItem:self.enterButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.chatCodeField
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:15.0];
    
    NSLayoutConstraint *enterButtonWidth = [NSLayoutConstraint constraintWithItem:self.enterButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.chatCodeField
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    NSLayoutConstraint *enterButtonHeight = [NSLayoutConstraint constraintWithItem:self.enterButton
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.chatCodeField
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    [self.view addConstraints:@[enterButtonX, enterButtonTop, enterButtonWidth, enterButtonHeight]];
}

-(void)enterButtonReleased{
    self.enterButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    if ([self.chatCodeField.text length]<4) {
        RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self title:@"Invalid Chat ID!" message:@"The code must be at least 4 characters long"];
        [modal show];
        self.chatCodeField.text=@"";
    }else{
        self.chatRoom=[[KJDChatRoom alloc]initWithUser:self.user];
        self.chatRoom.firebaseRoomURL=self.chatCodeField.text;
//        self.chatRoom.user=self.user;
        KJDChatRoomViewController *destinationViewController = [[KJDChatRoomViewController alloc] init];
        destinationViewController.chatRoom=self.chatRoom;
        [self.navigationController pushViewController:destinationViewController animated:YES];
        
        
    }
}

-(void)enterButtonTappedForBackground{
    self.enterButton.backgroundColor = [UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

@end
