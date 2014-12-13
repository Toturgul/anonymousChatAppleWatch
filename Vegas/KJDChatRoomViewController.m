//
//  ViewController.m
//  Vegas

#import "KJDChatRoomViewController.h"
#import "KJDImageDisplayViewController.h"
#import "KJDChatRoomTableViewCellRight.h"
#import "KJDChatRoomTableViewCellLeft.h"
#import "KJDChatRoomImageCellRight.h"
#import "KJDChatRoomImageCellLeft.h"


@interface KJDChatRoomViewController ()

@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *mediaButton;

@property (strong,nonatomic) MPMoviePlayerController* playerController;

@property (nonatomic)CGRect keyBoardFrame;
@property(strong,nonatomic)NSMutableArray *messages;
@property(strong, nonatomic) NSMutableDictionary* contentToSend;

@end

@implementation KJDChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextField.delegate=self;
    [self setupViewsAndConstraints];
    self.user=self.chatRoom.user;
    [self.chatRoom setupFirebaseWithCompletionBlock:^(BOOL completed) {
        if (completed) {
            
            self.messages=self.chatRoom.messages; //****** esto hace q lleguen los msjes anteriores ? might have to add the contents
            self.user=self.chatRoom.user;
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                [self.tableView reloadData];
                if (![self.messages count] == 0) {
                    
                    //************************
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }];
        }
    }];
    
    //    NSLog(@"self.messages: %@", self.messages);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.contentToSend = [[NSMutableDictionary alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

-(void)dismissKeyboard {
    [self.inputTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.navigationController setNavigationBarHidden:NO];
    [UIView commitAnimations];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    _keyBoardFrame = [keyboardFrameBegin CGRectValue];
    if (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }else if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    if (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }else if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)moveUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect superViewRect = self.view.frame;
    UIEdgeInsets inset = UIEdgeInsetsMake(self.keyBoardFrame.size.height+self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0);
    UIEdgeInsets afterInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0);
    if (moveUp){
        self.tableView.contentInset = inset;
        superViewRect.origin.y -= self.keyBoardFrame.size.height;
    }else{
        self.tableView.contentInset = afterInset;
        superViewRect.origin.y += self.keyBoardFrame.size.height;
    }
    self.view.frame = superViewRect;
    [UIView commitAnimations];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupViewsAndConstraints {
    [self setupNavigationBar];
    [self setupTableView];
    [self setupTextField];
    [self setupSendButton];
    [self setupMediaButton];
}

-(void)setupNavigationBar{
    self.navigationItem.title=self.chatRoom.firebaseRoomURL;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                                  forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setupTableView
{
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    [self.view sendSubviewToBack:self.tableView.backgroundView];
    self.tableView.clipsToBounds=YES;
    
    //changes from Jan
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KJDChatRoomTableViewCellLeft" bundle:nil] forCellReuseIdentifier:@"normalCellLeft"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KJDChatRoomTableViewCellRight" bundle:nil] forCellReuseIdentifier:@"normalCellRight"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KJDChatRoomImageCellLeft" bundle:nil] forCellReuseIdentifier:@"imageCellLeft"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KJDChatRoomImageCellRight" bundle:nil] forCellReuseIdentifier:@"imageCellRight"];
    
//    self.cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 57)];
//    [self.tableView addSubview:self.cell];
    self.tableView.scrollEnabled=YES;
    
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.navigationItem.titleView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-40.0];
    
    NSLayoutConstraint *tableViewWidth = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    NSLayoutConstraint *tableViewLeft = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0.0];
    
    [self.view addConstraints:@[tableViewTop, tableViewBottom, tableViewWidth, tableViewLeft]];
    
}

- (void)sendButtonTapped{
    self.sendButton.backgroundColor=[UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

-(void)sendButtonNormal{
    if (![self.inputTextField.text isEqualToString:@""] && ![self.inputTextField.text isEqualToString:@" "]) {
        NSString *message = self.inputTextField.text;
        self.sendButton.titleLabel.textColor=[UIColor grayColor];
        [self.chatRoom.firebase setValue:@{@"user":self.user.name,
                                           @"message":message}];
        self.inputTextField.text = @"";
    }
    self.sendButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.sendButton.titleLabel.textColor=[UIColor whiteColor];
}

- (void)setupSendButton{
    self.sendButton = [[UIButton alloc] init];
    [self.view addSubview:self.sendButton];
    self.sendButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.sendButton.layer.cornerRadius=10.0f;
    self.sendButton.layer.masksToBounds=YES;
    [self.sendButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Send" attributes:nil] forState:UIControlStateNormal];
    self.sendButton.titleLabel.textColor=[UIColor whiteColor];
    [self.sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchDown];
    [self.sendButton addTarget:self action:@selector(sendButtonNormal) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *sendButtonTop = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.tableView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:4.0];
    
    NSLayoutConstraint *sendButtonBottom = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-4.0];
    
    NSLayoutConstraint *sendButtonLeft = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.inputTextField
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:4.0];
    
    NSLayoutConstraint *sendButtonRight = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.tableView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-4.0];
    
    [self.view addConstraints:@[sendButtonTop, sendButtonBottom, sendButtonLeft, sendButtonRight]];
}

