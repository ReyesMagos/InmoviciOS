//
//  RMInmuebleArriendoViewController.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMInmuebleArriendoViewController.h"
#import "RMInmuebleArriendo.h"
#import "RMMapaViewController.h"
#import "RMMyScrollView.h"
#import "AsyncImageView.h"
#import "RMFormularioTableViewController.h"
#import "RMComentariosViewController.h"
#import "Reachability.h"

//Quitar esto
#import <QuartzCore/QuartzCore.h>
#import "RMSoap.h"

#import "RMServicioWS.h"

@interface RMInmuebleArriendoViewController ()

@property (nonatomic, strong) NSArray *imagesName;
@property (nonatomic) BOOL bandera;
@property (nonatomic, strong) RMServicioWS * servicioWS;

@end

@implementation RMInmuebleArriendoViewController


-(id)initWithInmueble:(RMInmuebleArriendo *)aInmueble{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _inmuebleArriendo = aInmueble;
        self.title = @"Detalle Inmueble";
        _imagesName = [[NSArray alloc]initWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",
                      @"5.png",@"6.png",@"7.png",nil];
    }
    return self;
}

-(void)loadView{
    if (IS_IPHONE) {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMInmuebleArriendoViewController~iphone" owner:self options:nil][0];
    }else{
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMInmuebleArriendoViewController~ipad" owner:self options:nil][0];
    }
}

//Sincronizamos modelo y vista
-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.splitFotos.delegate = self;
    self.splitFotos.scrollEnabled = YES;
    //self.splitFotos.contentSize = CGSizeMake(120,80);
    self.bandera = NO;
    
    //Activo este view en NotificationCenter con el fin de saber cuando se desconecta de internet
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];

    
    //Agrego un reconocedor al scroll para detectar cuando le han dado touch
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.splitFotos addGestureRecognizer:singleTap];
    
    [self syncModelWithView];
    
    //[self consumeImagesFromUrls:self.inmuebleArriendo.linksfotos];
    [self ConsumeImages];
    
    //Verifico que existan las coordenadas del inmuebles
    if (![self.inmuebleArriendo.coordenadas isEqualToString:SIN_INFORMACION]) {
        self.btnMapa.enabled = YES;
    }
    
    if (IS_IPHONE) {
        //Cargo los views especificos para iphone
        [self viewsForSplitInfo];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Me doy de da baja en la recepción de notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Este metodo se encarga de notificar a este view si hubo cambios en la conexión a internet
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    if ([reachability isReachable]) {
        NSLog(@"Conectado a internet2");
        [self ConsumeImages];
        
    } else {
        
        NSLog(@"Sin conexión a internet2");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)mapaBtn:(id)sender {
    RMMapaViewController * mapa = [[RMMapaViewController alloc] initWithName:self.inmuebleArriendo.nombredelbien
                                                                    location:[NSString stringWithFormat:@"%@ - %@",
                                                                              self.inmuebleArriendo.municipio,
                                                                              self.inmuebleArriendo.departamento]
                                                                  coordinate:self.inmuebleArriendo.coordenadas];
    
    [self.navigationController pushViewController:mapa animated:YES];
}

- (IBAction)formularioBtn:(id)sender {
    RMFormularioTableViewController * formu = [[RMFormularioTableViewController alloc] initWithObject:self.inmuebleArriendo];
    [self.navigationController pushViewController:formu animated:YES];
}

- (IBAction)puntuacionesBtn:(id)sender {
    RMComentariosViewController* coment = [[RMComentariosViewController alloc]initWithInmueble:self.inmuebleArriendo style:UITableViewStyleGrouped];
    [self.navigationController pushViewController:coment animated:YES];
}


- (IBAction)compartirBtn:(id)sender {
    NSArray * coords = [[self.inmuebleArriendo nombredelbien] componentsSeparatedByString:@"."];
    NSString * nombrecorto = [coords objectAtIndex:0];
    NSString * info = [NSString stringWithFormat:@"Está en arriendo %@ en %@ con valor de %d -goo.gl/jQCf9c \n\nCompartido a tráves de Inmovic para iOS", nombrecorto , [self.inmuebleArriendo municipio], [self.inmuebleArriendo canondearrendamiento]];
    
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

-(void)ShowOnViewTheImage: (UIImage*) aImageView{
    
    //Creo una nueva vista donde irá la imagen
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(68, 102, 633, 722)];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor blackColor];
    
    //Asigno el tipo de transición y el tiempo que demora al nuevo View
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionReveal;
    [view.layer addAnimation:transition forKey:nil];
    
    
    AsyncImageView * imageShow = [[AsyncImageView alloc ] initWithImage: aImageView] ;
    //Agrego una animación
    [imageShow.layer addAnimation:transition forKey:nil];
    
    CGFloat ancho = self.view.frame.size.width;
    CGFloat largo = self.view.frame.size.height;
    CGFloat largoSplit = self.splitFotos.frame.size.height;
    
    imageShow.frame = CGRectMake(20, largoSplit + 10, ancho - 40 , largo - largoSplit - 20);
    [self.view addSubview:imageShow];

}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.splitFotos];
    
    for(int index=0;index<[self.inmuebleArriendo.fotos count];index++)
    {
        UIImageView *imgView = [self.inmuebleArriendo.fotos objectAtIndex:index];
        UIImage * imagen = imgView.image;
        
        if(CGRectContainsPoint([imgView frame], touchPoint))
        {
            
            //Miro si la imagen que está ampliada es la misma a la que se le hizo touch
            if (self.bandera && [(AsyncImageView*)[[self.view subviews] lastObject] image] == imagen) {
                [[[self.view subviews] lastObject] removeFromSuperview];
                self.bandera = NO;
            }else{
                if ([[self.view.subviews lastObject] isKindOfClass:[AsyncImageView class]]){
                    [[[self.view subviews] lastObject] removeFromSuperview];
                }
                [self ShowOnViewTheImage:imagen];
                self.bandera = YES;
            }
            return;
        }else{
            
        }
    }
}


