//
//  RMTipoBusquedaViewController.m
//  Inmovic
//
//  Created by imaclis on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMTipoBusquedaViewController.h"
#import "RMBusquedaInmuebleViewController.h"
#import "RMInmuebleArriendo.h"
#import "RMBienVenta.h"
#import "AsyncImageView.h"
#import "RMInmuebleArriendoViewController.h"
#import "RMBienEnVentaViewController.h"
#import "RMCellDestacados.h"
#import "Reachability.h"
#import "RMMapaViewController.h"

#define kFontSize 15.0 // fontsize
#define kTextViewWidth 300

@interface RMTipoBusquedaViewController ()

@property (nonatomic, strong) NSArray* inmuebles;
@property (nonatomic, strong) NSArray* bienes;

@property (nonatomic, strong) NSArray* encontrados;

@property (nonatomic) BOOL bandera;

@end

@implementation RMTipoBusquedaViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Tipo de Búsqueda";
        
    }
    return self;
}

-(id)initWithInmueble:(NSArray *)aInmueble style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _inmuebles = aInmueble;
        self.title = @"Encontrados";
        self.bandera = NO;
    }
    return self;
}

-(id)initWithBien:(NSArray *)aBien style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _bienes = aBien;
        self.title = @"Encontrados";
    }
    return self;
}

-(id)initWithArray:(NSArray *)aArray style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _encontrados = aArray;
        self.title = @"Encontrados";
       

    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setTableFooterView:[UIView new]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Para el boton de mapa
    if (self.inmuebles) {
        UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithTitle:@"Ubicar" style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(showInmueblesfoundedOnMap)];
        self.navigationController.topViewController.navigationItem.rightBarButtonItem = btn;
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
    if (self.inmuebles) {
        return [self.inmuebles count];
    }else if (self.bienes) {
        return [self.bienes count];
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
#define IMAGE_VIEW_TAG 99;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UITextView * txtView = (UITextView *)[cell viewWithTag:222];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        txtView = [[UITextView alloc] init];
        txtView.tag = 222;
        [cell addSubview:txtView];
        
    }
    if (self.bienes) {
        RMBienVenta * bienVta = [self.bienes objectAtIndex:indexPath.row];
        NSArray * coords = [bienVta.descripcion componentsSeparatedByString:@";"];
        //NSString * nombrecorto = [NSString stringWithFormat:@"%@ - %@", [coords objectAtIndex:0], bienVta.tipodebien];
        
        NSString * nombrecorto = [NSString stringWithFormat:@"%@", [coords objectAtIndex:0]];
        
        //Creo un area para el TextView para que el texto que ponemos en él sea el adecuado
//        float tamano = [self heightForTextView:txtView containingString:nombrecorto];
//        CGRect textViewRect = CGRectMake(74, 4, kTextViewWidth, tamano);
//        txtView.frame = textViewRect;
//        
//        //Actualizo las propiedades del textview
//        txtView.contentSize = CGSizeMake(kTextViewWidth, [self heightForTextView:txtView containingString:nombrecorto]);
//        txtView.text = nombrecorto;
        
        
        //cell.textLabel.text = nombrecorto;
         //cell.textLabel.font = [UIFont fontWithName:@"FuturaStd-Book" size:14];
        
        CGRect textViewRect = CGRectMake(0, 1, self.view.frame.size.width, 75);
        txtView.frame = textViewRect;
        
        //Actualizo las propiedades del textview
        txtView.contentSize = CGSizeMake(kTextViewWidth, [self heightForTextView:txtView containingString:nombrecorto]);
        txtView.text = nombrecorto;
        txtView.font = [UIFont fontWithName:@"FuturaStd-Book" size:18];
        txtView.userInteractionEnabled = NO;
        
        if (!bienVta.portadaV) {
            [bienVta consumeFirstImage];
        }
        AsyncImageView * imageView = bienVta.portadaV;
        imageView.tag = IMAGE_VIEW_TAG;
        //[cell addSubview:imageView];
        
    }else if(self.inmuebles) {
        self.bandera = YES;
        RMInmuebleArriendo * inmueble = [self.inmuebles objectAtIndex: indexPath.row];
        NSString * nombre = inmueble.nombredelbien;
        
        
        //cell.textLabel.text = inmueble.nombredelbien;
        //cell.textLabel.font = [UIFont fontWithName:@"FuturaStd-Book" size:14];
        
        //Creo un area para el TextView para que el texto que ponemos en él sea el adecuado
        //CGRect textViewRect = CGRectMake(0, 0, kTextViewWidth, tamano);
        
        CGRect textViewRect = CGRectMake(0, 1, self.view.frame.size.width, 75);
        txtView.frame = textViewRect;
        
        //Actualizo las propiedades del textview
        txtView.contentSize = CGSizeMake(kTextViewWidth, [self heightForTextView:txtView containingString:nombre]);
        txtView.text = nombre;
        txtView.font = [UIFont fontWithName:@"FuturaStd-Book" size:18];
        txtView.userInteractionEnabled = NO;
        
        
        
        if (!inmueble.portadaV) {
            [inmueble consumeFirstImage];
        }
        AsyncImageView * imageView = inmueble.portadaV;
        imageView.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        imageView.tag = IMAGE_VIEW_TAG;
        //[cell addSubview:imageView];
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = TEXT_ON_LABELCELL_FOR_INMUEBLE;
        }else{
            cell.textLabel.text = TEXT_ON_LABELCELL_FOR_aBIEN;
        }
    }
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    //cell.indentationWidth = 44.0f;
    cell.indentationLevel = 1;
    
    return cell;
    
}

#pragma mark - Otros

- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 24;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:kFontSize] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}

-(void)showInmueblesfoundedOnMap{
    if (self.inmuebles != nil && [self.inmuebles count] > 0) {
        RMMapaViewController * mapa = [[RMMapaViewController alloc] initWithArray:self.inmuebles];
        [self.navigationController pushViewController:mapa animated:YES];
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (IS_IPHONE) {
//        //return 80;
//        if (self.inmuebles == nil && self.bienes == nil) {
//            return 70;
//        }
//        
//        UITextView * txtView = (UITextView *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:222];
//        if (txtView.contentSize.height >= 44) {
//            float height = [self heightForTextView:txtView containingString:txtView.text];
//            return height + 8; // a little extra padding is needed
//        }else{
//            return self.tableView.rowHeight;
//        }
//    }else{
//        return 80;
//    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.bienes && !self.inmuebles) {
        if (![[Reachability reachabilityWithHostname:@"www.google.com"] isReachable]) {
            UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"No hay conexión a internet" message:@"Reanude la conexión a internet para continuar con está acción" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alerta show];
            return;
        }else{
            NSInteger pp = indexPath.row;
            RMBusquedaInmuebleViewController * busquedaInmuVC = [[RMBusquedaInmuebleViewController alloc]initWithCase:pp];
            [self.navigationController pushViewController:busquedaInmuVC animated:YES];
        }
        
    }else if (!self.bienes){
        RMInmuebleArriendoViewController * inmuebleVC = [[RMInmuebleArriendoViewController alloc] initWithInmueble:[self.inmuebles objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:inmuebleVC animated:YES];
    }else{
        
        RMBienEnVentaViewController * bienVC = [[RMBienEnVentaViewController alloc] initWithBienVenta:[self.bienes objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:bienVC animated:YES];
    }
    
    
}

@end
