//
//  RMBienEnVentaViewController.m
//  Inmovic
//
//  Created by Felipe on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMBienEnVentaViewController.h"
#import "RMBienVenta.h"
#import "AsyncImageView.h"
#import "Reachability.h"
#import "RMFormularioTableViewController.h"

@interface RMBienEnVentaViewController ()

@property (nonatomic, strong) RMBienVenta * bienVenta;

@property (nonatomic) BOOL bandera;

@end

@implementation RMBienEnVentaViewController



-(id)initWithBienVenta:(RMBienVenta *)aBienV{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _bienVenta = aBienV;
        self.title = @"Bien en Venta";
    }
    return self;
}

-(void)loadView{
    if (IS_IPHONE) {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMBienEnVentaIphone" owner:self options:nil][0];
    }else{
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMBienEnVentaViewController" owner:self options:nil][0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setUserInteractionEnabled:YES];
    self.splitViewFotos.delegate = self;
    self.splitViewFotos.scrollEnabled = YES;
    
    self.descripcionTxtV.text = self.bienVenta.descripcion;
    self.descripcionTxtV.editable = NO;
    self.bandera = NO;
    
    //Agrego un reconocedor al scroll para detectar cuando le han dado touch
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.splitViewFotos addGestureRecognizer:singleTap];
    
    if (IS_IPHONE) {
        //Cargo los views especificos para iphone
        [self viewsForSplitInfo];
    }
    
    [self consumeImages];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.splitViewFotos];
    
    for(int index=0;index<[self.bienVenta.fotos count];index++)
    {
        UIImageView *imgView = [self.bienVenta.fotos objectAtIndex:index];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.imageViewGrande.image = [(UIImageView*)[self.bienVenta.fotos objectAtIndex:0] image];
    self.descripcionTxtV.font = [UIFont fontWithName:@"FuturaStd-Book" size:20];
    //[self consumeImages];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.bandera) {
        self.bandera = NO;
        [[[self.view subviews] lastObject] removeFromSuperview];
        return;
    }


}

-(void)ShowOnViewTheImage: (UIImage*) aImageView{
    
    //Creo una nueva vista donde irá la imagen
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
    CGFloat largoSplit = self.splitViewFotos.frame.size.height;
    
    imageShow.frame = CGRectMake(20, largoSplit + 10, ancho - 40 , largo - largoSplit - 20);
    [self.view addSubview:imageShow];
    
}


-(void)consumeImages{
    int xOffset = 0;
    int scrollWidth = 120;
    
    if (IS_IPHONE) {
        //HAbilitar que la animacion del scroll sea como cambiando de pagina
        self.splitViewFotos.pagingEnabled = YES;
        if ([self.bienVenta.linksfotos count] == 0 || ![[Reachability reachabilityForInternetConnection] isReachable]) {
            AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(65, 10, (self.splitViewFotos.frame.size.width - 20)/1.5, self.splitViewFotos.frame.size.height - 20)];
            imageView.image = [UIImage imageNamed: @"escenariodefecto.png"];
            [self.bienVenta.fotos addObject:imageView];
            [self.splitViewFotos addSubview:imageView];
        }else{
            for(int index=0; index < [self.bienVenta.linksfotos count]; index++)
            {
                CGFloat xOrigin = index*self.splitViewFotos.frame.size.width;
                AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(xOrigin + 65, 10, (self.splitViewFotos.frame.size.width - 20)/1.5, self.splitViewFotos.frame.size.height - 20)];
                //load the image
                imageView.imageURL = [self.bienVenta.linksfotos objectAtIndex:index];
                [self.bienVenta.fotos addObject:imageView];
                [self.splitViewFotos addSubview:imageView];
            }
        }
        
        self.splitViewFotos.contentSize = CGSizeMake(self.splitViewFotos.frame.size.width * [self.bienVenta.fotos count],self.splitViewFotos.frame.size.height);
        
    }else{
        if ([self.bienVenta.linksfotos count] == 0 || ![[Reachability reachabilityForInternetConnection] isReachable]) {
            AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(65, 10, (self.splitViewFotos.frame.size.width - 20)/1.5, self.splitViewFotos.frame.size.height - 20)];
            imageView.image = [UIImage imageNamed: @"escenariodefecto.png"];
            [self.bienVenta.fotos addObject:imageView];
            [self.splitViewFotos addSubview:imageView];
        }else{
            for(int index=0; index < [self.bienVenta.linksfotos count]; index++)
            {
                
                //get image view
                AsyncImageView *imageView = [[AsyncImageView alloc] init];
                imageView.frame = CGRectMake(5+xOffset, 10, 320, 200);
                
                //load the image
                imageView.imageURL = [self.bienVenta.linksfotos objectAtIndex:index];
                
                
                [self.bienVenta.fotos addObject:imageView];
                self.splitViewFotos.contentSize = CGSizeMake(scrollWidth+xOffset,110);
                [self.splitViewFotos addSubview:imageView];
                xOffset += 350;
            }
        }
        self.splitViewFotos.contentSize = CGSizeMake(self.splitViewFotos.contentSize.width + 205,110);
    }
}



