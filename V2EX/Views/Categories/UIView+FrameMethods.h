//
//  UIView+FrameMethods.h
//  V2EX
//
//  The file created and edited by WildCat on 2/11/14.
//  Reference: http://segmentfault.com/q/1010000000119371
//

#import <UIKit/UIKit.h>

@interface UIView (FrameMethods)
//Move methods

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical;

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded;

- (void)moveToHorizontal:(CGFloat)horizontal;

- (void)moveToVertical:(CGFloat)vertical;

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical;

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical setWidth:(CGFloat)width setHeight:(CGFloat)height;

//Set width/height

- (void)setWidth:(CGFloat)width height:(CGFloat)height;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

//Add width/height

- (void)addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded;

- (void)addWidth:(CGFloat)widthAdded;

- (void)addHeight:(CGFloat)heightAdded;

//Set corner radius

- (void)setCornerRadius:(CGFloat)radius;

- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor;

- (CGRect)frameInWindow;
@end
