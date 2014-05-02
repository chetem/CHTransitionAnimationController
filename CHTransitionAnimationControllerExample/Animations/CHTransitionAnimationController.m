//
//  CHTransitionAnimationController.m
//  CHTransitionAnimationControllerExample
//
//  Created by Chris Hetem on 5/1/14.
//  Copyright (c) 2014 Chris Hetem. All rights reserved.
//

#import "CHTransitionAnimationController.h"

//if no animationDuration set, fall back to default 0.5
#define DURATION	(self.animationDuration > 0) ? self.animationDuration : 0.25

@implementation CHTransitionAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return DURATION;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	switch(self.animationType){
		case CHTransitionAnimationTypeGrow:
			[self performAnimationTypeGrow:transitionContext];
			break;
		case CHTransitionAnimationTypeShrink:
			[self performAnimationTypeShrink:transitionContext];
			break;
		case CHTransitionAnimationTypeFade:
			[self performAnimationTypeFade:transitionContext];
			break;
		case CHTransitionAnimationTypeShrinkWithRotation:
			[self performAnimationTypeShrink:transitionContext withRotation:M_PI];
			break;
		case CHTransitionAnimationTypeGrowWithRotation:
			[self performAnimationTypeGrow:transitionContext withRotation:M_PI];
			break;
		case CHTransitionAnimationTypeSlideInFromLeft:
			[self performAnimationTypeSlideIn:transitionContext withType:CHTransitionAnimationTypeSlideInFromLeft] ;
			break;
		case CHTransitionAnimationTypeSlideInFromRight:
			[self performAnimationTypeSlideIn:transitionContext withType:CHTransitionAnimationTypeSlideInFromRight];
			break;
		case CHTransitionAnimationTypeSlideInFromTop:
			[self performAnimationTypeSlideIn:transitionContext withType:CHTransitionAnimationTypeSlideInFromTop];
			break;
		case CHTransitionAnimationTypeSlideInFromBottom:
			[self performAnimationTypeSlideIn:transitionContext withType:CHTransitionAnimationTypeSlideInFromBottom];
			break;
		case CHTransitionAnimationTypeSlideOutToLeft:
			[self performAnimationTypeSlideOut:transitionContext withType:CHTransitionAnimationTypeSlideOutToLeft] ;
			break;
		case CHTransitionAnimationTypeSlideOutToRight:
			[self performAnimationTypeSlideOut:transitionContext withType:CHTransitionAnimationTypeSlideOutToRight];
			break;
		case CHTransitionAnimationTypeSlideOutToTop:
			[self performAnimationTypeSlideOut:transitionContext withType:CHTransitionAnimationTypeSlideOutToTop];
			break;
		case CHTransitionAnimationTypeSlideOutToBottom:
			[self performAnimationTypeSlideOut:transitionContext withType:CHTransitionAnimationTypeSlideOutToBottom];
			break;


	}
	
}

-(void)performAnimationTypeGrow:(id<UIViewControllerContextTransitioning>)transitionContext
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	
	//create snapshot of toViewController and add it to container view
	//this is the view that actually gets animated.
	UIView *toSnapShotView = [toViewController.view snapshotViewAfterScreenUpdates:YES];
	toSnapShotView.frame = finalFrame;
	[containerView addSubview:toSnapShotView];
	
	//hide toViewController to allow toSnapShotView to animate cleanly
	toViewController.view.hidden = YES;
	
	CGAffineTransform scale = CGAffineTransformMakeScale(0.01, 0.01);	//scale transformation
	
	//set initial toSnapShotView scale to 0
	toSnapShotView.transform = scale;
	
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 
						 toSnapShotView.transform = CGAffineTransformIdentity;	//make scale animation back to 1.0
						 
					 } completion:^(BOOL finished) {
						 toViewController.view.frame = finalFrame;	//make sure toViewController frame is set right
						 toViewController.view.hidden = NO;			//unhide toViewController
						 [toSnapShotView removeFromSuperview];		//remove toSnapShotView
						 [transitionContext completeTransition:YES];
					 }];

}

-(void)performAnimationTypeShrink:(id<UIViewControllerContextTransitioning>)transitionContext
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//set frame of 'toViewController' to be it's final frame too, since it's not moving
	toViewController.view.frame = finalFrame;
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	[containerView sendSubviewToBack:toViewController.view];
	
	//create a snapshot of imageview to use for the animation
	UIView *snapShotView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
	snapShotView.frame = fromViewController.view.frame;
	
	//add snap shot of image view to container view
	[containerView addSubview:snapShotView];
	[fromViewController.view removeFromSuperview];
	
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 snapShotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
						 
					 } completion:^(BOOL finished) {
						 [snapShotView removeFromSuperview];
						 [transitionContext completeTransition:YES];
					 }];

}

-(void)performAnimationTypeFade:(id<UIViewControllerContextTransitioning>)transitionContext
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	
	toViewController.view.alpha = 0.2;
	fromViewController.view.alpha = 1.0;
		
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 toViewController.view.alpha = 1.0;			//fade in toViewController
						 fromViewController.view.alpha = 0.2;		//fade out fromViewController
							
					 } completion:^(BOOL finished) {
						 fromViewController.view.alpha = 1.0;		//make sure alpha is all the way up to be ready for dismissal
						 toViewController.view.frame = finalFrame;	//make sure toViewController frame is set right
						 [transitionContext completeTransition:YES];
					 }];
}

