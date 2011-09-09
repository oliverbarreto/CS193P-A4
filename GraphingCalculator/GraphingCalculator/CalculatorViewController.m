//
//  CalculatorViewController.m
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"


#pragma mark - Implementation & Synthesize Header

@interface CalculatorViewController() 
@property (readonly) CalculatorBrain *brain;  //Private & ReadOnly Model
@end

@implementation CalculatorViewController

@synthesize brain;
@synthesize display, displayMem, displayOperation, displayTypeOfAngleMetrics;
@synthesize radiansModeButton;
@synthesize editVariableModeEnabledButton;
//@synthesize myGraphViewMVC;

//-(GraphViewController *)myGraphViewMVC {
//    if (!myGraphViewMVC) {
//        myGraphViewMVC = [[GraphViewController alloc] init];
//    }
//    return myGraphViewMVC;
//}


#pragma mark - Utility Methods

- (BOOL)isDecimalPointValid {
    NSString *myDisplayString = self.display.text;
    NSRange myRange = [myDisplayString rangeOfString:@"."];
    
    if (myRange.length == 0) return YES;
    else return NO;
}


- (void)showAlertWithTitle:(NSString *)myTitle andMessage:(NSString *)myMessage {
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:myTitle
                                                      message:myMessage
                                                     delegate:self 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];

    [myAlert autorelease];
    [myAlert show];

    self.brain.errorMessage = @"";
}


- (NSString *)stringForPendingOperation {
    
    if ([self.brain.waitingOperation isEqual:@"="]) {
            //return self.displayOperation.text = [NSString stringWithFormat:@"Op: = %g ",self.brain.waitingOperand];
        return self.displayOperation.text = [NSString stringWithFormat:@"Op: = %g ",self.brain.waitingOperand];
    } else {
        return self.displayOperation.text = [NSString stringWithFormat:@"Op: %g %@ ",self.brain.waitingOperand, self.brain.waitingOperation];            
            //return self.displayOperation.text = [NSString stringWithFormat:@"Op: %g %@ ",self.brain.waitingOperand, self.brain.waitingOperation];            
    }
}


- (void)updateOptionsDisplays:(UIButton *)mySender {
    //Creates the right setup for Displaying content on all displays on screen
    
    NSString *myOperationDisplayMSG = @"Op: ";
    NSString static *myTypeOfAngleMetricsMSG = @"Deg";

    //If there is an error when performing an operation, nothing is updaed
    if (![self.brain.errorMessage isEqual:@""]) {
        myOperationDisplayMSG = self.brain.errorMessage;
        //[self showAlertWithTitle:@"Invalid Operation" andMessage:self.brain.errorMessage];
        self.brain.errorMessage = @"";
    
    } else {        
        //Checks state of typeOfAngleMetrics Rdn vs Deg and displays correct info on screen
        if ([mySender.titleLabel.text isEqual:@"Deg"] || [mySender.titleLabel.text isEqual:@"Rdn"]) {
            
            //Change image & text of Deg/Rdn Button & Display Text;  
            if (self.brain.radiansMode) { //Set state to work in Degrees, Show Button to show Radians text
                myTypeOfAngleMetricsMSG = [NSString stringWithFormat:@"Deg"];
                self.brain.radiansMode = NO;
                
                [radiansModeButton setTitle:@"Rdn" forState:UIControlStateNormal];
                //UIImage *myButtonImage = [UIImage imageNamed:@"Button_GreyLight_40.png"];
                [radiansModeButton setBackgroundImage:nil forState:UIControlStateNormal];
                
            } else {    //Set state to work in Radians, Show Button to show Degrees text
                myTypeOfAngleMetricsMSG = [NSString stringWithFormat:@"Rdn"];
                self.brain.radiansMode = YES;                
                
                [radiansModeButton setTitle:@"Deg" forState:UIControlStateNormal];
                UIImage *myButtonImage = [UIImage imageNamed:@"Button_GreyDark_40.png"];
                [radiansModeButton setBackgroundImage:myButtonImage forState:UIControlStateNormal];
            }   
        }
        
        if ([mySender.titleLabel.text isEqual:@"C"]) {
            myOperationDisplayMSG = @"Op: ";
            
        } else {
            if (self.brain.waitingOperand) {
                myOperationDisplayMSG = [self stringForPendingOperation];
            } else {
                myOperationDisplayMSG = [NSString stringWithFormat:@"Op: "];
            }            
        }
    }

    
    //Dsisplays updated content for all the Diplays
    self.displayMem.text = [NSString stringWithFormat:@"Mem: %g", self.brain.myMem];
    self.displayTypeOfAngleMetrics.text = myTypeOfAngleMetricsMSG;
    self.displayOperation.text = myOperationDisplayMSG;
}

