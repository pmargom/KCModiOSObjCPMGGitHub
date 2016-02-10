//
//  UIViewController+AGTTabNavigation.h
//  Everpobre
//
//  Created by Pedro Martin Gomez on 10/2/16.
//  Copyright © 2016 Agbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTMapViewController.h"

@interface UIViewController (TabNavigation)

-(UITabBarController *)wrappedInTabBarWithMapViewController: (AGTMapViewController *) mapViewController;

@end
