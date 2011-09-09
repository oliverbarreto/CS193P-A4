//
//  GraphView.h
//  GraphingCalculator
//
//  Created by David Oliver Barreto Rodríguez on 02/09/11.
//  Copyright 2011 BuildOneIdeas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphView;

@protocol GraphViewDelegate 
- (float)scaleForGraphView:(GraphView *)requestor;      //scale > 0
- (CGPoint)originForGraphView:(GraphView *)requestor;   //origin of graph on screen coordinates
- (double)expressionYValueResultForXValue:(CGFloat)xValue forRequestor:(GraphView *)graphView;

    //-- Yet more to be defined !!!

@end


@interface GraphView : UIView {
    id <GraphViewDelegate> delegate;

}
@property (assign) id <GraphViewDelegate> delegate;
@end
