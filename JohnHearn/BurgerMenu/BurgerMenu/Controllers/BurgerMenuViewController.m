//
//  BurgerMenuViewController.m
//  BurgerMenu
//
//  Created by John D Hearn on 12/12/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "BurgerMenuViewController.h"

CGFloat kBurgerOpenScreenBoundary = 0.333; // fraction of view width (0.0 - 1.0)
CGFloat kBurgerMenuWidth = 0.5;
CGFloat kBurgerImageWidth = 50.0;
CGFloat kBurgerImageHeight = 50.0;

NSTimeInterval kAnimationSlideMenuOpenTime = 0.25;
NSTimeInterval kAnimationSlideMenuClosedTime = 0.15;


@interface BurgerMenuViewController ()<UITableViewDelegate>

@property(strong, nonatomic)NSArray *viewControllers;
@property(strong, nonatomic)UIViewController *topViewController;
@property(strong, nonatomic)UIButton *burgerButton;
@property(strong, nonatomic)UIPanGestureRecognizer *panGesture;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIViewController *firstController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    UIViewController *secondController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];

    self.viewControllers = @[firstController, secondController];

    self.topViewController = self.viewControllers.firstObject;


    UITableViewController *menuTableController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"MenuTable"];

    [self setupChildController:menuTableController];
    [self setupChildController:firstController];

    menuTableController.tableView.delegate = self;

    [self setupBurgerButton];
    [self setupPanGestureRecognizer];
}

-(void)setupChildController:(UIViewController *)childViewController{
    [self addChildViewController:childViewController];

    childViewController.view.frame = self.view.frame;

    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

-(void)setupBurgerButton{
    CGFloat padding = 20.0;
    UIButton *button = [[UIButton alloc]
                        initWithFrame:CGRectMake(padding, padding,
                                                 kBurgerImageWidth,
                                                 kBurgerImageHeight)];
    [button setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];

    [self.topViewController.view addSubview:button];

    [button addTarget:self
               action:@selector(burgerButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];

    self.burgerButton = button;
}

-(void)setupPanGestureRecognizer{
    self.panGesture =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(topViewControllerPanned:)];
    [self.topViewController.view addGestureRecognizer:self.panGesture];
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender{
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];

    if (sender.state == UIGestureRecognizerStateChanged) {
        if (translation.x >= 0) {
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x,
                                                             self.topViewController.view.center.y);
            [sender setTranslation:CGPointZero inView:self.topViewController.view];
        }
    }

    __weak typeof(self) bruceBanner = self;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width * kBurgerOpenScreenBoundary) {
            [UIView animateWithDuration:kAnimationSlideMenuOpenTime
                             animations:^{
                                 __strong typeof(bruceBanner) hulk = bruceBanner;
                                 hulk.topViewController.view.center =
                                    CGPointMake(hulk.view.center.x / kBurgerMenuWidth,
                                                hulk.view.center.y);
                             }
                             completion:^(BOOL finished) {
                                 __strong typeof(bruceBanner) hulk = bruceBanner;
                                 UITapGestureRecognizer *tap =
                                 [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(tapToCloseMenu:)];

                                 [hulk.topViewController.view addGestureRecognizer:tap];
                                 hulk.burgerButton.userInteractionEnabled = NO;
                             }];
        } else {
            [UIView animateWithDuration:kAnimationSlideMenuOpenTime
                             animations:^{
                                 __strong typeof(bruceBanner) hulk = bruceBanner;
                                 hulk.topViewController.view.center = hulk.view.center;

                             }
                             completion:nil];
        }
    }
}


-(void)burgerButtonPressed:(UIButton *)sender{
    __weak typeof(self) bruceBanner = self;
    [UIView animateWithDuration:kAnimationSlideMenuOpenTime
                     animations:^{
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         hulk.topViewController.view.center =
                             CGPointMake(hulk.view.center.x / kBurgerMenuWidth,
                                         hulk.view.center.y);
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         UITapGestureRecognizer *tap =
                            [[UITapGestureRecognizer alloc] initWithTarget:hulk
                                                                    action:@selector(tapToCloseMenu:)];
                         [hulk.topViewController.view addGestureRecognizer:tap];
                         sender.userInteractionEnabled = NO;
                     }];

}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)sender{
    [self.topViewController.view removeGestureRecognizer:sender];

    __weak typeof(self) bruceBanner = self;
    [UIView animateWithDuration:kAnimationSlideMenuOpenTime
                     animations:^{
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         hulk.topViewController.view.center = hulk.view.center;
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         hulk.burgerButton.userInteractionEnabled = YES;
                     }];
}


//MARK: UITableView Delegate Method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *newTopViewController = self.viewControllers[indexPath.row];

    __weak typeof(self) bruceBanner = self;
    [UIView animateWithDuration:kAnimationSlideMenuOpenTime
                     animations:^{
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         hulk.topViewController.view.frame = CGRectMake(hulk.view.frame.size.width,
                                                                        hulk.view.frame.origin.y,
                                                                        hulk.view.frame.size.width,
                                                                        hulk.view.frame.size.height);

                     }
                     completion:^(BOOL finished) {
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         CGRect oldFrame = hulk.topViewController.view.frame;

                         [hulk.topViewController willMoveToParentViewController:nil];
                         [hulk.topViewController.view removeFromSuperview];
                         [hulk.topViewController removeFromParentViewController];

                         [hulk setupChildController:newTopViewController];

                         newTopViewController.view.frame = oldFrame;
                         hulk.topViewController = newTopViewController;

                         [hulk.burgerButton removeFromSuperview];
                         [hulk.topViewController.view addSubview:hulk.burgerButton];

                         [UIView animateWithDuration:kAnimationSlideMenuClosedTime
                                          animations:^{
                                              hulk.topViewController.view.frame = hulk.view.frame;

                                          }
                                          completion:^(BOOL finished) {
                                              [hulk.topViewController.view addGestureRecognizer:hulk.panGesture];
                                              hulk.burgerButton.userInteractionEnabled = YES;
                                          }];
                     }];
}

@end



















