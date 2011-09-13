//
//  GraphView.m
//  GraphingCalculator
//
//  Created by David Oliver Barreto Rodríguez on 02/09/11.
//  Copyright 2011 BuildOneIdeas. All rights reserved.
//

#import "GraphView.h"

#pragma mark - Property Methods

@implementation GraphView
@synthesize delegate;

#define DEFAULT_SCALE 14;

- (CGPoint)origin {
    return origin;
}

- (void)setOrigin:(CGPoint)anOrigin {
    
    if ((origin.x != anOrigin.x) && (origin.y != anOrigin.y)) {
        origin = anOrigin;
        [self setNeedsDisplay];

        // Protocol Call to update the Data in GraphViewController
        // Views don't own their data
        //[delegate originMovedTo:origin for:self]; 
    }    
}


- (CGFloat)scale {
    return (scale) ? scale : DEFAULT_SCALE;
}

- (void)setScale:(CGFloat)anScale {
    if ((anScale != 0 ) && (scale != anScale)) {
        scale = anScale;
        [self setNeedsDisplay];

        // Protocol Call to update the Data in GraphViewController
        // Views don't own their data
        //[delegate scaleChangedTo:scale for:self]; 
    }
    
}

#pragma mark - Implementation

- (void)setup {
    self.contentMode = UIViewContentModeRedraw; //redraw everytime the view changes
    self.origin = CGPointZero;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
        
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}


#pragma mark - Utility Methods

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor redColor] setStroke];
	CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
	CGContextStrokePath(context);
	UIGraphicsPopContext();
}


#pragma mark - Testing Drawing

- (void)testingDrawing:(CGRect)rect {
    //-- TESTING DRAWING: Draws the X&Y Axis & a red circle 
    CGPoint centerPointOfGraphView;
    centerPointOfGraphView.x = self.bounds.origin.x + self.bounds.size.width/2;
    centerPointOfGraphView.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat sizeOfGraphView = self.bounds.size.width/2;     //prepare for rotation
    if (sizeOfGraphView > self.bounds.size.height/2) sizeOfGraphView = self.bounds.size.height/2;
    
    //prepare for scale property
    //sizeOfGraphView *= 1.0;                             
    if ([self.delegate scaleForGraphView:self] > 0 ) {
        sizeOfGraphView *= [self.delegate scaleForGraphView:self];
    } else {
        sizeOfGraphView *= 1;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawCircleAtPoint:centerPointOfGraphView withRadius:sizeOfGraphView inContext:context];
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:centerPointOfGraphView scale:[self.delegate scaleForGraphView:self]];

}

#pragma mark - DrawRect Method to override

- (void) drawExpressionInGraph:(CGRect)rect originAtPoint:(CGPoint)
    // Drawing of the graph in the axis, in red lines

    centerPointOfGraphView scale:(CGFloat)myScale {

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);

    for (CGFloat i = 0; i <= self.bounds.size.width; i++) {
        CGPoint nextPointInViewCoordinates = CGPointMake(0,0);
        CGPoint nextPointInGraphCoordinates = CGPointMake(0,0);
    
        // View Value of X
        nextPointInViewCoordinates.x = i;
    
    
        //        NSLog(@"Scale: %.4f", [self.delegate scaleForGraphView:self]);
    
        // Graph value of x
        nextPointInGraphCoordinates.x = (nextPointInViewCoordinates.x - centerPointOfGraphView.x) / (myScale * self.contentScaleFactor);
    
        // Graph value of y
        nextPointInGraphCoordinates.y = ([self.delegate expressionYValueResultForXValue:nextPointInGraphCoordinates.x forRequestor:self]);
    
        // View Value of Y
        nextPointInViewCoordinates.y = centerPointOfGraphView.y - (nextPointInGraphCoordinates.y * myScale * self.contentScaleFactor);		
    //        NSLog(@"Drawing Points:");
    //        NSLog(@"Point In VIEW coordinates: (x = %.2f, y = %.2f)",nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
    //        NSLog(@"Point In GRAPH coordinates: (x = %.2f, y = %.2f)",nextPointInGraphCoordinates.x, nextPointInGraphCoordinates.y);
    //        NSLog(@"Scale: %.4f", [self.delegate scaleForGraphView:self]);
    //        NSLog(@"ContentScaleFactor: %.2f", self.contentScaleFactor);
    
        
    //-- LINES APPROACH
    //-- Start Drawing lines on the graph
        if (i == 0) {
            CGContextMoveToPoint(context, nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
        } else {
            CGContextAddLineToPoint(context, nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
        }        
    
    }

    [[UIColor redColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    UIGraphicsPopContext();
}




- (void)drawRect:(CGRect)rect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
{
    //[self testingDrawing:rect];   //Draws the X&Y axis and a Red Circle
    
    //-- Step 1: Draw the X&Y Axis
    
    CGPoint centerPointOfGraphView;
    
    centerPointOfGraphView.x = self.origin.x 
                                + self.bounds.origin.x 
                                + self.bounds.size.width/2;
    
    centerPointOfGraphView.y = self.origin.y 
                                + self.bounds.origin.y 
                                + self.bounds.size.height/2;

    [[UIColor blueColor] setStroke];
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:centerPointOfGraphView scale:self.scale];
    

    //-- Step 2: Draw the Y value of Expression for each X Axis value

    [self drawExpressionInGraph:rect originAtPoint:centerPointOfGraphView scale:self.scale]; 
}    



#pragma mark - UIGesture Recognizers

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) 
    {
        CGPoint translation = [recognizer translationInView:self];
        
        //-- Move the graph in the GraphView
        self.origin = CGPointMake(self.origin.x + translation.x, 
                                  self.origin.y + translation.y);
        
        [recognizer setTranslation:CGPointZero inView:self];  //Reset for next gesture
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) 
    {   
        //-- Scale the graph in the GraphView
        NSLog(@"recognizer.scale = %.4f , self.scale = %.4f",recognizer.scale, self.scale);
        self.scale *= recognizer.scale;

        NSLog(@"recognizer.scale = %.4f , self.scale = %.4f",recognizer.scale, self.scale);
        recognizer.scale = 1;  //Reset for next gesture

        NSLog(@"recognizer.scale = %.4f , self.scale = %.4f",recognizer.scale, self.scale);
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) 
    {   
        //-- Center the graph in the GraphView
        self.origin = CGPointZero;        
    }
    
    
}


@end
