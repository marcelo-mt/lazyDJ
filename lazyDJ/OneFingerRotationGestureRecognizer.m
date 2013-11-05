//
//  CircularGestureRecognizer.m
//

#include <math.h>

#import "OneFingerRotationGestureRecognizer.h"

#define INITIAL_SPEED 180

@interface OneFingerRotationGestureRecognizer()

@property(strong, nonatomic) NSDate *date;

@end

@implementation OneFingerRotationGestureRecognizer

// private helper functions
CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2);
CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB);

- (id)initWithMidPoint:(CGPoint)_midPoint
           innerRadius:(CGFloat)_innerRadius
           outerRadius:(CGFloat)_outerRadius
                target:(id<OneFingerRotationGestureRecognizerDelegate>)_target
{
    if ((self = [super initWithTarget:_target action:nil]))
    {
        midPoint = _midPoint;
        innerRadius = _innerRadius;
        outerRadius = _outerRadius;
        target = _target;
        self.hasMoved = NO;
    }
    return self;
}

#pragma mark - Helper functions.

CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2)
{
    // Calculates distance between point1 and point2.
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB)
{
    // Calculates angle between lineA (beginPointA, endPointA)
    // and lineB (beginPointB, enbPointB).
    CGFloat a = endLineA.x - beginLineA.x;
    CGFloat b = endLineA.y - beginLineA.y;
    CGFloat c = endLineB.x - beginLineB.x;
    CGFloat d = endLineB.y - beginLineB.y;

    CGFloat atanA = atan2(a, b);
    CGFloat atanB = atan2(c, d);

    // Convert radiants to degrees.
    return (atanA - atanB) * 180 / M_PI;
}

#pragma mark - UIGestureRecognizer implementation

- (void)reset
{
    [super reset];
    cumulatedAngle = 0;
    // Degrees/s
    angularSpeed = INITIAL_SPEED;
    angularDistance = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    NSLog(@"Touches Began");
    self.date = [NSDate date];
    
    if ([touches count] != 1)
    {
        NSLog(@"Failed");
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    // Call delegate.
    if ([target respondsToSelector: @selector(firstTouchView:)])
    {
        [target firstTouchView:self.view];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    NSLog(@"Touches Moved");
    if (self.state == UIGestureRecognizerStateFailed) return;

    CGPoint nowPoint  = [[touches anyObject] locationInView: self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView: self.view];

    // Make sure the new point is within the area.
    CGFloat distance = distanceBetweenPoints(midPoint, nowPoint);
    if (((0.80 * innerRadius) <= distance) &&
        (distance <= (1.0 * outerRadius))) {
        // Calculate rotation angle between two points.
        CGFloat angle = angleBetweenLinesInDegrees(midPoint, prevPoint, midPoint, nowPoint);
        
        // Check if movement was clockwise.
        if (angle < 0) {
            NSLog(@"Counterclock wise movement.");
            //self.state = UIGestureRecognizerStateFailed;
            // Doesn't end gesture.
            self.state = UIGestureRecognizerStatePossible;
            //[self rotationEnded];
            return;
            // Later set velocity to a negative value.
        }
        
        // Fix value, if the 12 o'clock position is between prevPoint and nowPoint.
        if (angle > 180) {
            angle -= 360;
        }
        else if (angle < -180) {
            angle += 360;
        }
        
        // Sum up single steps.
        cumulatedAngle += angle;
        angularDistance += angle;
        
        CGFloat speed = -1 * angularDistance / [self.date timeIntervalSinceNow];
        
        if (angularDistance > 90) {
            angularDistance = 0;
            self.date = [NSDate date];
        }
        
        // Call delegate.
        if ([target respondsToSelector: @selector(rotation: speed: andView:)]) {
            [target rotation:angle speed:speed andView:self.view];
        }
    }
    else {
        // finger moved outside the area
        self.state = UIGestureRecognizerStateFailed;
        [self rotationEnded];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesEnded:touches withEvent:event];

    NSLog(@"Touches Ended");
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
        
    }
    else {
        self.state = UIGestureRecognizerStateFailed;
    }
    
    [self rotationEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];

    self.state = UIGestureRecognizerStateFailed;
    
    
}

- (void)rotationEnded
{
    // Signals that rotation movement has ended!
    
    if ([target respondsToSelector: @selector(finalAngle: speed: andView:)])
    {
        [target finalAngle:cumulatedAngle
                     speed:INITIAL_SPEED
                   andView:self.view];
    }
    
    angularDistance = 0;
    cumulatedAngle = 0;
}

@end