#pragma mark - UIView Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bandera) {
        self.bandera = NO;
        [[[self.view subviews] lastObject] removeFromSuperview];
        return;
    }

}



#pragma mark - Utils
-(void)appearance{
    
}

-(void) syncModelWithView{
    self.descripcionTxtV.text = self.inmuebleArriendo.descripcion;
    self.descripcionTxtV.font = [UIFont fontWithName:@"FuturaStd-Book" size:20];
}


-(void)ConsumeImages{
    int xOffset = 0;
    int scrollWidth = 120;

    if (IS_IPHONE) {
        //HAbilitar que la animacion del scroll sea como cambiando de pagina
        self.splitFotos.pagingEnabled = YES;
        self.splitFotos.delegate = self;
        
        if ([self.inmuebleArriendo.linksfotos count] == 0 || ![[Reachability reachabilityForInternetConnection] isReachable]) {
            AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(65, 10, (self.splitFotos.frame.size.width - 20)/1.5, self.splitFotos.frame.size.height - 20)];
            
            imageView.image = [UIImage imageNamed: @"logouariv.png"];
            [self.inmuebleArriendo.fotos addObject:imageView];
            [self.splitFotos addSubview:imageView];
            
        }else{
            for(int index=0; index < [self.inmuebleArriendo.linksfotos count]; index++)
            {
                CGFloat xOrigin = index*self.splitFotos.frame.size.width;
                AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(xOrigin + 65, 10, (self.splitFotos.frame.size.width - 20)/1.5, self.splitFotos.frame.size.height - 20)];
                //load the image
                imageView.imageURL = [self.inmuebleArriendo.linksfotos objectAtIndex:index];
                
                [self.inmuebleArriendo.fotos addObject:imageView];
                [self.splitFotos addSubview:imageView];
            }
        }
        
        self.splitFotos.contentSize = CGSizeMake(self.splitFotos.frame.size.width * [self.inmuebleArriendo.fotos count],self.splitFotos.frame.size.height);
        
    }else{
        if ([self.inmuebleArriendo.linksfotos count] == 0 || ![[Reachability reachabilityForInternetConnection] isReachable]) {
            AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(65, 10, (self.splitFotos.frame.size.width - 20)/1.5, self.splitFotos.frame.size.height - 20)];
            imageView.image = [UIImage imageNamed: @"logouariv.png"];
            [self.inmuebleArriendo.fotos addObject:imageView];
            [self.splitFotos addSubview:imageView];
        }else{
            for(int index=0; index < [self.inmuebleArriendo.linksfotos count]; index++)
            {
                //        UIImageView *img = [self.inmuebleArriendo.fotos objectAtIndex:index];
                //        img.bounds = CGRectMake(30, 30, 80, 80);
                //        img.frame = CGRectMake(5+xOffset, 10, 320, 200);
                //        self.splitFotos.contentSize = CGSizeMake(scrollWidth+xOffset,110);
                //        [self.splitFotos addSubview:img];
                //        xOffset += 350;
                
                //get image view
                AsyncImageView *imageView = [[AsyncImageView alloc] init];
                imageView.frame = CGRectMake(5+xOffset, 10, 320, 200);
                
                //load the image
                imageView.imageURL = [self.inmuebleArriendo.linksfotos objectAtIndex:index];
                
                
                [self.inmuebleArriendo.fotos addObject:imageView];
                self.splitFotos.contentSize = CGSizeMake(scrollWidth+xOffset,110);
                [self.splitFotos addSubview:imageView];
                xOffset += 350;
            }
        }
        self.splitFotos.contentSize = CGSizeMake(self.splitFotos.contentSize.width + 205,110);
    }
}

