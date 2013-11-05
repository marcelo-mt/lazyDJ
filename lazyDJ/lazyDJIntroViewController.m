//
//  lazyDJIntroViewController.m
//  lazyDJ
//
//  Created by Marcelo Toledo on 11/4/13.
//  Copyright (c) 2013 Marcelo Mingatos de Toledo. All rights reserved.
//

#import "lazyDJIntroViewController.h"

@interface lazyDJIntroViewController ()

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwiperGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation lazyDJIntroViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Swipes

- (IBAction)swipeLeft:(id)sender
{
    NSLog(@"Swipe left.");
    [self performSegueWithIdentifier:@"dismissIntroLeft" sender:self];
    
}
- (IBAction)swipeRight:(id)sender
{
    NSLog(@"Swipe right.");
    [self performSegueWithIdentifier:@"dismissIntroRight" sender:self];
}

@end