#pragma mark - UITableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.bienVenta.atributos count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.bienVenta.atributos objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.bienVenta.tipodebien;
            break;
        case 1:
            cell.textLabel.text = self.bienVenta.ubicacion;
            break;
        case 2:
            cell.textLabel.text = self.bienVenta.informaciondecontacto;
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.bienVenta.valordeventa];
            break;
        default:
            break;
    }
    return cell;
}

-(void) viewsForSplitInfo{
    
    
    float tamanoTable = 370;
    float mitadView = self.view.frame.size.width /2;
    UITableView * all = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.splitInfo.frame.size.width, tamanoTable)];
    all.dataSource = self;
    all.delegate = self;
    [self.splitInfo addSubview:all];
    all.scrollEnabled = NO;
    
    UITextView * txt = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, all.frame.size.width, 100)];
    txt.font = [UIFont fontWithName:@"FuturaStd-Book" size:15];
    txt.editable = NO;
    txt.text = self.bienVenta.descripcion;
    
    [all setTableFooterView:txt];
    
    
    tamanoTable += 5;
    //Creo los respectivos botones
    
    UIButton * btnForm = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btnForm.frame = CGRectMake(mitadView/4, tamanoTable, 60,  60);
    //[btnForm setTitle:@"Formulario" forState:UIControlStateNormal];
    [btnForm setBackgroundImage:[UIImage imageNamed:@"icono-formu.png"] forState:UIControlStateNormal];
    UIButton * btnCompartir = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnCompartir setBackgroundImage:[UIImage imageNamed:@"icono_compartir.png"] forState:UIControlStateNormal];
    btnCompartir.frame = CGRectMake(mitadView, tamanoTable, 60, 60);
    //[btnCompartir setTitle:@"Compartir" forState:UIControlStateNormal];
    
    
    //Asigno las acciones:
    [btnForm addTarget:self action:@selector(formularioBtn:) forControlEvents: UIControlEventTouchUpInside];
    [btnCompartir addTarget:self action:@selector(compartirBtn:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.splitInfo addSubview:btnForm];
    [self.splitInfo addSubview:btnCompartir];
    self.splitInfo.contentSize = CGSizeMake(self.splitInfo.frame.size.width, tamanoTable + 200);
    
}

#pragma mark - Actions


- (IBAction)formularioBtn:(id)sender {
    RMFormularioTableViewController * formu = [[RMFormularioTableViewController alloc] initWithObject:self.bienVenta];
    [self.navigationController pushViewController:formu animated:YES];
}




- (IBAction)compartirBtn:(id)sender {
    NSArray * coords = [[self.bienVenta descripcion] componentsSeparatedByString:@";"];
    NSString * nombrecorto = [coords objectAtIndex:0];
    NSString * info = [NSString stringWithFormat:@"%@ está disponible para comprar.\n\n Se encuentra ubicado en: %@ @UnidadVictimas", nombrecorto, [self.bienVenta ubicacion]];
 
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
