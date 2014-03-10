//
//  RMDestacadosTableViewController.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMDestacadosTableViewController.h"
#import "RMInmobiliariaModel.h"
#import "RMInmuebleArriendoViewController.h"
#import "RMInmuebleArriendo.h"
#import "AsyncImageView.h"
#import "RMTipoBusquedaViewController.h"
#import "RMCellDestacados.h"
#import "RMCellDestacadosIphone.h"
#import "Reachability.h"
#import "RMAcercaDeViewController.h"

@interface RMDestacadosTableViewController ()
@property (nonatomic, strong) RMInmuebleArriendo * elSeleccionado;
@property (nonatomic, strong) UIBarButtonItem * btnBuscar;
@property (nonatomic, strong) UIBarButtonItem * btnAcercade;
@end

@implementation RMDestacadosTableViewController

-(id)initWithInmobiliaria:(RMInmobiliariaModel *)aInmobiliaria
                    style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _inmobiliaria = aInmobiliaria;
        self.title = @"Destacados";
        _btnBuscar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self
                                                                  action:@selector(btnReloadPressed:)];
        _btnAcercade = [[UIBarButtonItem alloc]initWithTitle:@"Acerca de" style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(goToAbout:)];
        
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[UIView new]];
    
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = self.btnBuscar;
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = self.btnAcercade;
    //btnReload.style=UIBarButtonSystemItemRefresh;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //Activo este view en NotificationCenter con el fin de saber cuando se desconecta de internet
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    
    
    //Esto refresca el tableview. Especial para cuando se regresa de la vista de una búsqueda.
    [self.tableView reloadData];
    
//    if (![self.btnBuscar isEnabled]) {
//        Reachability *rea = [Reachability reachabilityForInternetConnection];
//        if ([rea isReachable]) {
//            self.btnBuscar.enabled = YES;
//        }
//        
//    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Me doy de da baja en la recepción de notificaciones
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Este metodo se encarga de notificar a este view si hubo cambios en la conexión a internet
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    if ([reachability isReachable] && !self.inmobiliaria.inmueblesArray) {
        NSLog(@"Conectado a internet, destacados, vacio");
        self.inmobiliaria = [[RMInmobiliariaModel sharedManager] init];
        self.btnBuscar.enabled = YES;
        [self.tableView reloadData];
    } else if(![reachability isReachable]) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"No hay conexión a internet" message:@"No se ha establecido la conexión a Internet\n\n Algunas funcionalidades no estarán disponbiles hasta que reanuda la conexión" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alerta show];
        self.btnBuscar.enabled = NO;
        NSLog(@"Sin conexión a internet, destacados");
    } else if ([reachability isReachable]){
        self.btnBuscar.enabled = YES;
        NSLog(@"Conectado a internet, destacados");
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == INMUEBLES_ARRIENDO_SECTION) {
        //return self.inmobiliaria.inmuebleArriendoCount;
        if (self.inmobiliaria.inArriAleatorioArray) {
            return 5;
        }else{
            return 1;
        }
    }else{
        return self.inmobiliaria.bienVentaCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    static NSString * CellIdentifier = @"CellDestacados";
    #define IMAGE_VIEW_TAG 99
    
    
    RMCellDestacadosIphone* cell = (RMCellDestacadosIphone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        if (!self.inmobiliaria.inmueblesArray) {
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"Esperando conexión a internet";
            return  cell;
        }
        if (IS_IPHONE) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RMCellDestacadosIphone" owner:self options:nil][0];
        }else{
            cell = [[NSBundle mainBundle] loadNibNamed:@"RMCellDestacados" owner:self options:nil][0];
        }
        //cell = [[NSBundle mainBundle] loadNibNamed:@"RMCellDestacadosIphone" owner:self options:nil][0];

    }else{
        [(AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG] removeFromSuperview];
    }
    
    //Averiguo cuál es el bien o inmueble que debe ir en la respectiva celda
    
    if (indexPath.section == INMUEBLES_ARRIENDO_SECTION) {
        RMInmuebleArriendo * inmueble = [self.inmobiliaria inmuebleAleatorioArriendoAtIndex:indexPath.row];
        cell.areaLB.text = inmueble.tipodeinmueble;
        cell.nombreLB.text = inmueble.nombredelbien;
        cell.nombreTxtView.text = inmueble.nombredelbien;
        cell.valorLB.text = [NSString stringWithFormat:@"%d", inmueble.canondearrendamiento];
        cell.ubicacionLB.text = [NSString stringWithFormat:@"%@ - %@", inmueble.departamento, inmueble.municipio];
        
        if (!inmueble.portadaV) {
            [inmueble consumeFirstImage];
        }
        AsyncImageView * imageView = inmueble.portadaV;
        imageView.tag = IMAGE_VIEW_TAG;
        
        imageView.frame = [cell.viewview frame];
        [cell addSubview:imageView];
        
        
    }else{
        //este espacio es para una escalabilidad futura
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPHONE) {
        return 116;
    }else{
        return 220;
    }
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Si solo está la celda que dice !Esperando conexion!, no haga nada.
    if (!self.inmobiliaria.inmueblesArray) {
        return;
    }
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"Seleccione una opción" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Ver", @"Compartir", nil];
    
    action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [action showInView:self.view];
    
    //Averiguo cuál es el bien o inmueble que debe ir
    if (indexPath.section == INMUEBLES_ARRIENDO_SECTION) {
        self.elSeleccionado = [self.inmobiliaria inmuebleAleatorioArriendoAtIndex:indexPath.row];

        
    }else{
       // RMBienVenta * bien = [self.inmobiliaria bienVentaAtIndex:indexPath.row];
        
        
    }
    
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 222) {
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PrimeraCargada"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if (buttonIndex == 0){
            exit(0);
        }
    }
}

