//
//  lazyDJViewController.m
//  lazyDJ
//
//  Created by Marcelo Toledo on 11/1/13.
//  Copyright (c) 2013 Marcelo Mingatos de Toledo. All rights reserved.
//

#import "lazyDJViewController.h"

#define ANIMATION_FPS 60

@interface lazyDJViewController ()

// TODO(mingatos): Refactor - Create a class that
//  controls how disc handles gestures and animates UIImageView.
//

@property (weak, nonatomic) IBOutlet UIImageView *leftDiscImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightDiscImageView;

@property (weak, nonatomic) IBOutlet UISlider *crossfaderSlider;

//@property (strong, nonatomic) UITapGestureRecognizer *leftDoubleTapGestureRecognizer;
//@property (strong, nonatomic) UITapGestureRecognizer *rightDoubleTapGestureRecognizer;
//@property (strong, nonatomic) OneFingerRotationGestureRecognizer *leftRotationGestureRecognizer;
//@property (strong, nonatomic) OneFingerRotationGestureRecognizer *rightRotationGestureRecognizer;

@property (strong, nonatomic) MyAvAudioPlayer *leftDiscAudio;
@property (strong, nonatomic) MyAvAudioPlayer *rightDiscAudio;

@property (strong, nonatomic) NSTimer *leftDiscSpinTimer;
@property (strong, nonatomic) NSTimer *rightDiscSpinTimmer;

@property (nonatomic) CGFloat leftDiscCurrentAngle;
@property (nonatomic) CGFloat rightDiscCurrentAngle;

@property (nonatomic) CGFloat leftDiscSpinningSpeed;
@property (nonatomic) CGFloat rightDiscSpinningSpeed;

@property (strong, nonatomic) lazyDJDisc *leftDisc;
@property (strong, nonatomic) lazyDJDisc *rightDisc;

@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UILabel *lazyDJLabel;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@end

// TODO(mingatos): decouple stuff. Elaborate on lazyDJDisc class.

@implementation lazyDJViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // lazyDisc init.
        self.leftDisc = [[lazyDJDisc alloc] initWithMP3FileName:@"Audiobeast"];
        self.rightDisc = [[lazyDJDisc alloc] initWithMP3FileName:@"Younevercantell"];
        
        // Little fix: Fox audio a little louder than Macarena audio.
        // Capping right audio to 70% max volume.
        self.rightDisc.audio.maxVolume = 0.7f;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Customizing crossfader slider.
    // For custom images in slider:
    //http://www.techrepublic.com/blog/software-engineer/better-code-uislider-basics-for-apple-ios/
    self.crossfaderSlider.layer.cornerRadius = 5;
    self.crossfaderSlider.layer.borderWidth = 1;
    self.crossfaderSlider.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.leftDisc.imageView = self.leftDiscImageView;
    self.rightDisc.imageView = self.rightDiscImageView;
    
    [self setupGestureRecognizers];
}

// To make things easier, the gesture recognizers are removed before rotation...
- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    [self removeAllGestureRecognizers];
    // improvement opportunity: translate the rotation angle
    //self.leftDiscCurrentAngle
    //imageAngle = 0;
    //imageAngularSpeed = 180;
    //self.leftDiscImageView.transform = CGAffineTransformMakeRotation(M_PI);
    //self.rightDiscImageView.transform = CGAffineTransformMakeRotation(M_PI);
}

