#import "SpringBoard/SBWallpaperEffectView.h"

@interface SBDockView

#define PLIST_FILENAME @"/var/mobile/Library/Preferences/com.sst1337.DockArt.plist"
#define ONOFF @"OnOff"
#define IMAGELOCATION @"Image Path"
#define SIZETOFIT @"Size To Fit"

- (BOOL)isEnabled;
- (BOOL)isSizeToFit;
- (NSString *)getImagePath;
- (UIImage *)getImage;
- (BOOL)addImageToView:(UIView *)bgView;
@end 



%hook SBDockView

%new
- (BOOL)isEnabled
{
  NSDictionary *settings = [[%c(NSDictionary) alloc] initWithContentsOfFile:PLIST_FILENAME];
  if([[settings objectForKey: ONOFF] boolValue] || [settings objectForKey: ONOFF] == nil) return YES;  
  return NO;
}

%new
- (BOOL)isSizeToFit
{
  NSDictionary *settings = [[%c(NSDictionary) alloc] initWithContentsOfFile:PLIST_FILENAME];
  if([[settings objectForKey: SIZETOFIT] boolValue] == NO|| [settings objectForKey: SIZETOFIT] == nil) return NO;  
  return YES;
}

%new
- (NSString *)getImagePath
{
    NSDictionary *settings = [[%c(NSDictionary) alloc] initWithContentsOfFile:PLIST_FILENAME];
    NSString *imagePath = (NSString *)[settings objectForKey:IMAGELOCATION];
    if([imagePath isEqualToString: @""]) return nil;
    else return imagePath;
}

%new
- (UIImage *)getImage
{
  NSString *imagePath = [self getImagePath];
  if(imagePath != nil)
  { 
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if(image != nil) return image;
  }
  return nil;
}

%new
- (BOOL)addImageToView:(UIView *)bgView
{
  UIImage *image = [self getImage];
  if(image != nil)
  {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = bgView.frame;
    if([self isSizeToFit]) imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview: imageView];
    return YES;
  }
  return NO;
}

- (void)layoutSubviews 
{
	%orig;
	if([self isEnabled]) 
	{
		SBWallpaperEffectView *bgView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
		[self addImageToView: bgView];
	}
}

%end

