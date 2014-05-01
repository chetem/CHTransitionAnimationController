//
//  CHTransitionAnimationController.h
//  CHTransitionAnimationControllerExample
//
//  Created by Chris Hetem on 5/1/14.
//  Copyright (c) 2014 Chris Hetem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHTransitionAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

typedef enum {
    CHTransitionAnimationTypeGrow,
    CHTransitionAnimationTypeShrink,
	CHTransitionAnimationTypeFade
} CHTransitionAnimationControllerType;

@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) CHTransitionAnimationControllerType animationType;


@end
