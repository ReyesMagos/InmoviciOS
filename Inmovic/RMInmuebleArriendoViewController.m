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
//Quitar esto
#import <QuartzCore/QuartzCore.h>

@interface RMInmuebleArriendoViewController ()

@property (nonatomic, strong) NSArray *imagesName;
@property (nonatomic) BOOL bandera;

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

//Sincronizamos modelo y vista
-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.splitFotos.delegate = self;
    self.splitFotos.scrollEnabled = YES;
    self.splitFotos.contentSize = CGSizeMake(120,80);
    self.bandera = NO;
    [self syncModelWithView];
    //[self consumeImagesFromUrls:self.inmuebleArriendo.linksfotos];
    [self otracosa];
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

-(void)ShowOnViewTheImage: (UIImageView *) aImageView{
    
    //Creo una nueva vista donde irá la imagen
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(68, 102, 633, 722)];
    view.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor blackColor];
    
    //Asigno el tipo de transición y el tiempo que demora al nuevo View
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionReveal;
    [view.layer addAnimation:transition forKey:nil];
    
    //La imagen que ha sido seleccionada por el scrollview
    UIImageView * imageShow = [[UIImageView alloc ] initWithImage: aImageView.image] ;
    imageShow.frame = CGRectMake(20, 200, 593, 348);
    
    //Asigno los respectivos views
    [self.view addSubview:view];
    [view addSubview:imageShow];

}



#pragma mark - UIView Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [[event allTouches] anyObject];
    
//    for (UIImageView in self.inmuebleArriendo.fotos) {
//        if (CGRectContainsPoint([imgView frame], [touch locationInView:scrollView])) {
//            
//        }
//    }
    if (self.bandera) {
        self.bandera = NO;
        [[[self.view subviews] lastObject] removeFromSuperview];
        return;
    }
    
    for(int index=0;index<[self.inmuebleArriendo.fotos count];index++)
    {
        UIImageView *imgView = [self.inmuebleArriendo.fotos objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], [touch locationInView:self.splitFotos]))
        {
            [self ShowOnViewTheImage:imgView];
            self.bandera = YES;
            NSLog(@"foto: %d", index);
            break;
        }
    }

}

#pragma mark - Utils
-(void) syncModelWithView{
//    self.nombreLB.text = self.inmuebleArriendo.nombredelbien;
//    self.deptoLB.text = self.inmuebleArriendo.departamento;
//    self.municipioLB.text = self.inmuebleArriendo.municipio;
//    self.nroBanosLB.text = [NSString stringWithFormat:@"%d", self.inmuebleArriendo.numerodebanos];
//    self.nroPiezasLB.text = [NSString stringWithFormat:@"%d", self.inmuebleArriendo.numerodehabitaciones];
//    self.canonArLB.text = [NSString stringWithFormat:@"%d", self.inmuebleArriendo.canondearrendamiento];
//    self.telefonoLB.text = self.inmuebleArriendo.contacto;
    self.descripcionTxtV.text = self.inmuebleArriendo.descripcion;
}

-(void)consumeImagesFromUrls: (NSArray *) aArray{
    
    // Obtenemos la cola de segundo plano
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    //Llamo a un segundo hilo de ejecución en background
    dispatch_async(backgroundQueue, ^{
        for (NSURL * urlFoto in aArray) {
            NSData * datosFoto = [NSData dataWithContentsOfURL: urlFoto];
            UIImage * foto = [[ UIImage alloc] initWithData:datosFoto];
            
            UIImageView * fotoenView = [[UIImageView alloc] initWithImage:foto];
            [self.inmuebleArriendo.fotos addObject:fotoenView];
            NSLog(@"consumi %@", urlFoto);
            //Vuelvo a llamar al hilo principal
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.splitFotos addSubview:fotoenView];
            });
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.splitFotos addSubview:fotoenView];
            [self otracosa];
        });
        
    });
}

-(void) otroConsumo: (NSArray * ) aArray{

}

-(void)otracosa{
    int xOffset = 0;
    int scrollWidth = 120;
    self.splitFotos.contentSize = CGSizeMake(scrollWidth,80);
    if ([self.inmuebleArriendo.linksfotos count] == 0) {
        AsyncImageView *imageView = [[AsyncImageView alloc] init];
        imageView.frame = CGRectMake(5+xOffset, 10, 320, 200);
        imageView.image = [UIImage imageNamed: @"escenariodefecto.png"];
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
    
    
//    for(int index=0; index < [self.imagesName count]; index++)
//    {
//        
//        UIImageView *img = [[UIImageView alloc] init];
//        img.bounds = CGRectMake(30, 30, 80, 80);
//        img.frame = CGRectMake(5+xOffset, 10, 320, 200);
//        NSLog(@"image: %@",[self.imagesName objectAtIndex:index]);
//        img.image = [UIImage imageNamed:[self.imagesName objectAtIndex:index]];
//        [self.inmuebleArriendo.fotos addObject:img];
//        self.splitFotos.contentSize = CGSizeMake(scrollWidth+xOffset,110);
//        [self.splitFotos addSubview:img];
//        
//        xOffset += 350;
//    }
    self.splitFotos.contentSize = CGSizeMake(self.splitFotos.contentSize.width + 205,110);
    
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
        default:
            break;
    }
    return cell;
}


@end
