//
//  GraphViewController.m
//  GraphingCalculator
//
//  Created by David Oliver Barreto Rodríguez on 04/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"


#pragma mark - Property Methods

@implementation GraphViewController
@synthesize myScale, myOrigin;
@synthesize myGraphView;
@synthesize scaleLabel;
@synthesize myExpression;

-(void)updateMyUI {
    self.scaleLabel.text = [NSString stringWithFormat:@"Scale: %.2f", self.myScale];
    [self.myGraphView setNeedsDisplay];
}

- (void)setMyExpression:(id)newExpression {
    [myExpression release];
    myExpression = [newExpression copy];    
    
    if (myGraphView.window) [myGraphView setNeedsDisplay];
}

- (void)setMyScale:(float)newScale {
    if (newScale == 0) {
        myScale = 1.0;
    } else {
        myScale = newScale;
    }
    
    [self updateMyUI];
}


#pragma mark - Initialization

- (void)setup {
    self.myOrigin = CGPointMake(0,0);
    self.myScale = 14.0;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (void)awakeFromNib { 
    [self setup];

}


#pragma mark - GraphView Protocol Implementation

- (float)scaleForGraphView:(GraphView *)requestor {  
    //scale > 0
    return self.myScale; 
}


- (CGPoint)originForGraphView:(GraphView *)requestor {  
    //Sets the origin for the graph on screen, in GraphView bounds coordinates
    return self.myOrigin;
}

- (double)expressionYValueResultForXValue:(CGFloat)xValue forRequestor:(GraphView *)graphView {

	//NSDictionary *evaluateWithXValue = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:((xValue * 180) / M_PI)] forKey:@"x"];
	NSDictionary *evaluateWithXValue = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:xValue] forKey:@"x"];
        
    double yValue = [CalculatorBrain evaluateExpression:self.myExpression usingVariableValues:evaluateWithXValue];

    return yValue;

}


//#pragma mark - IBAction Methods
//
//- (void)zoomIn:(id)sender {
//    self.myScale *= 0.8;
//}
//
//- (void)zoomOut:(id)sender {
//    self.myScale /= 0.8;
//}



#pragma mark - View Lifecycle & Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.myGraphView.delegate = self;
    
    
    // Add Gesture Recognizers to GraphView
    UIGestureRecognizer *panGesture =
        [[UIPanGestureRecognizer alloc] initWithTarget:myGraphView action:@selector(pan:)];
    //[panGesture setMinimumNumberOfTouches:1];
	//[panGesture setMaximumNumberOfTouches:1];
    [myGraphView addGestureRecognizer:panGesture];
    [panGesture release];
    
    UIGestureRecognizer *pinchGesture =
    [[UIPinchGestureRecognizer alloc] initWithTarget:myGraphView action:@selector(pinch:)];
    [myGraphView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UIGestureRecognizer *doubleTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:myGraphView action:@selector(doubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [myGraphView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
    
    //Update UI before getting out
    [self updateMyUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}

-(void)releaseNilsOfOutlets {
    self.scaleLabel = nil;
}

- (void)dealloc {

    [self releaseNilsOfOutlets];    
    [myExpression release];
    [myGraphView release];
    
    [super dealloc];
}

@end