-(void)setupMediaButton{
    self.mediaButton = [[UIButton alloc] init];
    [self.view addSubview:self.mediaButton];
    self.mediaButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    [self.mediaButton setAttributedTitle :[[NSAttributedString alloc] initWithString:@"M"
                                                                          attributes:nil]
                                 forState:UIControlStateNormal];
    [self.mediaButton addTarget:self action:@selector(mediaButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.mediaButton.titleLabel.textColor = [UIColor whiteColor];
    self.mediaButton.layer.cornerRadius=10.0f;
    self.mediaButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *mediaButtonTop = [NSLayoutConstraint constraintWithItem:self.mediaButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.inputTextField
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0];
    
    NSLayoutConstraint *mediaButtonBottom =[NSLayoutConstraint constraintWithItem:self.mediaButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.inputTextField
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    NSLayoutConstraint *mediaButtonLeft =[NSLayoutConstraint constraintWithItem:self.mediaButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1
                                                                       constant:4];
    
    NSLayoutConstraint *mediaButtonRight =[NSLayoutConstraint constraintWithItem:self.mediaButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.inputTextField
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1
                                                                        constant:-4];
    
    [self.view addConstraints:@[mediaButtonTop, mediaButtonBottom, mediaButtonLeft, mediaButtonRight]];
}

- (void)setupTextField{
    self.inputTextField = [[UITextField alloc] init];
    [self.view addSubview:self.inputTextField];
    self.inputTextField.layer.cornerRadius=10.0f;
    self.inputTextField.layer.masksToBounds=YES;
    UIColor *borderColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.inputTextField.layer.borderColor=[borderColor CGColor];
    self.inputTextField.layer.borderWidth=1.5f;
    self.inputTextField.backgroundColor=[UIColor clearColor];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.inputTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.inputTextField setLeftView:spacerView];
    
    self.inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *textFieldTop = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.tableView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:4.0];
    
    NSLayoutConstraint *textFieldBottom = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-4.0];
    
    NSLayoutConstraint *textFieldLeft = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.tableView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:40.0];
    
    NSLayoutConstraint *textFieldRight = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.tableView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-80.0];
    
    [self.view addConstraints:@[textFieldTop, textFieldBottom, textFieldLeft, textFieldRight]];
}

-(void)summonMap
{
    KJDMapKitViewController* mapKitView = [[KJDMapKitViewController alloc] init];
    mapKitView.user = self.user;
    mapKitView.chatRoom = self.chatRoom;
    
    [self presentViewController:mapKitView animated:YES completion:^{
        
    }];
}

