CHTransitionAnimationController
===============================

Transition between view controllers using pre-built custom transitions

Getting Started:
---------------
- Drag and drop the animation files into your project (found in the 'Transition Animations' folder).
- In the view controller doing the presenting, create an instance of both `CHTransitionAnimationController`. Make sure this class contains the appropriate imports (i.e. `import "CHTransitionAnimationController.h"`).
- In your current View Controller, you must adhere to the `UIViewControllerTransitioningDelegate`. Then set your current view controller as the delegate of the view controller your are presenting, like so: 
```objective-c
MyNextViewController *viewController = [[MyNextViewController alloc] init]; //instance of your next view controller
viewController.transitioningDelegate = self;  //set transitioning delegate
[self presentViewController:viewController animated:YES completion:nil];  //present next view controller
```
- Implement the `UIViewControllerTransitioningDelegate` methods. Set the `animationType` of the CHTransitionAnimationController and then return your CHTransitionAnimationController instance in the appropriate delegate methods, like so:
```objective-c
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
  _animationController.animationType = CHTransitionAnimationTypeGrow;
  _animationController.animationDuration = 0.5; //optional - defaults to 0.25
	return _animationController;
}

- (id <UIViewControllerInteractiveTransitioning>) interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
  _animationController.animationType = CHTransitionAnimationTypeShrink;
  _animationController.animationDuration = 0.5; //optional - defaults to 0.25
	return _animationController;
}
```
NOTE: The current animation options include CHAnimationTypeGrow, CHAnimationTypeShrink, and CHAnimationTypeFade. These will work for either presenting or dismissing a view controller. Other transition types will come as I continue to work on this project.

####Optional Steps:
You can set the `animationDuration` property of the `CHTransitionAnimationController` instance, but don't have to. It will default to 0.25. The `animationDuration` property is just that, the duration for which the dismiss animation will take to complete. 

####Additional Info:
The animation pushes the dismissing view controller up off the screen while also rotating and fading out. It randomly selects between 4 different rotations, varying in degree and direction. 