#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        //Creo el controlador de la vista de detalle
        RMInmuebleArriendoViewController * inmuebleVC = [[RMInmuebleArriendoViewController alloc] initWithInmueble:self.elSeleccionado];
        
        //Realizo un push al nuevo controllador
        [self.navigationController pushViewController:inmuebleVC animated:YES];

    }else if (buttonIndex == 1){
        [self compartirRedesSociles];
    }
}

#pragma mark - utilis
-(IBAction)btnReloadPressed:(id)sender {
    RMTipoBusquedaViewController * tipoBusquedaVC = [[RMTipoBusquedaViewController alloc]initWithStyle:UITableViewStylePlain];

    [self.navigationController pushViewController:tipoBusquedaVC animated:YES];
}

-(IBAction)goToAbout:(id)sender {
    RMAcercaDeViewController * acercaDeVC = [[RMAcercaDeViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:acercaDeVC];
    [self.navigationController presentModalViewController:nav animated:YES];
}

-(void)compartirRedesSociles{
    NSArray * coords = [[self.elSeleccionado nombredelbien] componentsSeparatedByString:@"."];
    NSString * nombrecorto = [coords objectAtIndex:0];
    NSString * info = [NSString stringWithFormat:@"Este inmueble: %@ está disponble para arrendar en %@ - %@ @UnivadVictimas \n\nCompartido a tráves de Inmovic para iOS", nombrecorto , [self.elSeleccionado departamento], [self.elSeleccionado municipio]];
    
    //Compruebo la versión del sistema iOS para ver como hábilito Compartir
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Opción no disponible" message:@"Esta opción solo está disponbile para equipos con iOS 6.0 o superior." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alerta show];
        
    }else{
        NSArray * datos;
        datos = @[info];
        UIActivityViewController * actividadController = [[UIActivityViewController alloc] initWithActivityItems:datos applicationActivities:nil];
        [self presentViewController:actividadController animated:YES completion:nil];
    }
}

@end