// ... and added afterwards.
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setupGestureRecognizers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Helper mehtods
- (void)setupGestureRecognizers
{
    //
    //[self.leftDisc setupGestureRecognizersWithTarget:self
    //                                          action:@selector()]
    // Initializes and configures gesture recognizers.
    // One finger rotation for audio playback rate controll.
    // Double tap to toogle play/pause.
    
    // Left
    // Double tap
    self.leftDisc.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                                    action:@selector(leftPlayPauseToggle)];
    self.leftDisc.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    // Rotation
    CGPoint leftMidPoint = CGPointMake(self.leftDisc.imageView.frame.size.width / 2,
                                       self.leftDisc.imageView.frame.size.height / 2);
    CGFloat leftOutRadius = self.leftDisc.imageView.frame.size.width / 2;
    CGFloat leftInRadius = leftOutRadius / 3;
    self.leftDisc.rotationGestureRecognizer = [[OneFingerRotationGestureRecognizer alloc]
                                                initWithMidPoint:leftMidPoint
                                                     innerRadius:leftInRadius
                                                     outerRadius:leftOutRadius
                                                          target: self];
    
    // Right
    // Double tap
    self.rightDisc.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(rightPlayPauseToggle)];
    self.rightDisc.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    // Rotation
    CGPoint rightMidPoint = CGPointMake(self.rightDisc.imageView.frame.size.width / 2,
                                        self.rightDisc.imageView.frame.size.height / 2);
    CGFloat rightOutRadius = self.rightDisc.imageView.frame.size.width / 2;
    CGFloat rightInRadius = rightOutRadius / 3;
    self.rightDisc.rotationGestureRecognizer = [[OneFingerRotationGestureRecognizer alloc]
                                           initWithMidPoint:rightMidPoint
                                           innerRadius:rightInRadius
                                           outerRadius:rightOutRadius
                                           target: self];
    
    // Adding gestures to apropiate image views.
    [self.leftDisc.imageView addGestureRecognizer:self.leftDisc.doubleTapGestureRecognizer];
    [self.leftDisc.imageView addGestureRecognizer:self.leftDisc.rotationGestureRecognizer];
    
    [self.rightDisc.imageView addGestureRecognizer:self.rightDisc.doubleTapGestureRecognizer];
    [self.rightDisc.imageView addGestureRecognizer:self.rightDisc.rotationGestureRecognizer];
    
    // Specifying order of gesture recognizers.
    [self.leftDisc.rotationGestureRecognizer requireGestureRecognizerToFail:self.leftDisc.doubleTapGestureRecognizer];
    [self.rightDisc.rotationGestureRecognizer requireGestureRecognizerToFail:self.rightDisc.doubleTapGestureRecognizer];
}

- (void)removeAllGestureRecognizers
{
    // Removes all gesture recognizers from all views.
    [self.leftDisc.imageView removeGestureRecognizer:self.leftDisc.doubleTapGestureRecognizer];
    [self.leftDisc.imageView removeGestureRecognizer:self.leftDisc.rotationGestureRecognizer];
    [self.rightDisc.imageView removeGestureRecognizer:self.rightDisc.doubleTapGestureRecognizer];
    [self.rightDisc.imageView removeGestureRecognizer:self.rightDisc.rotationGestureRecognizer];
}

# pragma mark - Timers and spinning animation.


# pragma mark - Gestures
# pragma mark - Handling double tap gestures.

- (void)leftPlayPauseToggle
{
    // Toggles left audio play/pause.
    NSLog(@"Left Play/Pause");
    [self.leftDisc.audio togglePlayPause];
    if (self.leftDisc.audio.isPlaying) {
        [self.leftDisc startSpinning];
    } else {
        [self.leftDisc stopSpinning];
    }
    
}

- (void)rightPlayPauseToggle
{
    // Tgogles right audio play/pause.
    NSLog(@"Right Play/Pause");
    [self.rightDisc.audio togglePlayPause];
    if (self.rightDisc.audio.isPlaying) {
        [self.rightDisc startSpinning];
    } else {
        [self.rightDisc stopSpinning];
    }
}

# pragma mark - Rotation Gesture protocol
- (void)firstTouchView:(UIView *)touchedView
{
    //
    lazyDJDisc *disc = nil;
    
    if (touchedView == self.rightDisc.imageView) {
        disc = self.rightDisc;
    } else if (touchedView == self.leftDisc.imageView) {
        disc = self.leftDisc;
    } else {
        NSLog(@"Neither left nor right Disc. Not supposed to happen!");
    }
    
    // Save state and send pause signal.
    disc.audio.wasPlaying = disc.audio.isPlaying;
    [disc.audio pause];
    [disc stopSpinning];
}

