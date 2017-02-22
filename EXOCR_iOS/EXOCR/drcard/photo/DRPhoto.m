//
//  DRPhoto.m
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "DRPhoto.h"
#import "DrCardInfo.h"
#import "../../cardcore/excards.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define UIColorFromRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

@interface DRPhoto ()

@property(strong, nonatomic) UIView *promptView;
@property(strong, nonatomic) UIView *backgroundView;
@property(strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation DRPhoto

@synthesize target;
@synthesize delegate;
static DrCardInfo *drInfo;
static UIImage *originImg;

- (instancetype)init
{
    self = [super init];
    if(self) {
        //背景View
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.backgroundView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.hidden = YES;
        //提示View
        self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 60)];
        self.promptView.backgroundColor = [UIColor whiteColor];
        self.promptView.userInteractionEnabled = NO;
        self.promptView.hidden = YES;
        self.promptView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.promptView.layer.borderWidth = 0.5;
        self.promptView.layer.masksToBounds = YES;
        self.promptView.layer.cornerRadius = 8.0;
        
        CGRect frame = self.promptView.frame;
        UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, 40)];
        label.text = @"正在识别，请稍候";
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.promptView addSubview:label];
        self.indicator = [[UIActivityIndicatorView alloc]init];
        self.indicator.color = [UIColor blackColor];
        self.indicator.center = CGPointMake(frame.size.width/2, frame.size.height/2-5);
        [self.promptView addSubview:self.indicator];
    }
    return self;
}

- (void)photoReco
{
    if (target) {
        self.promptView.center = target.view.center;
        [target.view addSubview:self.promptView];
        [target.view addSubview:self.backgroundView];
    }
    [self openPhoto];
}

-(void)openPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [target presentModalViewController:picker animated:YES];
}

-(void)doRec:(UIImage *)image
{
    @synchronized(self) {
        unsigned char* pdata = [self convertUIImageToBitmapRGBA8:image];
        if (pdata == nil) {
            return;
        }
        size_t width = CGImageGetWidth([image CGImage]);
        size_t height = CGImageGetHeight([image CGImage]);
#if 1
        drInfo = [[DrCardInfo alloc] init];
        int nStatus = 0;
        EXDRCard exdrCard;
        unsigned char *pbImage = NULL;
        int nCardW, nCardH, nStride;
        
        //get DRCardInfo
        nStatus = EXDRCardRecoStillImageRGBA32ST(pdata, (int)width, (int)height, (int)width*4, 1, &exdrCard);
        if(nStatus > 0)
        {
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //normal info
            drInfo.name = [NSString stringWithCString:(char *)exdrCard.szName encoding:gbkEncoding];
            drInfo.sex = [NSString stringWithCString:(char *)exdrCard.szSex encoding:gbkEncoding];
            drInfo.nation = [NSString stringWithCString:(char *)exdrCard.szNation encoding:gbkEncoding];
            drInfo.cardId = [NSString stringWithCString:(char *)exdrCard.szCardID encoding:gbkEncoding];
            drInfo.address =  [NSString stringWithCString:(char *)exdrCard.szAddress encoding:gbkEncoding];
            drInfo.birth =  [NSString stringWithCString:(char *)exdrCard.szBirth encoding:gbkEncoding];
            drInfo.issueDate =  [NSString stringWithCString:(char *)exdrCard.szIssue encoding:gbkEncoding];
            drInfo.driveType =  [NSString stringWithCString:(char *)exdrCard.szClass encoding:gbkEncoding];
            drInfo.validDate =  [NSString stringWithCString:(char *)exdrCard.szValid encoding:gbkEncoding];
            
            //convert image
            nCardW = exdrCard.imCard->width;
            nCardH = exdrCard.imCard->height;
            nStride= nCardW*4;
            pbImage = (unsigned char*)malloc(nCardH*nStride);
            if(pbImage){
                //缓存图像数据
                Convert2AGBR(exdrCard.imCard, pbImage, nCardW, nCardH, nStride);
             
                //获得CGImage
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef context = CGBitmapContextCreate(pbImage, nCardW, nCardH, 8, nStride, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
                CGImageRef quartzImage = CGBitmapContextCreateImage(context);
                
                if(GET_FULLIMAGE){
                    drInfo.fullImg = [UIImage imageWithCGImage:quartzImage];
                }
                
                CFRelease(quartzImage);
                CGContextRelease(context);
                CGColorSpaceRelease(colorSpace);
                
                free(pbImage);
            }

        }
        //释放图像
        EXDRCardFreeST(&exdrCard);
        free(pdata);
        
        NSLog(@"%@", [drInfo toString]);
//        if (drInfo !=nil && [drInfo isOK]) {
        if (drInfo !=nil && nStatus > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicator stopAnimating];
                self.promptView.hidden = YES;
                self.backgroundView.hidden = YES;
                target.view.userInteractionEnabled = YES;
                if ([self.delegate respondsToSelector:@selector(didFinishPhotoRec)]) {
                    [self.delegate didFinishPhotoRec];
                }
                [self.delegate didEndPhotoRecDRWithResult:drInfo from:self];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicator stopAnimating];
                self.promptView.hidden = YES;
                self.backgroundView.hidden = YES;
                target.view.userInteractionEnabled = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法识别该图片，请手动输入驾驶证信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
        }
#endif
    }
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        drInfo.fullImg = originImg;
        if ([self.delegate respondsToSelector:@selector(didFinishPhotoRec)]) {
            [self.delegate didFinishPhotoRec];
        }
        [self.delegate didEndPhotoRecDRWithResult:drInfo from:self];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Photo picked");
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"found an image");
        NSLog(@"image ==== %@",image);
        originImg = image;

        [self.indicator startAnimating];
        self.promptView.hidden = NO;
        self.backgroundView.hidden = NO;
        target.view.userInteractionEnabled = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self doRec:image];
        });
    }
    [target dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self.delegate respondsToSelector:@selector(didFinishPhotoRec)]) {
        [self.delegate didFinishPhotoRec];
    }
    [target dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIImage & RGB
- (unsigned char *) convertUIImageToBitmapRGBA8:(UIImage *) image {
    
    CGImageRef imageRef = image.CGImage;
    
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];
    
    if(!context) {
        return NULL;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    // Copy the data and release the memory (return memory allocated with new)
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    
    unsigned char *newBitmap = NULL;
    
    if(bitmapData) {
        newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);
        
        if(newBitmap) {    // Copy the data
            for(int i = 0; i < bufferLength; ++i) {
                newBitmap[i] = bitmapData[i];
            }
        }
        
        free(bitmapData);
        
    } else {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    
    CGContextRelease(context);
    
    return newBitmap;
}

- (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast);    // RGBA
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

- (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height {
    
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,    // data provider
                                    NULL,        // decode
                                    YES,            // should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 bitmapInfo);
    
    if(context == NULL) {
        NSLog(@"Error context not created");
        free(pixels);
    }
    
    UIImage *image = nil;
    if(context) {
        
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }
        
        CGImageRelease(imageRef);
        CGContextRelease(context);
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels) {
        free(pixels);
    }
    return image;
}

#pragma mark - CVPixelBufferRef & UIImage
- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)(options),
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

-(UIImage*) getImageStream:(CVImageBufferRef)imageBuffer
{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(imageBuffer),
                                                 CVPixelBufferGetHeight(imageBuffer))];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    
    CGImageRelease(videoImage);
    return image;
}

@end
