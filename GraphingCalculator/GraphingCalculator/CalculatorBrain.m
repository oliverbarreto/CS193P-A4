//
//  CalculatorBrain.m
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"_"    //Special Char diferenciates vars from actual operations


@interface CalculatorBrain()
@property (nonatomic, retain) NSMutableArray *internalExpression;
@end


@implementation CalculatorBrain

//* *****************************************************************************
//Basic Model Properties & iVars

@synthesize operand, waitingOperand,waitingOperation;   
@synthesize myMem;                                      
@synthesize radiansMode;                         
@synthesize errorMessage;
@synthesize myVariables;
@synthesize internalExpression;
@synthesize expression;


#pragma mark - Utility Methods

- (void)addItemToInternalExpressionArray:(id)myItem {
    
    //If myItem is an Operand, Throw in a NSString with the NSNumber
    if ([myItem isKindOfClass:[NSNumber class]]) {
        [self.internalExpression addObject:myItem]; 

    //If myItem is an Operation or a Variable, Throw in a NSSTring 
    } else if ([myItem isKindOfClass:[NSString class]]) {
        [self.internalExpression addObject:myItem]; 
    }
}

- (NSString *)descriptionOfMyVariables {
    
    //Enumerates through Property of MyVariables and set the right string to be returned back
    NSString *myDescriptionOfMyVariables = @"";

    for (id myItem in self.myVariables) {
        NSString *myItemValue = [[self.myVariables objectForKey:myItem] stringValue];

        myDescriptionOfMyVariables = [myDescriptionOfMyVariables stringByAppendingString:[NSString stringWithFormat:@"Var %@ = %@, \n", myItem, myItemValue]]; 
    }

    return myDescriptionOfMyVariables;
}


- (void)performWaitingOperation {
    //realiza la operación pendiente por realizar...
    
    if ([@"+" isEqual:waitingOperation]) {
        operand = self.waitingOperand + operand; 
        
    } else if ([@"-" isEqual:waitingOperation]) {
         operand = self.waitingOperand - operand; 

    } else if ([@"*" isEqual:self.waitingOperation]) {
        operand = self.waitingOperand * operand; 
    
    } else if ([@"/" isEqual:waitingOperation]) {
        if (operand){
            operand = self.waitingOperand / operand; 
        } else {
            self.errorMessage = [NSString stringWithFormat:@"Error: Div by 0"];
        }
    }
}


#pragma mark - Interface Methods

- (id) expression {
    //Returns an NSMutableArray as an ID object, so caller cannot idetentified the iVar 
    return [[internalExpression copy] autorelease];
}


- (void)setOperand:(double)anOperand {
    
    // "Throws" the operand in the internalExpression Array
    
    [self addItemToInternalExpressionArray:[NSNumber numberWithDouble:anOperand]];
    //[self.internalExpression addObject:[NSNumber numberWithDouble:anOperand]];
  
    // & then set the operand property as usual 
    operand = anOperand;    
} 


- (void)setVariableAsOperand:(NSString *)variableName {

    // "Throws" the operand in the internalExpression Array
    //... but before, it Appends the Variable_Prefix 

    [self addItemToInternalExpressionArray:[VARIABLE_PREFIX stringByAppendingString:variableName]];
}


-(double)performOperation:(NSString *)operation{

    // "Throws" the operand in the internalExpression Array
    [self addItemToInternalExpressionArray:operation];

    //checks for operations of 1 or two operands    
    if ([operation isEqual:@"sqrt"]) {
        if (operand >= 0 ) {
            operand = sqrt(self.operand);
        } else {
            self.errorMessage = [NSString stringWithFormat:@"Error: Sqrt of Negative Numbers is not implemented"];
      }
    } else if ([operation isEqual:@"1/x"]) {
        if (operand) {
            operand = 1 / self.operand;
        } else {
            self.errorMessage = [NSString stringWithFormat:@"Error: Div by 0"];
      }
    } else if ([operation isEqual:@"π"]) {
        operand = M_PI;
        
    } else if ([operation isEqual:@"M"]) {
        self.myMem = self.operand;

    } else if ([operation isEqual:@"MR"]) {
        operand = self.myMem;
        
    } else if ([operation isEqual:@"M+"]) {
        self.operand = self.operand + self.myMem;
        
    } else if ([operation isEqual:@"M-"]) {
        operand = self.operand - self.myMem;
        
    } else if ([operation isEqual:@"Sin"]) {
        if (self.radiansMode) {
            operand = sin(self.operand);               //Using Radians as argument
        } else { 
            operand = sin((self.operand * M_PI)/180);  //Using Degrees as argument
        }
        
    } else if ([operation isEqual:@"Cos"]) {
        if (self.radiansMode) {
            operand = cos(self.operand);               //Using Radians as argument
        } else { 
            operand = cos((self.operand * M_PI)/180);  //Using Degrees as argument
}
        
    } else if ([operation isEqual:@"+/-"]) {
        operand =  - self.operand;

    } else if ([operation isEqual:@"Del"]) {
        operand = 0;
        
    } else if ([operation isEqual:@"C"]) {      //Clears everything in brain
        operand = 0.0;
        waitingOperation = @"";
        waitingOperand = 0.0;
        self.errorMessage = @"";
        self.myMem = 0;
        
        [self.internalExpression removeAllObjects];
            
    } else {    
        
        [self performWaitingOperation];         //execute regular math operation
        self.waitingOperation = operation;      //prepare for next operation
        self.waitingOperand = self.operand;        
    }            

    return self.operand;    
}

#pragma mark - Class Methods

