

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "../IdInfo.h"
#import "../../cardcore/excards.h"

#define KSHThumbnailCreatedNotification @"KSHThumbnailCreated"

@protocol IDCameraControllerDelegate <NSObject>
- (void)deviceConfigurationFailedWithError:(NSError*)error;
- (void)mediaCaptureFailedWithError:(NSError*)error;
- (void)assetLibraryWriteFailedWithError:(NSError*)error;
@end

@protocol IDRecDelegate <NSObject>

-(CGRect)getEffectImageRect:(CGSize)size;
-(void)IDCardRecognited:(IdInfo*)idInfo;
-(BOOL)checkIDResult:(IdInfo*)idInfo;
@end

@interface IDCameraController : NSObject
@property (nonatomic, weak) id <IDCameraControllerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, assign, readonly) NSUInteger cameraCount;
@property (nonatomic, assign, readonly) BOOL cameraHasTorch;
@property (nonatomic, assign, readonly) BOOL cameraHasFlash;
@property (nonatomic, assign, readonly) BOOL cameraSupportsTapToFocus;
@property (nonatomic, assign, readonly) BOOL cameraSupportsTapToExpose;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
@property (nonatomic, assign, readonly) NSTimeInterval recordedDuration;
@property (nonatomic, copy) NSString *sessionPreset;
@property (nonatomic, weak) id<IDRecDelegate> recDelegate;
@property (nonatomic, assign) BOOL filterEnable;

@property (nonatomic, assign) BOOL bInProcessing; 
@property (nonatomic, assign) BOOL bHasResult;
@property (nonatomic, assign) BOOL bShouldStop;

@property BOOL bShowCutImg;

- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;

- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

- (void)captureStillImage;
- (void)resetRecParams;
//- (void)flashlight;

//- (void)startRecording;
//- (void)stopRecording;
//- (BOOL)isRecording;
@end