#pragma mark - IBAction Methods

- (IBAction)digitPressed:(UIButton *)sender {
    //Performs actions when a Digit (number) is pressed
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber) {
        if ([digit isEqual:@"."]) {
            if ([self isDecimalPointValid]) {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
        } else {   
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {      
        self.display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
}


- (IBAction)operationPressed:(UIButton *)sender {
    //Checks if the user is in the middle of typing some number or its an final result from an operations or equals is pressed        
    if (userIsInTheMiddleOfTypingANumber) {
        self.brain.operand = [self.display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }

    //Evaluate before displaying 
    double result = [self.brain performOperation:sender.titleLabel.text];
    
    if ([CalculatorBrain variablesInExpression:self.brain.expression]) {
	
        display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
        self.displayOperation.text = @"Op: ";

	} else {
		
        display.text = [NSString stringWithFormat:@"%g", result];
	
    }

    //Update Displays in UI
    [self updateOptionsDisplays:sender];
}


- (IBAction)solvePressed:(id)sender {
    
    //If user is in the middle of typing a number when he press solve, set operand
    if (userIsInTheMiddleOfTypingANumber) {
        [self.brain setOperand:[display.text doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
        
    //If not = present at the end of internalExpression
    if (![[CalculatorBrain descriptionOfExpression:self.brain.expression] hasSuffix:@"= "]) {
        [self.brain performOperation: @"="];
    }
        
    //Call evaluateExpression:UssingVariablesValues:
    double myResult = [CalculatorBrain evaluateExpression:self.brain.expression
                                      usingVariableValues:self.brain.myVariables];
    
    //Displays updated content for all the Diplays
    self.display.text = [NSString stringWithFormat:@"%@ %g", [CalculatorBrain descriptionOfExpression:self.brain.expression],myResult];
    self.displayOperation.text = @"Op: ";
    
    [self.brain performOperation:@"C"];     //clears everything for next operation
}


- (IBAction)graphPressed:(id)sender {
    
    //If user is in the middle of typing a number when he press solve, set operand
    if (userIsInTheMiddleOfTypingANumber) {
        [self.brain setOperand:[display.text doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    //If not = present at the end of internalExpression
    if (![[CalculatorBrain descriptionOfExpression:self.brain.expression] hasSuffix:@"= "]) {
        [self.brain performOperation: @"="];
    }


    //Graph the expression (set initial zoom, evaluate the expression for all X axis values, draw points in graph, update graph view)

    GraphViewController *myGraphViewMVC = [[GraphViewController alloc] init];
    myGraphViewMVC.myExpression = self.brain.expression;
    myGraphViewMVC.title = [NSString stringWithFormat:@"%@ y", [CalculatorBrain descriptionOfExpression:self.brain.expression]];
    
    [self.navigationController pushViewController:myGraphViewMVC animated:YES];
    //[myGraphViewMVC release];    //In Dealloc because its a property
}


- (IBAction)variablePressed:(UIButton *)sender{

    NSString *myVariablePressed = sender.titleLabel.text;
    
    if ([myVariablePressed isEqual:@"Fn"]) {        
        //-- EXTRA CREDIT -- 
        //-- If Fn is Pressed, set/edit the Variable value in Array 
        //Checks state of editVariableModeEnabled and displays correct info on screen
                
        //Change image of Fn Button to look like pressed;  
        if (editVariableModeEnabled) {          //Editing Variables Mode Pressed
            editVariableModeEnabled = NO;
                
            //UIImage *myButtonImage = [UIImage imageNamed:@"Button_GreyLight_40.png"];
            [editVariableModeEnabledButton setBackgroundImage:nil forState:UIControlStateNormal];
                
        } else {                                //Editing Variables Mode NOT Pressed
            editVariableModeEnabled = YES;                
                
            UIImage *myButtonImage = [UIImage imageNamed:@"Button_GreyDark_40.png"];
            [editVariableModeEnabledButton setBackgroundImage:myButtonImage forState:UIControlStateNormal];
        }   
        
    } else if ([myVariablePressed isEqual:@"Vars"]) {        
        //Test Button for testing Error Conditions of the Model calling AlertView
        //Just for testing purposes of NSAlertView        

        [self showAlertWithTitle:@"Current Values of Variables" andMessage:[self.brain descriptionOfMyVariables]];

    } else if ([myVariablePressed isEqual:@"Exp"]) {        

        //Shows an AlertView Message with the current expression
        [self showAlertWithTitle:@"Current Expression" andMessage:[CalculatorBrain descriptionOfExpression:self.brain.expression]];
        
        
    } else {    //If there is an Variable in expression, displays expression

        if (!editVariableModeEnabled) {
            //if user is typing a number (not zero),multiply the number times the variable, 8x = 8 * X
            if ((userIsInTheMiddleOfTypingANumber) && (![self.display.text isEqual:@"0"])) {
                [self.brain setOperand:[self.display.text doubleValue]];
                [self.brain performOperation:@"*"];
            }
            
            userIsInTheMiddleOfTypingANumber = NO;
            
            if ([myVariablePressed isEqual:@"x"]) {               //Call SetVariableAsOperand:
                [self.brain setVariableAsOperand:@"x"];
                self.displayOperation.text = @"Op: ";
                
            } else if ([myVariablePressed isEqual:@"a"]) {        //Call SetVariableAsOperand:
                [self.brain setVariableAsOperand:@"a"];
                self.displayOperation.text = @"Op: ";
                
            } else if ([myVariablePressed isEqual:@"b"]) {        //Call SetVariableAsOperand:
                [self.brain setVariableAsOperand:@"b"];
                self.displayOperation.text = @"Op: ";
            }
            
            
            if ([CalculatorBrain variablesInExpression:self.brain.expression]) {
                
                self.display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
                self.displayOperation.text = @"Op: ";
                
            } else {
                //TODO - Pendiente de revisar si sigue funcionando TODO igual
                self.displayOperation.text = @"No Variables in Expression"; 
            }

        } else {
            
            //Set variable value, if there is a number on screen (zero is not allowed)
            if ((userIsInTheMiddleOfTypingANumber) && (![self.display.text isEqual:@"0"])) {
                
                NSMutableDictionary *myMutableVariables = [[NSMutableDictionary alloc] initWithDictionary:self.brain.myVariables copyItems:YES];
                
                if ([myMutableVariables objectForKey:myVariablePressed]) {
                    [myMutableVariables setObject:[NSNumber numberWithDouble:[self.display.text doubleValue]] forKey:myVariablePressed];
                
                }
                 
                self.brain.myVariables = [myMutableVariables autorelease];
                //[myMutableVariables autorelease];
                myMutableVariables = nil;
            }
            
            userIsInTheMiddleOfTypingANumber = NO;
        }
                
    }        
}




#pragma mark - View Lifecycle & Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    brain = [[CalculatorBrain alloc] init];
    
    self.title = @"Graphing Calculator";    //Main UINavigationController Title

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)releaseNilsOfOutlets {   //Utility methods for cleaning up  memory when finished
    self.display = nil;
    self.displayMem = nil;
    self.displayOperation = nil;
    self.displayTypeOfAngleMetrics = nil;
    self.radiansModeButton = nil;
    self.editVariableModeEnabledButton = nil;
}

- (void)viewDidUnload {

    // Releasing my own created IBOutlet objects
    [self releaseNilsOfOutlets];
    
    [super viewDidUnload];
}

- (void)dealloc {
    
    // Releasing my own created IBOutlet objects
    [self releaseNilsOfOutlets];

    // Releasing my own created objects
    [brain release];  
    //[myGraphViewMVC release];    
    
    [super dealloc];
}
@end
