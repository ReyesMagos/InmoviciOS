//
//  RMAcercaDeViewController.m
//  Inmovic
//
//  Created by Felipe on 9/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMAcercaDeViewController.h"

@interface RMAcercaDeViewController ()

@end

@implementation RMAcercaDeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    if (IS_IPHONE) {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMAcercaDeViewController" owner:self options:nil][0];
    }else{
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMAcercaIpad" owner:self options:nil][0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Acerca de";
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithTitle:@"Volver" style:UIBarButtonItemStyleDone target:self
                                                           action:@selector(backToController)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = btn;
    NSArray * ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7){
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.695 green:0.000 blue:0.112 alpha:1.000];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FuturaStd-Heavy" size:20], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
    }else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.695 green:0.000 blue:0.112 alpha:1.000];
    }
    
}

-(void)backToController{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
