//
//  UIViewController+AGTTabNavigation.m
//  Everpobre
//
//  Created by Pedro Martin Gomez on 10/2/16.
//  Copyright © 2016 Agbo. All rights reserved.
//

#import "UIViewController+TabNavigation.h"
#import "AGTMapViewController.h"
#import "AGTAnnotation.h"
#import "AGTMapViewController.h"

@implementation UIViewController (TabNavigation)

-(UITabBarController *)wrappedInTabBarWithMapViewController: (AGTMapViewController *) mapViewController{
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    
    [tab setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:self],
                              mapViewController]];
    
    
    return tab;
    
}

@end


