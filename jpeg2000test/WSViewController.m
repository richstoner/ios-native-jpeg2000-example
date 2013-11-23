//
//  WSViewController.m
//  jpeg2000test
//
//  Created by Rich Stoner on 11/23/13.
//  Copyright (c) 2013 WholeSlide. All rights reserved.
//  Based on code from https://developer.apple.com/library/ios/documentation/graphicsimaging/conceptual/ImageIOGuide/imageio_source/ikpg_source.html#//apple_ref/doc/uid/TP40005462-CH218-SW3
//

#import "WSViewController.h"

#import <ImageIO/ImageIO.h>

@interface WSViewController ()
{
    NSURL* mUrl;
}

@property(nonatomic, strong) UIImageView* thumbnailView;

@end

@implementation WSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.thumbnailView = [UIImageView new];
    self.thumbnailView.frame = CGRectMake(10, 10, 300, 300);
    self.thumbnailView.backgroundColor = [UIColor lightGrayColor];
    self.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.thumbnailView];
    
    [self loadJpeg2000];
}

- (void) loadJpeg2000
{
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"6ktest" ofType:@"jp2"];
    NSLog(@"%@", filePath);
    
    CGImageRef jpeg2Image = [self createCGImageFromFile:filePath];
    
}

- (CGImageRef) createCGImageFromFile:(NSString*) path
{
    // Get the URL for the pathname passed to the function.
    NSURL *url = [NSURL fileURLWithPath:path];
    CGImageRef        myImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    CFStringRef       myKeys[2];
    CFTypeRef         myValues[2];
    
    // Set up options if you want them. The options here are for
    // caching the image in a decoded form and for using floating-point
    // values if the image format supports them.
    myKeys[0] = kCGImageSourceShouldCache;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    myKeys[1] = kCGImageSourceShouldAllowFloat;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    // Create the dictionary
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                   (const void **) myValues, 2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   & kCFTypeDictionaryValueCallBacks);
    // Create an image source from the URL.
    
    myImageSource = CGImageSourceCreateWithURL( (__bridge CFURLRef)url, myOptions);
    CFRelease(myOptions);
    // Make sure the image source exists before continuing
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }
    else{
        CFDictionaryRef props = CGImageSourceCopyPropertiesAtIndex(myImageSource, 0, NULL);
        NSLog(@"%@", props);

    }

    
    CGImageRef        thumbImage = NULL;
    CFDictionaryRef   thumbOptions = NULL;
    CFStringRef       thumbKeys[3];
    CFTypeRef         thumbValues[3];
    CFNumberRef       thumbnailSize;

    const int imageSize = 300;

    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    
    // Set up the thumbnail options.
    thumbKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    thumbValues[0] = (CFTypeRef)kCFBooleanTrue;
    thumbKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    thumbValues[1] = (CFTypeRef)kCFBooleanTrue;
    thumbKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    thumbValues[2] = (CFTypeRef)thumbnailSize;
    
    thumbOptions = CFDictionaryCreate(NULL, (const void **) thumbKeys,
                                   (const void **) thumbValues, 3,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   & kCFTypeDictionaryValueCallBacks);
    
    // Create the thumbnail image using the specified options.
    thumbImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                           0,
                                                           thumbOptions);
    
    if (thumbImage == NULL){
        fprintf(stderr, "Image not created from image source.");
        return NULL;
    }
    else{
        
        self.thumbnailView.image = [UIImage imageWithCGImage:thumbImage];
        
    }
    
    
    // Create an image from the first item in the image source.
    myImage = CGImageSourceCreateImageAtIndex(myImageSource,
                                              0,
                                              NULL);
    
    // Release the options dictionary and the image source
    // when you no longer need them.
    CFRelease(thumbnailSize);
    CFRelease(thumbOptions);
    CFRelease(myImageSource);
    // Make sure the image exists before continuing
    if (myImage == NULL){
        fprintf(stderr, "Image not created from image source.");
        return NULL;
    }
    
    return myImage;
}


//CGImageRef MyCreateThumbnailImageFromData (NSData * data, int imageSize)
//{
//    CGImageRef        myThumbnailImage = NULL;
//    CGImageSourceRef  myImageSource;
//    CFDictionaryRef   myOptions = NULL;
//    CFStringRef       myKeys[3];
//    CFTypeRef         myValues[3];
//    CFNumberRef       thumbnailSize;
//    
//    // Create an image source from NSData; no options.
//    myImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data,
//                                                NULL);
//    // Make sure the image source exists before continuing.
//    if (myImageSource == NULL){
//        fprintf(stderr, "Image source is NULL.");
//        return  NULL;
//    }
//    
//    // Package the integer as a  CFNumber object. Using CFTypes allows you
//    // to more easily create the options dictionary later.
//    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
//    
//    // Set up the thumbnail options.
//    myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
//    myValues[0] = (CFTypeRef)kCFBooleanTrue;
//    myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
//    myValues[1] = (CFTypeRef)kCFBooleanTrue;
//    myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
//    myValues[2] = (CFTypeRef)thumbnailSize;
//    
//    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
//                                   (const void **) myValues, 2,
//                                   &kCFTypeDictionaryKeyCallBacks,
//                                   & kCFTypeDictionaryValueCallBacks);
//    
//    // Create the thumbnail image using the specified options.
//    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
//                                                           0,
//                                                           myOptions);
//    // Release the options dictionary and the image source
//    // when you no longer need them.
//    CFRelease(thumbnailSize);
//    CFRelease(myOptions);
//    CFRelease(myImageSource);
//    
//    // Make sure the thumbnail image exists before continuing.
//    if (myThumbnailImage == NULL){
//        fprintf(stderr, "Thumbnail image not created from image source.");
//        return NULL;
//    }
//    
//    return myThumbnailImage;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
