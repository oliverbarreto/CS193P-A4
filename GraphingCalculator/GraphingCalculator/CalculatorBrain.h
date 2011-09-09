//
//  CalculatorBrain.h
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 BildOneIdeas. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject {

@private
    double operand;                 //Standard CalculatorBrain iVars
    double myMem;                   //Basic Memory Operations
    double waitingOperand;          //to keep track of waiting operation when you try 

    BOOL radiansMode;               //FALSE=Degrees;TRUE=Radians

    NSString *waitingOperation;     //to do something like "2 + 3 * 5 ="
    NSString *errorMessage;         //Sends Warning & Error Messages to ViewController

    NSDictionary *myVariables;          //Dictionary of variables for solving expression
    NSMutableArray *internalExpression; //Records Current Expression
}

//Basic Model Properties
@property (nonatomic) double operand, myMem, waitingOperand;
@property BOOL radiansMode;
@property (nonatomic, retain) NSString *waitingOperation;
@property (nonatomic, retain) NSString *errorMessage;
@property (nonatomic, retain) NSDictionary *myVariables;


//Basic Operations Management
- (void)setOperand:(double)aDouble;
- (double)performOperation:(NSString *)operation;       

//Expression Operation Management
- (NSString *)descriptionOfMyVariables;

@property (readonly) id expression;
- (void)setVariableAsOperand:(NSString *)variableName;  
+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
