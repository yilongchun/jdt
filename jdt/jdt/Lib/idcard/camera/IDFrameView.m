//
//  KSFrameView.m
//  MosiacCamera
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 kimsungwhee.com. All rights reserved.
//

#import "IDFrameView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCANLINE_SPEED 5
@interface IDFrameView()
{
    int LINE_LENGTH;
    int SCANLINE_WIDTH;
    int scan_num;
}
//扫描线
@property (nonatomic, strong) UIImageView * line;
@end

@implementation IDFrameView
@synthesize promptLabel;
@synthesize timer;
@synthesize line_timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        if (SCREEN_WIDTH - 320 < 1) {   //ip4, ip5
            SCANLINE_WIDTH = 14;
        } else {                        //ip6
            SCANLINE_WIDTH = 18;
        }
        LINE_LENGTH = frame.size.width / 10;
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
         self.timer = [NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        scan_num = 0;
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCANLINE_WIDTH, frame.size.width)];
        _line.image = [UIImage imageNamed:@"exocr-scan_line_portrait.png"];
        _line.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_line];
        _line.transform = transform;
        _line.center = CGPointMake(frame.size.width/2, 0);
        self.line_timer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
        [self.line_timer fire];
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.textColor = [UIColor greenColor];
        promptLabel.font = [UIFont boldSystemFontOfSize:20];
        promptLabel.text = @"请将身份证放在屏幕中央，正面朝上";
        [self addSubview:promptLabel];
        promptLabel.transform = transform;
        float x = frame.size.width * 22 / 54;
        x = x + (frame.size.width - x) / 2;
        promptLabel.center = CGPointMake(x, frame.size.height/2);
    }
    return self;
}
-(void)dealloc{
//    [self.timer invalidate];
//    [self.line_timer invalidate];
}

-(void)lineAnimation
{
    //scan line
    scan_num ++;
    if (SCANLINE_SPEED*scan_num >= self.frame.size.height) {
        scan_num = 0;
    }
    _line.center = CGPointMake(self.frame.size.width/2, SCANLINE_SPEED*scan_num);
}

-(void)timerFire:(id)notice
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 8.0);
    CGContextSetRGBStrokeColor(context, 0.3, 0.8, 0.3, 0.8);
    
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGContextMoveToPoint(context, pt.x, pt.y+LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + LINE_LENGTH, pt.y);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    CGContextMoveToPoint(context, pt.x - LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y + LINE_LENGTH);
    
    pt = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGContextMoveToPoint(context, pt.x, pt.y - LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + LINE_LENGTH, pt.y);
    
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(context, pt.x - LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y-LINE_LENGTH);
    CGContextStrokePath(context);

}

@end
