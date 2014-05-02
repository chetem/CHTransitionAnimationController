//
//  CHFirstViewController.m
//  CHTransitionAnimationControllerExample
//
//  Created by Chris Hetem on 5/1/14.
//  Copyright (c) 2014 Chris Hetem. All rights reserved.
//

#import "CHFirstViewController.h"
#import "CHTransitionAnimationController.h"
#import "CHSecondViewController.h"

@interface CHFirstViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation CHFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)onPresentViewController:(id)sender
{
	CHSecondViewController *vc = [CHSecondViewController new];
	vc.transitioningDelegate = self;
	[self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Transitioning Delegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																 presentingController:(UIViewController *)presenting
																	 sourceController:(UIViewController *)source
{
	
	CHTransitionAnimationController *animationController = [CHTransitionAnimationController new];
	animationController.animationType = CHTransitionAnimationTypeGrowWithRotation;
	animationController.animationDuration = .5;	//optional setting here - defaults to 0.25
	return animationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	CHTransitionAnimationController *animationController = [CHTransitionAnimationController new];
	animationController.animationType = CHTransitionAnimationTypeShrinkWithRotation;
	animationController.animationDuration = .5;	//optional setting here - defaults to 0.25
	return animationController;
}


@end
