//
//  RMAppDelegate.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMDestacadosTableViewController.h"
#import "RMInmobiliariaModel.h"
#import "Reachability.h"

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Creo la conectividad
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    // Empiezo monitoreo de conexión
    [reachability startNotifier];
    
    //RMInmobiliariaModel * inmobiliaria = [[RMInmobiliariaModel alloc] init];
    RMInmobiliariaModel * inmobiliaria = [RMInmobiliariaModel sharedManager];
    
    //Creo el controlador de la tabla incial
    RMDestacadosTableViewController * destacadosVC = [[RMDestacadosTableViewController alloc]initWithInmobiliaria:inmobiliaria
                                                                                                            style:UITableViewStylePlain];
    
    //El siguiente código es para mostrar el mensaje sólo la primera vez que la aplicación es ejecutada
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PrimeraCargada"]) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Politica de Privacidad" message:@"Con esta aplicación se quiere crear condiciones de prosperidad en la población vulnerable, contribuir a la reconciliación de los colombianos y promover la integración regional.\n\nTodos los inmuebles aquí mostrados pertenecen al Gobierno de la República de Colombia, e integran a la Unidad para la Atención y Reparación Integral a las Víctimas." delegate:destacadosVC cancelButtonTitle:@"Salir" otherButtonTitles:@"Comprendo", nil];
        [alerta show];
        //Para identificar este alertview
        alerta.tag = 222;
    }
    
    
    //Creo el navigation controller de la aplicación
    UINavigationController *inmobiliarioNVC = [[UINavigationController alloc] initWithRootViewController:destacadosVC];
    [self setAppearanceNav:inmobiliarioNVC];
    
    
    //Asigno el navigation controller como controlador raíz
    self.window.rootViewController = inmobiliarioNVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) setAppearanceNav : (UINavigationController*) nav{
    //Cambio el color del navigation var
    NSArray * ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        nav.navigationBar.barTintColor = [UIColor colorWithRed:0.695 green:0.000 blue:0.112 alpha:1.000];
        nav.navigationBar.translucent = NO;
        //Cambio el color de los botones del nav a blanco
        nav.navigationBar.tintColor = [UIColor whiteColor];
        //Cambio el color del title del nav
        //inmobiliarioNVC.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FuturaStd-Heavy" size:20], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
        
    }else{
        
        nav.navigationBar.tintColor = [UIColor colorWithRed:0.695 green:0.000 blue:0.112 alpha:1.000];
    }
    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FuturaStd-Book" size:15], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
}

@end
