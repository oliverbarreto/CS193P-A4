//
//  GraphViewController.h
//  GraphingCalculator
//
//  Created by David Oliver Barreto Rodríguez on 04/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController <GraphViewDelegate> {
    float myScale;
    CGPoint myOrigin;
    id myExpression;

    GraphView *myGraphView;
    UILabel *scaleLabel;
}

@property (nonatomic) float myScale;
@property (nonatomic) CGPoint myOrigin;
@property (nonatomic, copy) id myExpression;

@property (retain) IBOutlet GraphView *myGraphView;
@property (nonatomic, retain) IBOutlet UILabel *scaleLabel;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
