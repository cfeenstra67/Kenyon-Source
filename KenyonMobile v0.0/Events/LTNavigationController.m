//
//  LTNavigationController.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/30/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTNavigationController.h"

@interface LTNavigationController(){
    UIPanGestureRecognizer *panGesture;
    BOOL isPushing;
}

@end

@interface LTNavigationController ()

@end

@implementation LTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPushing=NO;
    self.interactivePopGestureRecognizer.delegate=self;
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    isPushing=YES;
    [super pushViewController:viewController animated:animated];
    NSTimer *timer=[NSTimer timerWithTimeInterval:.5 repeats:NO block:^(NSTimer *time){
        isPushing=NO;
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewControllers.count>1&&!isPushing;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
