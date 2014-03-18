//
//  UIView+FrameMethods.m
//  V2EX
//
//  The file created and edited by WildCat on 2/11/14.
//  Reference: http://segmentfault.com/q/1010000000119371
//

#import "UIView+FrameMethods.h"

@implementation UIView (FrameMethods)

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x + horizontal, originRect.origin.y + vertical, originRect.size.width, originRect.size.height);
    self.frame = newRect;
}

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x + horizontal,
                                originRect.origin.y + vertical,
                                originRect.size.width + widthAdded,
                                originRect.size.height + heightAdded);
    self.frame = newRect;
}

- (void)moveToHorizontal:(CGFloat)horizontal
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(horizontal, originRect.origin.y, originRect.size.width, originRect.size.height);
    self.frame = newRect;
}

- (void)moveToVertical:(CGFloat)vertical
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, vertical, originRect.size.width, originRect.size.height);
    [self setFrame:newRect];
}

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(horizontal, vertical, originRect.size.width, originRect.size.height);
    self.frame = newRect;
}

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical setWidth:(CGFloat)width setHeight:(CGFloat)height
{
    CGRect newRect = CGRectMake(horizontal, vertical, width, height);
    self.frame = newRect;
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, width, height);
    self.frame = newRect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, width, originRect.size.height);
    self.frame = newRect;
}

- (void)setHeight:(CGFloat)height
{
    NSLog(@"set height");
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, height);
    self.frame = newRect;
}

- (void)addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded
{
    CGRect originRect = self.frame;
    CGFloat newWidth = originRect.size.width + widthAdded;
    CGFloat newHeight = originRect.size.height + heightAdded;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, newWidth, newHeight);
    self.frame = newRect;
}

- (void)addWidth:(CGFloat)widthAdded
{
    [self addWidth:widthAdded addHeight:0];
}

- (void)addHeight:(CGFloat)heightAdded
{
    [self addWidth:0 addHeight:heightAdded];
}

- (void)setCornerRadius:(CGFloat)radius
{
    [self setCornerRadius:radius borderColor:[UIColor grayColor]];
}

- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor
{
    [self.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self.layer setBorderColor:[borderColor CGColor]];
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
    self.clipsToBounds = YES;
}

- (CGRect)frameInWindow
{
    CGRect frameInWindow = [self.superview convertRect:self.frame toView:self.window];
    return frameInWindow;
}
@end