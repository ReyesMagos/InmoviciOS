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
#import "RMCellComentario.h"
#import "RMInmuebleArriendo.h"

#define kFontSize 15.0
#define TEXT_IN_TXTVIEWCOMENT @"Ingrese su comentario"

@interface RMComentariosViewController ()

@property (nonatomic, strong) RMInmuebleArriendo * inmueble;
@property (nonatomic, strong) NSArray * puntuaciones;
@property (nonatomic, strong) RMServicioWS * servicioWS;
@property (nonatomic, strong) NSArray * seccionesTable;
@property (nonatomic, strong) NSMutableArray * filasSeccionAgregar;
@property (nonatomic, strong) UIToolbar * numberToolbar;
@property (nonatomic, strong) NSArray * viewsAgregar;

@property (nonatomic, copy) NSString * nuevoComentario;
@property (nonatomic) BOOL bandera;
@property (nonatomic) BOOL banderaComentarios;

@property (nonatomic, strong) NSArray * insertadosPatch;

//las siguientes propiedades son solo para ser usadas en cada UITableViewCell

@property (nonatomic, strong) UITextView * txtCell;
@property (nonatomic, strong) UILabel * labelCell;

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
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"RMCellComentario" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.insertadosPatch = [NSArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:1 inSection:1],
                            [NSIndexPath indexPathForRow:2 inSection:1], nil];
    self.bandera = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.tableView setTableFooterView:[UIView new]];
    
    
    self.filasSeccionAgregar = [[NSMutableArray alloc] initWithObjects:@"Agregar puntación y comentario", nil];
    self.viewsAgregar = [self creteViewsForAddSection:nil];
    
    //Doy de alta la recepción de notificaciones
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadDataTableView) name: CONSUMI_PUNTUACIONES object:nil];
    [center addObserver:self selector:@selector(showMessageEnvioPuntuacion:) name:ENVIE_PUNTUACION object:nil];
    
    //[self.servicioWS searhPuntuacionesWithId:@"ID2"];
    [self.servicioWS setInmuebleId:self.inmueble.partitionKey];
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
    
    [self.filasSeccionAgregar removeObjectsInArray:self.viewsAgregar];
    
    
    [self.tableView reloadData];
}

//Respuesta del envio de la puntuacion al WS
-(void)showMessageEnvioPuntuacion: (NSNotification*) notificacion{
    NSString * respons = [notificacion.userInfo objectForKey:@"response"];
    UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Agregar comentario" message:respons delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    if ([respons isEqualToString:@"Enviada correctamente"]) {
        [self reloadDataTableView];
    }
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
        if ([self.filasSeccionAgregar count] == 4) {
            return 3;
        }else{
            return [self.filasSeccionAgregar count];
        }
        

    }else{
        return 1;
    }
    
}