- (void) rotation:(CGFloat)angle
            speed:(CGFloat)speed
          andView:(UIView *)touchedView
{
    
    NSLog(@"Moving %.2f %.2f", angle, speed);
    
    lazyDJDisc *disc = nil;
    
    if (touchedView == self.rightDisc.imageView) {
        disc = self.rightDisc;
    } else if (touchedView == self.leftDisc.imageView) {
        disc = self.leftDisc;
    } else {
        NSLog(@"Neither left nor right Disc. Not supposed to happen!");
    }
    
    [disc rotateDiscByAngle:angle];
    
    // Playback audio at rotation speed.
    // Normal rate: 180 degrees /s = 1.0
    // Lowest rate = 0.5
    // Highestrate = 2.0
    
    CGFloat convertedRate;
    
    [disc.audio play];
    
    if (speed < 5) {
        convertedRate = 0.0;
    } else {
        convertedRate = speed / 180;
    }
    
    [disc.audio setRateToValue:convertedRate];
    
    // Speed to rate mapping
    //if (speed < 18.0) {
        // To slow, don't play audio.
    //    [disc.audio pause];
    //} else {
        // Minimum rotation speed reached. Play audio.
    //    [disc.audio play];
    //    if (speed < 180.0) {
            // Rate between 0.5 and 1.0
    //        convertedRate = 0.5 + (18.0 * (speed / 10.0));
    //    } else if (speed > 360.0) {
            // To fast, cap at 360.0 degrees/s = 2.0
    //        convertedRate = 2.0;
    //    } else {
            // Rate between 1.0 and 2.0.
    //        convertedRate = 1.0 + (speed / 180.0);
    //    }
    //    NSLog(@"Converte Rate = %.2f", convertedRate);
        
    //    [disc.audio setRateToValue:convertedRate];
    //}
    

    
}

- (void) finalAngle:(CGFloat)angle
              speed:(CGFloat)speed
            andView:(UIView *)touchedView
{
    
    NSLog(@"Ended %.2f %.2f", angle, speed);
    
    // circular gesture ended, update text field
    // START ROTATIN BY ITSELF
    //imageAngularSpeed = speed;
    //[self updateTextDisplay];
    
    lazyDJDisc *disc = nil;
    
    if (touchedView == self.rightDisc.imageView) {
        disc = self.rightDisc;
    } else if (touchedView == self.leftDisc.imageView) {
        disc = self.leftDisc;
    } else {
        NSLog(@"Neither left nor right Disc. Not supposed to happen!");
    }
    
    // If audio was playing before rotating touched began
    // send play signal.
    if (disc.audio.wasPlaying) {
        // Reset normal rate.
        [disc.audio setRateToValue:1.0];
        [disc.audio play];
        [disc startSpinning];
        disc.audio.wasPlaying = NO;
    }
}


# pragma mark - Crossfadder slider control

- (IBAction)crossfaderSliderChanged:(id)sender
{
    //
    NSLog(@"Crossfader slider change.");
    CGFloat valueToFade = 0;
    CGFloat crossfaderValue = self.crossfaderSlider.value;
    MyAvAudioPlayer *audioToFade;
    
    if (crossfaderValue < 0) {
        // Slider to the left of mid point. Fade right sound.
        audioToFade = self.rightDisc.audio;
        valueToFade = 1 + crossfaderValue;
    } else if (crossfaderValue > 0) {
        // Slider to the right of mid point. Fade left sound.
        audioToFade = self.leftDisc.audio;
        valueToFade = 1 - crossfaderValue;
    }
    
    [audioToFade setVolumeToValue:valueToFade];
}


# pragma mark - Intro

- (IBAction)leftIntroDismiss:(id)sender
{
    CGRect introViewFrame = self.introView.frame;
    introViewFrame.origin.x = -introViewFrame.size.width;
    
    NSLog(@"Swipe");
    [self dismissIntroAnimation:introViewFrame];
}

- (IBAction)rightIntroDismiss:(id)sender
{
    CGRect introViewFrame = self.introView.frame;
    introViewFrame.origin.x = 2 * introViewFrame.size.width;
    
    NSLog(@"Swipe.");
    [self dismissIntroAnimation:introViewFrame];
}

- (void)dismissIntroAnimation:(CGRect)toFrame
{
    //CGRect napkinBottomFrame = self.napkinBottom.frame;
    //napkinBottomFrame.origin.y = self.view.bounds.size.height;
    
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.introView.frame = toFrame;
                         //self.napkinBottom.frame = napkinBottomFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    CGRect toLabelFrame = self.lazyDJLabel.frame;
    toLabelFrame.origin.x = toFrame.origin.x;
    [UIView animateWithDuration:0.9
                          delay:0.6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.lazyDJLabel.frame = toLabelFrame;
                     }
                     completion:^(BOOL bla){
                         NSLog(@"Bla");
                     }];
    
}

@end
