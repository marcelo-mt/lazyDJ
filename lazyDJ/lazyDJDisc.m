//
//  lazyDJDisc.m
//  lazyDJ
//
//  Created by Marcelo Toledo on 11/1/13.
//  Copyright (c) 2013 Marcelo Mingatos de Toledo. All rights reserved.
//

#import "lazyDJDisc.h"

@implementation lazyDJDisc

- (id)initWithMP3FileName:(NSString *)mp3FileName
{
    self = [super init];
    if (self) {
        self.audio = [[MyAvAudioPlayer alloc] initWithMP3FileName:mp3FileName];
        self.spinTimer = nil;
        // Degrees
        self.currentAngle = 0;
        // Degrees/s
        self.spinningSpeed = 0;
    }
    return self;
}

- (void)rotateDiscByAngle:(CGFloat)angleToRotate
{
    [self addToCurrentAngle:angleToRotate];
    self.imageView.transform = CGAffineTransformMakeRotation((self.currentAngle * M_PI) / 180.0);
}

- (void)addToCurrentAngle:(CGFloat)angleToAdd
{
    // Adds an angle to the disc current angle
    // fixing for a full 360 rotation value.
    
    self.currentAngle += angleToAdd;
    if (self.currentAngle > 360)
        self.currentAngle -= 360;
    else if (self.currentAngle < -360)
        self.currentAngle += 360;
}

- (void)startSpinning
{
    // Enables animation by setting up timer.
    self.spinTimer = [NSTimer
                      scheduledTimerWithTimeInterval:(1.0/SPIN_ANIMATION_CPS)
                      target:self
                      selector:@selector(spinTimerHandler:)
                      userInfo:nil
                      repeats:YES];
}

- (void)spinTimerHandler:(NSTimer *)theTimer
{
    //
    [self rotateDiscByAngle:SPIN_ANIMATION_DEFAULT_SPEED / SPIN_ANIMATION_CPS];
}

- (void)stopSpinning
{
    // Disables animation by invalidating timer.
    [self.spinTimer invalidate];
    self.spinTimer = nil;
}

@end




//- (void)rotateDisc:(UIImageView *)discImageView byAngle:(CGFloat)angle
//{
//    //
//    CGFloat discAngle;
//    
//    if (discImageView == self.leftDiscImageView) {
//        
//    } else if (discImageView == self.rightDiscImageView) {
//        
//    } else {
//        NSLog(@"Neither left nor right. This shouldn't happen.");
//    }
//}
//
//- (IBAction)spinDisc:(id)sender
//{
//    NSLog(@"spinDisc");
//    imageAngle += 6;
//    
//    self.discIsSinning = !self.discIsSinning;
//    
//    if (self.discIsSinning) {
//        NSLog(@"Is spinning");
//        [self.spinButton setTitle:@"Stop" forState:UIControlStateNormal];
//        //        [self.spinTimer release];
//        if (!self.spinTimer) {
//            [self fireSpinningTimer];
//            
//        }
//    } else {
//        NSLog(@"Not spinning");
//        //[self.spinTimer invalidate];
//        [self.spinButton setTitle:@"Spin" forState:UIControlStateNormal];
//    }
//}
//
//- (void)fireSpinningTimer
//{
//    //NSLog(@"Firing timer!");
//    self.spinTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/FPS)
//                                                      target:self
//                                                    selector:@selector(handleSpinTimer:)
//                                                    userInfo:@6
//                                                     repeats:YES];
//}
//
//- (void)handleSpinTimer:(NSTimer *)theTimer
//{
//    if (self.discIsSinning) {
//        //CGFloat angle;
//        // NSLog(@"TIMER");
//        // calculate rotation angle
//        imageAngle += angle*(self.rateSlider.value+0.5);
//        if (imageAngle > 360)
//            imageAngle -= 360;
//        else if (imageAngle < -360)
//            imageAngle += 360;
//        
//        image.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
//        
//    }
//}
