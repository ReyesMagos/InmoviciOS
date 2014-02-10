//
//  RMComentariosViewController.m
//  Inmovic
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMComentariosViewController.h"
#import "RMInmuebleWS.h"
#import "RMServicioWS.h"
#import "RMPuntuacionWS.h"

#import "RMInmuebleArriendo.h"

@interface RMComentariosViewController ()

@property (nonatomic, strong) RMInmuebleArriendo * inmueble;
@property (nonatomic, strong) NSArray * puntuaciones;
@property (nonatomic, strong) RMServicioWS * servicioWS;
@property (nonatomic, strong) NSArray * seccionesTable;
@property (nonatomic, strong) NSMutableArray * filasSeccionAgregar;
@property (nonatomic, strong) UIToolbar * numberToolbar;
@property (nonatomic, strong) NSArray * viewsAgregar;
@end

@implementation RMComentariosViewController

-(id)initWithInmueble:(RMInmuebleArriendo *)aInmueble style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _inmueble = aInmueble;
        _servicioWS = [[RMServicioWS alloc] initWithWebService:@"http://190.12.157.123/UVInmuebles/ServicioInmueble.asmx"];
        _seccionesTable = @[@"Seccion Comentarios", @"Sección Agregar"];
        self.title = @"Comentarios";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.tableView setTableFooterView:[UIView new]];
    
    self.filasSeccionAgregar = [[NSMutableArray alloc] initWithObjects:@"Agregar puntación y comentario", nil];
    self.viewsAgregar = [self creteViewsForAddSection];
    
    //Doy de alta la recepción de notificaciones
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadDataTableView) name: CONSUMI_PUNTUACIONES object:nil];
    [center addObserver:self selector:@selector(showMessageEnvioPuntuacion:) name:ENVIE_PUNTUACION object:nil];
    
    //[self.servicioWS searhPuntuacionesWithId:@"ID2"];
    [self.servicioWS searhPuntuacionesWithId:[self.inmueble partitionKey]];
    
    //Toobar para el teclado que sale al ingresar un comentario
    self.numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    self.numberToolbar.items = [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                                nil];
    [self.numberToolbar sizeToFit];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //Me doy de da baja en la recepción de notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)doneWithNumberPad: (id) sender{
    [[self view] endEditing:TRUE];
}

//Una vez que se consumieron las puntuaciones desde WS se actualiza el UITableView
-(void)reloadDataTableView{
    self.puntuaciones = self.servicioWS.returnPuntuacionesWS;
    [self.tableView reloadData];
}

//Respuesta del envio de la puntuacion al WS
-(void)showMessageEnvioPuntuacion: (NSNotification*) notificacion{
    UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Agregar comentario" message:[notificacion.userInfo objectForKey:@"response"]
                                                     delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alerta show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Seccion 0 para los comentarios, Seccion 1 para ingresar comentarios y puntuaciones
    return [self.seccionesTable count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Para cada seccion, asigno el numero de rows
    if (section == 0) {
        if (self.puntuaciones && [self.puntuaciones count] != 0) {
            return [self.puntuaciones count];
        }else{
            return 1;
        }
    }else if(section == 1){
        return [self.filasSeccionAgregar count];
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"AgrComent";
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        NSInteger fila = indexPath.row;
        if (fila == 0) {
            
            cell.textLabel.text = [self.filasSeccionAgregar objectAtIndex:fila];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else if (fila == 2){
            UITextView * comentarTxtV = [self.filasSeccionAgregar objectAtIndex:fila];
            comentarTxtV.center = CGPointMake(self.view.frame.size.width/2, comentarTxtV.frame.size.height - 10);
            [cell addSubview: comentarTxtV];
            UIView * eliminarLinea = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
            eliminarLinea.backgroundColor = [UIColor clearColor];
            [cell addSubview:eliminarLinea];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            comentarTxtV.inputAccessoryView = self.numberToolbar;
        }else if (fila == 1){
            RSTapRateView * strs = [self.filasSeccionAgregar objectAtIndex:fila];
            strs.center = CGPointMake(self.view.frame.size.width/2, strs.frame.size.height - 10);
            [cell addSubview: strs];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else if (fila == 3){
            cell.textLabel.text = [self.filasSeccionAgregar objectAtIndex:fila];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            
        }
        
    }else if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (!self.puntuaciones) {
            cell.textLabel.text = @"Buscando comentarios...";
        }
        else if([self.puntuaciones count] == 0){
            cell.textLabel.text = @"No hay comentarios para este inmueble";
        }else{
            
            RSTapRateView * estrellas = [[RSTapRateView alloc] initWithFrame:CGRectMake(320, 10.0f, 0, 0)];
            estrellas.delegate = self;
            estrellas.userInteractionEnabled = NO;
            estrellas.tag = 234;
            [cell addSubview:estrellas];
            RMPuntuacionWS* punt = [self.puntuaciones objectAtIndex:indexPath.row];
            estrellas.rating = [punt valorPuntuacionWS];
            cell.textLabel.text = punt.comentarioWS;
           
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    return cell;
}

-(NSArray *)creteViewsForAddSection{
    //Creo el textview
    UITextView * comentarTxtV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width /1.5, 32.0f)];
    comentarTxtV.tag = 20;
    comentarTxtV.text = nil;
    comentarTxtV.layer.borderWidth = 1;
    comentarTxtV.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9] CGColor];
    comentarTxtV.layer.cornerRadius = 10;
    comentarTxtV.font = [UIFont fontWithName:@"FuturaStd-Book" size:17];
    
    //Creo el view de las estrellas
    RSTapRateView * estrellas = [[RSTapRateView alloc] initWithFrame:CGRectMake(0, 0, 250.f, 32.0f)];
    
    //Titulo de la celda de enviar
    NSString* text = @"Agregar";
    
    NSArray* elements = [[NSArray alloc] initWithObjects:estrellas, comentarTxtV, text, nil];
    return elements;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if ([self.filasSeccionAgregar count] == 1) {
                [self.filasSeccionAgregar addObjectsFromArray:self.viewsAgregar];
                [self.tableView reloadData];
            }else{
                [self.filasSeccionAgregar removeObjectsInArray:self.viewsAgregar];
                [self.tableView reloadData];
            }
        }else if (indexPath.row == 3){
            RSTapRateView * estrellas = [self.viewsAgregar objectAtIndex:0];
            UITextView * txt = [self.viewsAgregar objectAtIndex:1];
            [self prepareForSendPuntuacionWithId:self.inmueble.partitionKey puntuacion:estrellas.rating comentario:txt.text];
            //[self prepareForSendPuntuacionWithId:@"ID2" puntuacion:estrellas.rating comentario:txt.text];
        }
    }
}

-(void)prepareForSendPuntuacionWithId: (NSString *) aId puntuacion : (int) aPunt comentario : (NSString *) aComent{
    
    //Preparo la expresion regular
    NSError * error = nil;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-z0-9.]+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger countMatches = [regex numberOfMatchesInString:aComent options:0 range:NSMakeRange(0, [aComent length])];
    
    if (!aId || !aPunt || !aComent || ![aComent length] || countMatches == 0) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Tiene que ingresar tanto el comentario como la puntuación" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alerta show];
        return;
    }
    [self.servicioWS sendPuntuacion:aId puntuacion:aPunt comentario:aComent];
}

@end
