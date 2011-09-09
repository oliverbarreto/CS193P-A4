//
//  CalculatorViewController.h
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "GraphViewController.h"


@interface CalculatorViewController : UIViewController {
@private
    UILabel *display;                           //calculator main display
    UILabel *displayMem;                        //displays Current Memory Value
    UILabel *displayOperation;                  //displays Current Operation Array
    UILabel *displayTypeOfAngleMetrics;         //displays Deg. vs Rdns state 

    BOOL userIsInTheMiddleOfTypingANumber;      //To know if still typing numbers

    CalculatorBrain *brain;                     //My Model 

    BOOL editVariableModeEnabled;               //Set Mode for setting variables values
    UIButton *editVariableModeEnabledButton;

    UIButton *radiansModeButton;                //Set Mode: Deg vs Rads
    
    //GraphViewController *myGraphViewMVC;        //Remember the graph in UINavBar

}

//@property BOOL userIsInTheMiddleOfTyingANumber, stateForTypeOfAngleMetrics, editVariableModeEnabled;

@property (nonatomic, retain) IBOutlet UILabel *display, *displayMem,*displayOperation;
@property (nonatomic, retain) IBOutlet UILabel *displayTypeOfAngleMetrics;
@property (nonatomic, retain) IBOutlet UIButton *radiansModeButton;
@property (nonatomic, retain) IBOutlet UIButton *editVariableModeEnabledButton;

//@property (readonly) GraphViewController *myGraphViewMVC;

- (IBAction)digitPressed:(id)sender;
- (IBAction)operationPressed:(id)sender;
- (IBAction)variablePressed:(id)sender;
- (IBAction)solvePressed:(id)sender;
- (IBAction)graphPressed:(id)sender;

@end
