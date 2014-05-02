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


@end