-(NSString *)imageToNSString:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1); //UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(NSString*)videoToNSString:(NSURL*)video{
    NSData* videoData =[NSData dataWithContentsOfURL:video options:NSDataReadingMappedAlways error:nil];
    return [videoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(UIImage *)stringToUIImage:(NSString *)string{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(MPMoviePlayerController*)stringToVideo:(NSString*)string{
    
    NSData* videoData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
    
    BOOL success = [videoData writeToFile:tempPath atomically:NO];
    NSLog(@"write to file success: %d", success);
    
    NSURL* pathURL = [[NSURL alloc] initFileURLWithPath:tempPath];
    
    MPMoviePlayerController* player = [[MPMoviePlayerController alloc]initWithContentURL:pathURL];
    
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDone_Press) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    player.shouldAutoplay = NO;
    
    return player;
    
    //alternative - more to reproduce a video ; would need to know where a video is stored when saved.
    
    /*
     NSString *moviePath = [[info objectForKey:
     UIImagePickerControllerMediaURL] path];
     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath))
     {
     UISaveVideoAtPathToSavedPhotosAlbum (moviePath,self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
     }
     
     //for obtaining filePath, consider also:
     NSString *filepath = [[NSBundle mainBundle] pathForResource:@"vid" ofType:@"mp4"];
     
     */
}

-(BOOL)systemVersionLessThan8
{
    CGFloat deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return deviceVersion < 8.0f;
}

-(void) sendMapImage:(UIImage*)map
{
    NSString* photoInString = [self imageToNSString:map];
    
    [self.chatRoom.firebase setValue:@{@"user":self.user.name,
                                       @"image":photoInString}];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString* mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    
    if([mediaType isEqualToString:@"public.image"])
    {
        UIImage* extractedPhoto = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSString* photoInString = [self imageToNSString:extractedPhoto];
        [self.contentToSend setObject:photoInString forKey:@"image"]; //innecesario
        
        [self.chatRoom.firebase setValue:@{@"user":self.user.name,
                                           @"image":photoInString}];
        
    }
    else if([mediaType isEqualToString:@"public.movie"])
    {
        
        NSURL* videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString* videoInString = [self videoToNSString:videoURL];
        
        [self.chatRoom.firebase setValue:@{@"user":self.user.name,
                                           @"video":videoInString}];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) mediaButtonTapped
{
    if ([self systemVersionLessThan8])
    {
        UIAlertView* mediaAlert = [[UIAlertView alloc] initWithTitle:@"Share something!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take a Picture or Video", @"Choose an existing Photo or Video", @"Share location", nil];
        
        [mediaAlert show];
    }
    else
    {
        UIAlertController* mediaAlert = [UIAlertController alertControllerWithTitle:@"Share something!" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"Take a Picture or Video"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){[self obtainImageFrom:UIImagePickerControllerSourceTypeCamera];
                                                          }];
        [mediaAlert addAction:takePhoto];
        
        UIAlertAction* chooseExistingPhoto = [UIAlertAction actionWithTitle:@"Choose an existing Photo or Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self obtainImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        
        [mediaAlert addAction:chooseExistingPhoto];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [mediaAlert addAction:cancel];
        
        UIAlertAction* showLocation = [UIAlertAction actionWithTitle:@"Share Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self summonMap];
        }];
        
        [mediaAlert addAction:showLocation];
        
        [self presentViewController:mediaAlert animated:YES completion:^{
            
        }];
    }
    
    
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self obtainImageFrom:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 2){
        [self obtainImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if (buttonIndex == 3){
        [self summonMap];
    }
}

-(void) obtainImageFrom:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.mediaTypes = mediaTypesAllowed;
    
    //seems to be unnecessary
    //    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    //    {
    //        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie, kUTTypeImage, nil];
    //    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
                       animated:YES
                     completion:^{
                         
                     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //changed from jan
//    NSMutableDictionary *content=self.messages[indexPath.row];
//    if (content[@"video"] || content[@"image"] || content[@"map"])
//    {
//        return 200;
//    }
//    else
//    {
//        return 70;
//    }

    if (![self.messages count]==0) {
        NSMutableDictionary *message=self.messages[indexPath.row];
        if ([message objectForKey:@"message"]!=nil) {
            NSDictionary *message=self.messages[indexPath.row];
            NSString * yourText = message[@"message"]; // or however you are getting the text
            return 51 + [self heightForText:yourText];
        }else{
            return 180;
        }
    }
    return 0;
}

//from jan
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

//from jan
-(CGFloat)heightForText:(NSString *)text
{
    NSInteger MAX_HEIGHT = 2000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, MAX_HEIGHT)];
    textView.text = text;
    textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [textView sizeToFit];
    return textView.frame.size.height;
}

