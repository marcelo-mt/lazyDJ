//
//  CircularGestureRecognizer.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol OneFingerRotationGestureRecognizerDelegate <NSObject>
@optional
- (void) firstTouchView:(UIView *)touchedView;
- (void) rotation:(CGFloat)angle speed:(CGFloat)speed andView:(UIView *)touchedView;
- (void) finalAngle:(CGFloat)angle speed:(CGFloat)speed andView:(UIView *)touchedView;
@end

@interface OneFingerRotationGestureRecognizer : UIGestureRecognizer
{
    CGPoint midPoint;
    CGFloat innerRadius;
    CGFloat outerRadius;
    CGFloat cumulatedAngle;
    CGFloat angularSpeed;
    CGFloat angularDistance;
    id <OneFingerRotationGestureRecognizerDelegate> target;
}

@property (nonatomic) BOOL hasMoved;
@property (nonatomic, readonly) CGFloat velocity;

- (id) initWithMidPoint: (CGPoint) midPoint
            innerRadius: (CGFloat) innerRadius
            outerRadius: (CGFloat) outerRadius
                 target: (id) target;
- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