-(void) viewsForSplitInfo{
    
    
    
    self.splitFotos.userInteractionEnabled = YES;
    
    float tamanoTable = 700;
    float mitadView = self.view.frame.size.width /2;
    UITableView * all = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.splitInfo.frame.size.width, tamanoTable)];
    all.dataSource = self;
    all.delegate = self;
    [self.splitInfo addSubview:all];
    all.scrollEnabled = NO;
    
    UITextView * txt = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, all.frame.size.width, 100)];
    txt.font = [UIFont fontWithName:@"FuturaStd-Book" size:15];
    txt.editable = NO;
    txt.text = self.inmuebleArriendo.descripcion;
    
    [all setTableFooterView:txt];
    
    
    tamanoTable += 5;
    //Creo los respectivos botones
    UIButton * btnMapa = [UIButton buttonWithType:UIButtonTypeSystem];
    btnMapa.frame = CGRectMake(mitadView/4, tamanoTable, 110, 30);
    [btnMapa setTitle:@"Mapa" forState:UIControlStateNormal];
    
    UIButton * btnForm = [UIButton buttonWithType:UIButtonTypeSystem];
    btnForm.frame = CGRectMake(mitadView, tamanoTable, 110,  30);
    [btnForm setTitle:@"Formulario" forState:UIControlStateNormal];
    tamanoTable += 10 + btnForm.frame.size.height;
    
    UIButton * btnPunt = [UIButton buttonWithType:UIButtonTypeSystem];
    btnPunt.frame = CGRectMake(mitadView/4, tamanoTable, 110, 30);
    [btnPunt setTitle:@"Puntuaciones" forState:UIControlStateNormal];
    
    UIButton * btnCompartir = [UIButton buttonWithType:UIButtonTypeSystem];
    btnCompartir.frame = CGRectMake(mitadView, tamanoTable, 110, 30);
    [btnCompartir setTitle:@"Compartir" forState:UIControlStateNormal];
    
    tamanoTable += 10 + btnPunt.frame.size.height;
    
    //Asigno las acciones:
    [btnMapa addTarget:self action:@selector(mapaBtn:) forControlEvents: UIControlEventTouchUpInside];
    [btnForm addTarget:self action:@selector(formularioBtn:) forControlEvents: UIControlEventTouchUpInside];
    [btnPunt addTarget:self action:@selector(puntuacionesBtn:) forControlEvents: UIControlEventTouchUpInside];
    [btnCompartir addTarget:self action:@selector(compartirBtn:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.splitInfo addSubview:btnMapa];
    [self.splitInfo addSubview:btnForm];
    [self.splitInfo addSubview:btnPunt];
    [self.splitInfo addSubview:btnCompartir];
    self.splitInfo.contentSize = CGSizeMake(self.splitInfo.frame.size.width, tamanoTable + 170);

}

#pragma mark - UITableView delegate
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.descripcionTxtV.bounds.size.width, 30)];
//    [header setBackgroundColor:[UIColor redColor]];
//    return header;
//}

//Color del table
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //view.tintColor = [UIColor colorWithRed:0.695 green:0.000 blue:0.112 alpha:1.000];
}

#pragma mark - UITableView data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.inmuebleArriendo.atributos count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.inmuebleArriendo.atributos objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.inmuebleArriendo.nombredelbien;
            break;
        case 1:
            cell.textLabel.text = self.inmuebleArriendo.departamento;
            break;
        case 2:
            cell.textLabel.text = self.inmuebleArriendo.municipio;
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.inmuebleArriendo.numerodebanos];
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.inmuebleArriendo.numerodehabitaciones];
            break;
        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.inmuebleArriendo.canondearrendamiento];
            break;
        case 6:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.inmuebleArriendo.contacto];
            break;
        case 7:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.inmuebleArriendo.foliodematriculainmobiliaria];
            break;
        case 8:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.inmuebleArriendo.areaconstruida];
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"FuturaStd-FuturaStd-Heavy" size:17];
    return cell;
}


@end