-(void)performAnimationTypeShrink:(id<UIViewControllerContextTransitioning>)transitionContext withRotation: (double)rotation
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//set frame of 'toViewController' to be it's final frame too, since it's not moving
	toViewController.view.frame = finalFrame;
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	[containerView sendSubviewToBack:toViewController.view];
	
	//create a snapshot of imageview to use for the animation
	UIView *snapShotView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
	snapShotView.frame = fromViewController.view.frame;
	
	//add snap shot of image view to container view
	[containerView addSubview:snapShotView];
	[fromViewController.view removeFromSuperview];
	
	CGAffineTransform scale = CGAffineTransformMakeScale(0.01, 0.01);
	CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
	
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 snapShotView.transform = CGAffineTransformConcat(scale, rotate);
						 
					 } completion:^(BOOL finished) {
						 [snapShotView removeFromSuperview];
						 [transitionContext completeTransition:YES];
					 }];
	
}

-(void)performAnimationTypeGrow:(id<UIViewControllerContextTransitioning>)transitionContext withRotation:(double)rotation
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	
	//create snapshot of toViewController and add it to container view
	//this is the view that actually gets animated.
	UIView *toSnapShotView = [toViewController.view snapshotViewAfterScreenUpdates:YES];
	toSnapShotView.frame = finalFrame;
	[containerView addSubview:toSnapShotView];
	
	//hide toViewController to allow toSnapShotView to animate cleanly
	toViewController.view.hidden = YES;
	
	CGAffineTransform scale = CGAffineTransformMakeScale(0.01, 0.01);
	CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
	
	//set initial toSnapShotView scale to 0
	toSnapShotView.transform = CGAffineTransformConcat(scale, rotate);
	
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 
						 toSnapShotView.transform = CGAffineTransformIdentity;	//make scale animation back to 1.0 with rotation
						 
					 } completion:^(BOOL finished) {
						 toViewController.view.frame = finalFrame;	//make sure toViewController frame is set right
						 toViewController.view.hidden = NO;			//unhide toViewController
						 [toSnapShotView removeFromSuperview];		//remove toSnapShotView
						 [transitionContext completeTransition:YES];
					 }];
	
}

-(void)performAnimationTypeSlideIn:(id<UIViewControllerContextTransitioning>)transitionContext withType:(CHTransitionAnimationControllerType)type
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
		
	//set initial frame of toViewController off screen to the left
	CGRect initialRect = toViewController.view.frame;

	
	switch (type) {
		case CHTransitionAnimationTypeSlideInFromLeft:
			initialRect.origin.x = initialRect.origin.x-initialRect.size.width;
			break;
		case CHTransitionAnimationTypeSlideInFromRight:
			initialRect.origin.x = initialRect.origin.x+initialRect.size.width;
			break;
		case CHTransitionAnimationTypeSlideInFromTop:
			initialRect.origin.y = initialRect.origin.y-initialRect.size.height;
			break;
		case CHTransitionAnimationTypeSlideInFromBottom:
			initialRect.origin.y = initialRect.origin.y+initialRect.size.height;
			break;
		default:
			break;
			
	}
	
	toViewController.view.frame = initialRect;
	
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 toViewController.view.frame = finalFrame;
						 
					 } completion:^(BOOL finished) {
						 toViewController.view.frame = finalFrame;	//make sure toViewController frame is set right
						 [transitionContext completeTransition:YES];
					 }];
	
}

-(void)performAnimationTypeSlideOut:(id<UIViewControllerContextTransitioning>)transitionContext withType:(CHTransitionAnimationControllerType)type
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after presenting/dismissing)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	[containerView sendSubviewToBack:toViewController.view];
	
	//set initial frame of toViewController off screen to the left
	CGRect finalFromRect = fromViewController.view.frame;
	
	
	switch (type) {
		case CHTransitionAnimationTypeSlideOutToLeft:
			finalFromRect.origin.x = finalFromRect.origin.x-finalFromRect.size.width;
			break;
		case CHTransitionAnimationTypeSlideOutToRight:
			finalFromRect.origin.x = finalFromRect.origin.x+finalFromRect.size.width;
			break;
		case CHTransitionAnimationTypeSlideOutToTop:
			finalFromRect.origin.y = finalFromRect.origin.y-finalFromRect.size.height;
			break;
		case CHTransitionAnimationTypeSlideOutToBottom:
			finalFromRect.origin.y = finalFromRect.origin.y+finalFromRect.size.height;
			break;
		default:
			break;
			
	}
	
	//animate with key frames
	[UIView animateWithDuration:DURATION
						  delay:0.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 fromViewController.view.frame = finalFromRect;
						 
					 } completion:^(BOOL finished) {
						 toViewController.view.frame = finalFrame;	//make sure toViewController frame is set right
						 [transitionContext completeTransition:YES];
					 }];
	
}


@end