+ (BOOL)itemIsAVariable:(NSString * )myStringValue {
    
    NSRange myRange = [myStringValue rangeOfString:VARIABLE_PREFIX];
    
    //If Item is a Variable NSString with prefix
    if (myRange.length == 0)    return NO;
    else                        return YES;
} 


+ (NSSet *)variablesInExpression:(id)anExpression {

    //Enumerates through anExpression and buildsthe NSSet to be returned back
    NSMutableSet *myResultSet = [[NSMutableSet alloc] init];
    
    if ([anExpression isKindOfClass:[NSArray class]]) {     //Security check

        for (id myExpressionItem in anExpression) {         //Iterator over anExpression
            
            //If Item is a NSString (Variable or Operation)
            if ([myExpressionItem  isKindOfClass:[NSString class]]) {
                
                //If Item is a Variable NSString with prefix
                if ([CalculatorBrain itemIsAVariable:myExpressionItem]) {  
                    
                    //First Remove the variable prefix
                    myExpressionItem = [myExpressionItem stringByReplacingOccurrencesOfString:VARIABLE_PREFIX withString:@""];

                    if  (![myResultSet member:myExpressionItem]) {                
                        [myResultSet addObject:myExpressionItem];
                    }
                }
            }
        }
    }

    //Return nil if no variables are found in expression
    if ([myResultSet count] == 0) {
        [myResultSet release];
        myResultSet = nil;
    } else {
        [myResultSet autorelease];
    }
    return myResultSet;
}


+ (NSString *)descriptionOfExpression:(id)anExpression {

    //Enumerates through anExpression and set the right string to be returned back
    NSString *myDescriptionOfExpression = @"";
    
    for (id myExpressionItem in anExpression) {
        
        
        //If Item is a NSNumber
        if ([myExpressionItem isKindOfClass:[NSNumber class]]) {

            myDescriptionOfExpression = [[myDescriptionOfExpression stringByAppendingString:[myExpressionItem stringValue]] stringByAppendingString:@" "];

            
        //If Item is a NSString (Variable or Operation)
        } else if ([myExpressionItem  isKindOfClass:[NSString class]]) {
            
            //If Item is a Variable NSString with prefix
            if ([CalculatorBrain itemIsAVariable:myExpressionItem]) {  
                
                NSString *myVariable = [myExpressionItem stringByReplacingOccurrencesOfString:VARIABLE_PREFIX withString:@""]; 

                myDescriptionOfExpression = [myDescriptionOfExpression stringByAppendingString:[NSString stringWithFormat:@"%@ ", myVariable]];
                
            
            //If Item is an Operation NSString
            } else {                    
                
                myDescriptionOfExpression = [myDescriptionOfExpression stringByAppendingString:[NSString stringWithFormat:@"%@ ", myExpressionItem]];
            }
        }
    }
    return myDescriptionOfExpression;
}


+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables {
    
    //Create an instance of Calculator Class to be able to access iVars from Class Method
    CalculatorBrain *myEvaluatorBrain = [[CalculatorBrain alloc] init];  
    double myResult = 0;
    myEvaluatorBrain.radiansMode = YES;
    
    //Enumeration through the expression
    for (id myExpressionItem in anExpression) {
        
        //If Item is a NSNumber
        if ([myExpressionItem isKindOfClass:[NSNumber class]]) {
            myEvaluatorBrain.operand = [myExpressionItem doubleValue];
            
            //If Item is a NSString (Variable or Operation)
        } else if ([myExpressionItem  isKindOfClass:[NSString class]]) {
            
            //If Item is a Variable NSString with prefix
            if ([self itemIsAVariable:myExpressionItem]) {  
                
                NSString *myVariableKey = [myExpressionItem stringByReplacingOccurrencesOfString:VARIABLE_PREFIX withString:@""]; 
                
                [myEvaluatorBrain setOperand:[[variables objectForKey:myVariableKey] doubleValue]];
                
            //If Item is an Operation NSString
            } else {                    
                
                [myEvaluatorBrain performOperation:myExpressionItem];
            }
        }
    }
    
    // After the expression is evaluated, we call perform "=" operation 
    [myEvaluatorBrain performOperation:@"="];
    myResult = myEvaluatorBrain.operand;

    //Release of self created instance of CalculatorBrain
    [myEvaluatorBrain release];
    myEvaluatorBrain = nil;         
    
    return myResult;
    
}

+ (id)propertyListForExpression:(id)anExpression
{
    return [[anExpression retain] autorelease];
}

+ (id)expressionForPropertyList:(id)propertyList
{
    return [[propertyList retain] autorelease];
}



#pragma mark - Init & Dealloc

- (id)init {    // Custom initializator for CalculatorBrain

    if (self = [super init]) {
        //Error State Flag: Empty String = No Error;  
        self.errorMessage = [NSString stringWithFormat:@""];

        
        //Set initial state of variables values for solving expression
        self.myVariables = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:2.0], @"x",                                         
                                    [NSNumber numberWithDouble:3.0], @"a",                                             
                                    [NSNumber numberWithDouble:4.0], @"b", nil];

        //Set initial state of internalExpression Array
        self.internalExpression = [NSMutableArray array];
    }
    return  self;
}

         
-(void)dealloc {
    //release of all my self self-created iVars & Properties Objects
    [waitingOperation release]; 
    waitingOperation = nil;

    [errorMessage release];
    errorMessage = nil;
    
    [myVariables release];
    myVariables = nil;
    
    [internalExpression release];
    internalExpression = nil;
     
    [super dealloc];
}

@end