-(CGSize)sizeOfLabel:(UILabel *) label withText:(NSString *) text{
    return [text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"AgrComent";
    static NSString *CellIdentifier3 = @"AgrTitulo";
    
    RMCellComentario *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell * cell2 = nil;
    
    if (indexPath.section == 0) {
        cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            cell2.textLabel.numberOfLines = 0;
            if (IS_IPHONE) {
                cell2.textLabel.font = [UIFont fontWithName:@"FuturaStd-Book" size:15];
            }else{
                cell2.textLabel.font = [UIFont fontWithName:@"FuturaStd-Book" size:18];
            }
            
        }
        
        if (!self.puntuaciones) {
            cell2.textLabel.text = @"Buscando comentarios...";
            
            //cell.comentarioTxtView.text = @"Buscando comentarios...";
        }
        else if([self.puntuaciones count] == 0){
            cell2.textLabel.text = @"No hay comentarios para este inmueble";
            //cell.comentarioTxtView.text = @"pailas";
        }else{
            self.banderaComentarios = YES;
            
            RMPuntuacionWS* punt = [self.puntuaciones objectAtIndex:indexPath.row];
            
            //cell.comentarioTxtView.text = [punt comentarioWS];
            
            UITextView * txt = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
            
            float height = [self heightForTextView:txt containingString:[punt getNSStringForComent]];
            CGRect textViewRect = CGRectMake(10, 5, 300, height);
            txt.frame = textViewRect;
            txt.tag = 333;
            txt.contentSize = CGSizeMake(300, [self heightForTextView:txt containingString:[punt comentarioWS]]);
            txt.text = [punt getNSStringForComent];
            //[cell2 addSubview:txt];
            
            
            UILabel * punta = [[UILabel alloc] initWithFrame:cell.estrellasView.frame];
            
            
            //punta.text = [NSString stringWithFormat:@"%d", [punt valorPuntuacionWS]];
            punta.text = @"dddd";
            //[cell.estrellasView addSubview:punta];
            
            self.txtCell = txt;
            self.labelCell = punta;
            
            //[self.tableView beginUpdates];
            //[self.tableView endUpdates];
            
            //[self.tableView reloadData];
            
            //cell2.detailTextLabel.text = [NSString stringWithFormat:@"Puntuación: %d", [punt valorPuntuacionWS]];
            cell2.textLabel.text = [punt getNSStringForComent];
            
            //cell2.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
            
            //CGFloat labelT = [self sizeOfLabel:cell2.textLabel withText:[punt getNSStringForComent]].height;
            
        }
        
    }
    else if (indexPath.section == 1){
        NSInteger fila = indexPath.row;
        UITableViewCell * cell3 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        if (cell3 == nil) {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
            cell3.textLabel.textAlignment = UITextAlignmentCenter;
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (fila == 0) {
            cell3.textLabel.text = [self.filasSeccionAgregar objectAtIndex:fila];
            return cell3;
            
        }else if (fila == 1){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [self.filasSeccionAgregar removeObjectsInArray:self.viewsAgregar];
            self.viewsAgregar = [self creteViewsForAddSection:cell.comentarioTxtView];
            [self.filasSeccionAgregar addObjectsFromArray:self.viewsAgregar];
            [cell.estrellasView addSubview:[self.filasSeccionAgregar objectAtIndex:fila]];
            return cell;
            
        }else{
            cell3.textLabel.text = [self.filasSeccionAgregar objectAtIndex:fila+1];
            return cell3;
        }
    }
    
    return cell2;
}



-(NSArray *)creteViewsForAddSection: (UITextView *) txt{
    //Creo el textview
    //UITextView * comentarTxtV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width /1.5, 32.0f)];
    if (txt == nil) {
        txt = [[UITextView alloc] init];
    }else{
        txt.tag = 20;
        txt.text = TEXT_IN_TXTVIEWCOMENT;
        txt.layer.borderWidth = 1;
        txt.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9] CGColor];
        txt.layer.cornerRadius = 10;
        txt.delegate = self;
        txt.font = [UIFont fontWithName:@"FuturaStd-Book" size:17];
    }
    
    
    
    //Creo el view de las estrellas
    RSTapRateView * estrellas = [[RSTapRateView alloc] initWithFrame:CGRectMake(0, 0, 250.f, 32.0f)];
    
    //Titulo de la celda de enviar
    NSString* text = @"Enviar";
    
    NSArray* elements = [[NSArray alloc] initWithObjects:estrellas, txt, text, nil];
    //NSArray* elements = [[NSArray alloc] initWithObjects:estrellas, text, nil];

    return elements;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if ([self.filasSeccionAgregar count] == 1) {
                [self.filasSeccionAgregar addObjectsFromArray:self.viewsAgregar];
                //[self.tableView reloadData];
                
                //Muevo el scroll del tableview para ver las nuevas cells
                self.tableView.contentOffset = CGPointMake(0, [self.tableView rectForFooterInSection:1].origin.y);
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:self.insertadosPatch withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }else{
                
                [self.filasSeccionAgregar removeObjectsInArray:self.viewsAgregar];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:self.insertadosPatch withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
                //[self.tableView reloadData];
            }
        }else if (indexPath.row == 2){
            
            RSTapRateView * estrellas = [self.filasSeccionAgregar objectAtIndex:1];
            UITextView * txt = [self.filasSeccionAgregar objectAtIndex:2];
            [self prepareForSendPuntuacionWithId:self.inmueble.partitionKey puntuacion:estrellas.rating comentario:txt.text];
            //[self prepareForSendPuntuacionWithId:@"ID2" puntuacion:estrellas.rating comentario:txt.text];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.puntuaciones && [self.puntuaciones count] > 0) {
            
            
            RMPuntuacionWS * str = [self.puntuaciones objectAtIndex:indexPath.row];
            CGSize size = [[str getNSStringForComent] sizeWithFont:[UIFont fontWithName:@"FuturaStd-Book" size:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
            return size.height + 18;
            
        }

    }else if (indexPath.section == 1){
        
        if (indexPath.row == 1) {
            if (self.bandera) {
                UITextView * txt = [self.filasSeccionAgregar objectAtIndex:2];
                if (txt.contentSize.height > 60) {
                    float height = [self heightForTextView:txt containingString:self.nuevoComentario];
                    return height + 20; // a little extra padding is needed
                }
            }
            return 100;
            
        }
    }
    
    return 46;
}

#pragma mark - UITextView delegate

- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 24;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont fontWithName:@"FuturaStd-Book" size:17] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:TEXT_IN_TXTVIEWCOMENT]) {
        textView.text = nil;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    self.bandera = YES;
    self.nuevoComentario = textView.text;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (textView.text == nil || [textView.text isEqualToString:@""]) {
            textView.text = TEXT_IN_TXTVIEWCOMENT;
        }
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

-(void)prepareForSendPuntuacionWithId: (NSString *) aId puntuacion : (int) aPunt comentario : (NSString *) aComent{
    
    //Preparo la expresion regular
    NSError * error = nil;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-z0-9.]+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger countMatches = [regex numberOfMatchesInString:aComent options:0 range:NSMakeRange(0, [aComent length])];
    
    if (!aId || !aPunt || !aComent || ![aComent length] || countMatches == 0 || [aComent isEqualToString:TEXT_IN_TXTVIEWCOMENT]) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Por favor ingrese tanto comentario como la puntuación" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alerta show];
        return;
    }
    if (!self.servicioWS.existeInmuebleWS) {
        [self.servicioWS sendNewInmueble:aId nombre:self.inmueble.nombredelbien descripcion:self.inmueble.descripcion];
    }
    
    [self.servicioWS sendPuntuacion:aId puntuacion:aPunt comentario:aComent];
}

@end