//from Jan
- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    cell.userInteractionEnabled=NO;
    
    NSDictionary *content=self.messages[indexPath.row];
    
        
        if (content[@"video"])
        {
//            cell.userInteractionEnabled=YES;
            MPMoviePlayerController* player = [self stringToVideo:content[@"video"]];
            
            self.playerController = player;
            
            UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            
            if ([content[@"user"] isEqualToString:self.user.name]) {
                KJDChatRoomImageCellRight *rightCell=[tableView dequeueReusableCellWithIdentifier:@"imageCellRight"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                
                rightCell.usernameLabel.attributedText=muAtrStr;
                rightCell.backgroundColor=[UIColor clearColor];
                [rightCell.mediaImageView setBackgroundColor:[UIColor clearColor]];
                
                NSLog(@"cell content view subviws BEFORE: %@", rightCell.contentView.subviews);
                [rightCell.mediaImageView removeFromSuperview];
                                NSLog(@"cell content view subviws AFTER: %@", rightCell.contentView.subviews);
                
                player.view .frame = CGRectMake(170, 30, 141, 142);
                if ([rightCell.contentView.subviews count] == 1)
                {
                    [rightCell.contentView addSubview:player.view];
                }
                                NSLog(@"cell content view subviws LAST: %@", rightCell.contentView.subviews);
                
                return rightCell;
            }else{
                KJDChatRoomImageCellLeft *leftCell=[tableView dequeueReusableCellWithIdentifier:@"imageCellLeft"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                NSLog(@"cell content view subviws BEFORE: %@", leftCell.contentView.subviews);
                leftCell.usernameLabel.attributedText=muAtrStr;
                leftCell.backgroundColor=[UIColor clearColor];
                [leftCell.mediaImageView setBackgroundColor:[UIColor clearColor]];
//                leftCell.mediaImageView.image=image;
                
                [leftCell.mediaImageView removeFromSuperview];
                
                player.view .frame = CGRectMake(8, 30, 141, 142);
                if ([leftCell.contentView.subviews count] == 1)
                {
                    [leftCell.contentView addSubview:player.view];
                }
                
                return leftCell;
            }
            
            
//            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 200);
//            cell.contentView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
            
            
//            if ([content[@"user"] isEqualToString:self.user.name])
//            {
//                [player.view setFrame:CGRectMake(cell.contentView.frame.size.width/2 -4 , cell.contentView.frame.origin.y +4, cell.contentView.frame.size.width/2, cell.contentView.frame.size.height -4)];
//            }
//            else
//            {
//                [player.view setFrame:CGRectMake(cell.contentView.frame.origin.x + 4, cell.contentView.frame.origin.y +4, cell.contentView.frame.size.width/2, cell.contentView.frame.size.height -4)];
//            }
//            
//            cell.backgroundColor=[UIColor clearColor];
            
            player.scalingMode = MPMovieScalingModeAspectFit;
            [player setControlStyle:MPMovieControlStyleDefault];
            player.repeatMode = MPMovieRepeatModeNone;
            
//            if ([cell.contentView.subviews count] == 0)
//            {
//                [cell.contentView addSubview:player.view];
//            }
            
            
            //
            //            [[NSNotificationCenter defaultCenter] addObserver:self
            //                                                     selector:@selector(moviePlayerDidFinish:)
            //                                                         name:MPMoviePlayerPlaybackDidFinishNotification
            //                                                       object:self.playerController];
            
            
            
            [player play];
        }
         if (content[@"map"])
        {
//            cell.userInteractionEnabled=YES;
            NSString* imageInCode = content[@"map"];
            UIImage* imageToDisplay = [self stringToUIImage:imageInCode];
            
            if ([content[@"user"] isEqualToString:self.user.name])
            {
                KJDChatRoomImageCellRight *rightCell=[tableView dequeueReusableCellWithIdentifier:@"imageCellRight"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                
                rightCell.usernameLabel.attributedText=muAtrStr;
                rightCell.backgroundColor=[UIColor clearColor];
                rightCell.mediaImageView.image=imageToDisplay;
                
                return rightCell;
            }
            else
            {
                KJDChatRoomImageCellLeft *leftCell=[tableView dequeueReusableCellWithIdentifier:@"imageCellLeft"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                
                leftCell.usernameLabel.attributedText=muAtrStr;
                leftCell.backgroundColor=[UIColor clearColor];
                leftCell.mediaImageView.image=imageToDisplay;
                
                return leftCell;
            }
//
//            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 200);
//            cell.contentView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//            
//            
//            
//            if ([content[@"user"] isEqualToString:self.user.name])
//            {
//                cell.frame = CGRectMake(0, 0, cell.frame.size.width, 200);
//                
//                UIImageView* imageDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/2 -4 , cell.contentView.frame.origin.y +4, cell.contentView.frame.size.width/2, cell.contentView.frame.size.height -4)];
//                imageDisplay.image = imageToDisplay;
//                
//                if ([cell.contentView.subviews count] == 0)
//                {
//                    [cell.contentView addSubview:imageDisplay];
//                }
//            }
//            else
//            {
//                UIImageView* imageDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x + 4, cell.contentView.frame.origin.y +4, cell.contentView.frame.size.width/2, cell.contentView.frame.size.height-4)];
//                imageDisplay.image = imageToDisplay;
//                
//                if ([cell.contentView.subviews count] == 0)
//                {
//                    [cell.contentView addSubview:imageDisplay];
//                }
//            }
//            
//            cell.backgroundColor=[UIColor clearColor];
        }
        else if (content[@"image"])
        {
            
            NSString* imageInCode = content[@"image"];
            UIImage* imageToDisplay = [self stringToUIImage:imageInCode];
            
//            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 200);
//            cell.contentView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
            
            if ([content[@"user"] isEqualToString:self.user.name])
            {
                KJDChatRoomImageCellRight *rightCell=[tableView dequeueReusableCellWithIdentifier:@"imageCellRight"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                
                rightCell.usernameLabel.attributedText=muAtrStr;
                rightCell.backgroundColor=[UIColor clearColor];
                rightCell.mediaImageView.image=imageToDisplay;
                
                return rightCell;
                
//                UIImageView* imageDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/2 -4 , cell.contentView.frame.origin.y +4, cell.contentView.frame.size.width/2, cell.contentView.frame.size.height -4)];
//                imageDisplay.image = imageToDisplay;
//                
//                if ([cell.contentView.subviews count] == 0)
//                {
//                    [cell.contentView addSubview:imageDisplay];
//                }
            }
            else
            {
                KJDChatRoomImageCellRight *leftCell=[tableView dequeueReusableCellWithIdentifier:@"imageCellLeft"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                
                leftCell.usernameLabel.attributedText=muAtrStr;
                leftCell.backgroundColor=[UIColor clearColor];
                leftCell.mediaImageView.image=imageToDisplay;
                
                return leftCell;

//                UIImageView* imageDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x + 4, cell.contentView.frame.origin.y +4, cell.contentView.frame.size.width/2, cell.contentView.frame.size.height-4)];
//                imageDisplay.image = imageToDisplay;
//                
//                if ([cell.contentView.subviews count] == 0)
//                {
//                    [cell.contentView addSubview:imageDisplay];
//                }
            }
            
//            cell.backgroundColor=[UIColor clearColor];
        }
        else if (content[@"message"])
        {
            //changed from jan
//            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 200);
//            cell.contentView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
            
            NSString *messageTyped=[NSString stringWithFormat:@"\n%@", content[@"message"]];
//            cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
//            cell.textLabel.numberOfLines=0;
//            NSMutableAttributedString *attributedUserName = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
//            [attributedUserName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:21] range:NSMakeRange(0, [attributedUserName length])];
//            
//            //
//            NSAttributedString *attributedMessage = [[NSAttributedString alloc]initWithString:messageTyped attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:24]}];
//            [attributedUserName appendAttributedString:attributedMessage];
//            cell.textLabel.attributedText=attributedUserName;
//            cell.backgroundColor=[UIColor clearColor];
            
            if ([content[@"user"] isEqualToString:self.user.name])
            {
//                cell.textLabel.textAlignment=NSTextAlignmentRight;
//                cell.textLabel.textAlignment=NSTextAlignmentRight;
                KJDChatRoomTableViewCellRight *rightCell=[tableView dequeueReusableCellWithIdentifier:@"normalCellRight"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:self.user.name];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                
                rightCell.usernameLabel.attributedText = muAtrStr;
                rightCell.usernameLabel.textAlignment = NSTextAlignmentRight;
                rightCell.backgroundColor=[UIColor clearColor];
                rightCell.userMessageTextView.text=messageTyped;
                rightCell.userMessageTextView.textAlignment=NSTextAlignmentRight;
                rightCell.userMessageTextView.backgroundColor=[UIColor clearColor];
                [rightCell.userMessageTextView sizeToFit];
                [rightCell.userMessageTextView layoutIfNeeded];
                
                return rightCell;
            }
            else
            {
                KJDChatRoomTableViewCellLeft *leftCell=[tableView dequeueReusableCellWithIdentifier:@"normalCellLeft"];
                NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc]initWithString:content[@"user"]];
                [muAtrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15] range:NSMakeRange(0, [muAtrStr length])];
                leftCell.backgroundColor=[UIColor clearColor];
                leftCell.usernameLabel.attributedText=muAtrStr;
                leftCell.userMessageTextView.text=messageTyped;
                leftCell.userMessageTextView.backgroundColor=[UIColor clearColor];
                [leftCell.userMessageTextView sizeToFit];
                [leftCell.userMessageTextView layoutIfNeeded];
                
                return leftCell;
            }
        }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *content=self.messages[indexPath.row];
    
    if (content[@"map"])
    {
        //fix this!!!!!!!
        UITableViewCell* mapCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        
        KJDImageDisplayViewController* imageDisplayVC = [[KJDImageDisplayViewController alloc]init];
        
        imageDisplayVC.map = mapCell.contentView.subviews[0];
        
        [imageDisplayVC setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [self presentViewController:imageDisplayVC animated:YES completion:^{
            
        }];
    }
}


//- (void)moviePlayerDidFinish:(NSNotification *)note
//{
//    if (note.object == self.playerController)
//    {
//        NSInteger reason = [[note.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
//        if (reason == MPMovieFinishReasonPlaybackEnded)
//        {
//            NSLog(@"sfsdff");
//            [self.playerController prepareToPlay];
//            
//        }
//    }
//}

@end
