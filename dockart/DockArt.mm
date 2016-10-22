#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Foundation/NSConcreteNotification.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DockArtListController: PSListController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
}
@end

@implementation DockArtListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"DockArt" target:self] retain];
	}
	return _specifiers;
}

- (void)linkToMyTwitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/sst1337/"]];
} 

- (void)respring {
    system("killall SpringBoard");
} 

- (void)selectPhoto {

    [self startMediaBrowserFromViewController:self usingDelegate:self];

}

- (void)_returnKeyPressed:(NSConcreteNotification *)notification {
	[self.view endEditing:YES];
	[super _returnKeyPressed:notification];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller

                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               
                                               UINavigationControllerDelegate>) delegate {
    
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        
        || (delegate == nil)
        
        || (controller == nil))
        
        return NO;
    
    
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    // Displays saved pictures and movies, if both are available, from the
    
    // Camera Roll album.
    
    mediaUI.mediaTypes =
    
    [UIImagePickerController availableMediaTypesForSourceType:
     
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    
    
    // Hides the controls for moving & scaling pictures, or for
    
    // trimming movies. To instead show the controls, use YES.
    
    mediaUI.allowsEditing = NO;
    
    
    
    mediaUI.delegate = delegate;
    
    
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
    
}

- (void) imagePickerController: (UIImagePickerController *) picker

 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    UIImage *originalImage, *editedImage, *imageToUse;
    
    
    
    // Handle a still image picked from a photo album
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        
        == kCFCompareEqualTo) {
        
        
        
        editedImage = (UIImage *) [info objectForKey:
                                   
                                   UIImagePickerControllerEditedImage];
        
        originalImage = (UIImage *) [info objectForKey:
                                     
                                     UIImagePickerControllerOriginalImage];
        
        
        
        if (editedImage) {
            
            imageToUse = editedImage;


            
        } else {
            
            imageToUse = originalImage;
            
            
        }

        if (imageToUse != nil)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            if(paths != nil) {
                NSString *documentsDirectory = [paths objectAtIndex:0];
                if(documentsDirectory != nil) {
                    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                                      @"dock_image.png" ];
                    //NSLog(@"%@", path);
                    if(path != nil) {
                        NSData* data = UIImagePNGRepresentation(imageToUse);
                        if(data != nil) {
                            [data writeToFile:path atomically:YES];
                            UIPasteboard *pb = [UIPasteboard generalPasteboard];
                            [pb setString:path];
                        }
                    }
                }
            }
        }
        
        // Do something with imageToUse
        
    }

    [self dismissViewControllerAnimated:YES completion:^{
    		[picker release];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Image Selected"
                               message:@"The path to your image has been copied to your clipboard.  Paste it into the Image Path text field."
                               preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
   			handler:nil];
   			[alert addAction:defaultAction];

            [self presentViewController:alert animated:YES completion:nil];
    }];

    
}
@end

// vim:ft=objc
