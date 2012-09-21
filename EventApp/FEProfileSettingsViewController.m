//
//  FEProfileSettingsViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "FEProfileSettingsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "FEServerAPI.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface FEProfileSettingsViewController ()

@end

@implementation FEProfileSettingsViewController
@synthesize userAvatar;
@synthesize photoActionSheet;
@synthesize imagePickerController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人信息";
	[self.tableView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
	UIBarButtonItem *saveProfile = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(uploadAvatar)];
	self.navigationItem.rightBarButtonItem = saveProfile;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) changeAvatar
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
		[self photoFromLibrary];
    } else {
		photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"专辑",nil];
		[photoActionSheet showInView:self.navigationController.view];
	}
}
- (void) photoFromLibrary
{
	if (imagePickerController==nil) {
  		imagePickerController = [[UIImagePickerController alloc] init];
	}
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	[self presentModalViewController:imagePickerController animated:YES];
}

- (void) photoFromCamera
{
	if (imagePickerController==nil) {
  		imagePickerController = [[UIImagePickerController alloc] init];
	}
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	imagePickerController.delegate = self;
	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark - Image Resize

- (UIImage *)setThumbnailFromImage:(UIImage *)image withSize:(CGSize) size{
    CGSize origImageSize = [image size];

    CGRect newRect;
    newRect.origin = CGPointZero;
    newRect.size = size;

    float ratio = MAX(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);

    UIGraphicsBeginImageContext(newRect.size);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:0.0];
    [path addClip];
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;

    [image drawInRect:projectRect];

    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return small;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(160-32, 8, 64, 64)];
	
    if([AppDelegate sharedDelegate].selfUser.avatarImage != nil){
        [userAvatar setImage:[AppDelegate sharedDelegate].selfUser.avatarImage];
    }else {
        [userAvatar setImage:[UIImage imageNamed:@"avatar_holder_64"]];
    }
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	[headerView addSubview:userAvatar];
	
	UIImageView *userAvatarFrame = [[UIImageView alloc] initWithFrame:CGRectMake(160-32, 8, 64, 64)];
	[userAvatarFrame setImage:[UIImage imageNamed:@"profile_photo_frame"]];
	[headerView addSubview:userAvatarFrame];
	
	UIButton *editAvatar = [[UIButton alloc] initWithFrame:CGRectMake(160-32, 8, 64, 64)];
	[editAvatar addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
	[editAvatar setBackgroundColor:[UIColor clearColor]];
	
	UILabel *editAvatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 64, 20)];
	[editAvatarLabel setText:@"编辑"];
	[editAvatarLabel setTextAlignment:UITextAlignmentCenter];
	[editAvatarLabel setTextColor:[UIColor whiteColor]];
	[editAvatarLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	[editAvatarLabel setFont:[UIFont systemFontOfSize:14.0f]];
	[editAvatar addSubview:editAvatarLabel];
	
	[headerView addSubview:editAvatar];
	
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"profileEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	if (indexPath.section == 0 && indexPath.row == 0 ) {
		UITextField *userNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
		//[userNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
		[userNameField setFont:[UIFont systemFontOfSize:16.0f]];
		[userNameField setBackgroundColor:[UIColor clearColor]];
		userNameField.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        [userNameField setEnabled:NO];
		[cell.contentView addSubview:userNameField];
		cell.textLabel.text = @"用户名";
	}
	if (indexPath.section == 0 && indexPath.row == 1 ) {
		UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
		emailField.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
		[emailField setFont:[UIFont systemFontOfSize:15.0f]];
		[emailField setBackgroundColor:[UIColor clearColor]];
		[emailField setEnabled:NO];
		//emailField.textColor = [UIColor lightGrayColor];
		[cell.contentView addSubview:emailField];
		cell.textLabel.text = @"邮箱";
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
	  [self photoFromCamera];
	} if (buttonIndex == 1) {
	  [self photoFromLibrary];
	}
}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],.8);
	UIImage *photo = [self setThumbnailFromImage:[UIImage imageWithData:imageData] withSize:CGSizeMake(128, 128)];
	[userAvatar setImage:photo];
	
	[self.imagePickerController dismissModalViewControllerAnimated:YES];
}

- (void)uploadAvatar
{
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_AVATAR];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:eventURL]] autorelease];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:user_id] forKey:@"user_id"];
    [request setPostValue:password forKey:@"password"];
    
    NSData *avatarData = UIImageJPEGRepresentation(userAvatar.image, 1.0f);
    [request setData:avatarData withFileName:@"upload.jpg" andContentType:@"image/jpeg" forKey:@"userfile"];
    
    request.delegate = self;
    [request startAsynchronous];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hub.dimBackground = YES;
    hub.mode = MBProgressHUDModeIndeterminate;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSString *status = [result objectForKey:@"status"];
    
    if([status isEqualToString:@"success"]){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        NSDictionary *avatar = [result objectForKey:@"avatar"];
        FEHostUser *user = [AppDelegate sharedDelegate].selfUser;
        user.avatarImage = userAvatar.image;
        user.avatarURL = [avatar objectForKey:@"url"];
        
        [[NSUserDefaults standardUserDefaults] setValue:user.avatarURL forKey:@"avatarURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if([[AppDelegate sharedDelegate].viewDeckController.leftController respondsToSelector:@selector(updateUserAvatar)]){
            [[AppDelegate sharedDelegate].viewDeckController.leftController performSelector:@selector(updateUserAvatar)];
        }
    }
}


@end
