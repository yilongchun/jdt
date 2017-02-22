
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface IDContextManager : NSObject
+ (instancetype)sharedInstance;
@property (strong, nonatomic, readonly) EAGLContext *eaglContext;
@property (strong, nonatomic, readonly) CIContext *ciContext;
@end