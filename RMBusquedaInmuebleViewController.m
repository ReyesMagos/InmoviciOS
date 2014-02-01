//
//  RMBusquedaInmuebleViewController.m
//  Inmovic
//
//  Created by imaclis on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMBusquedaInmuebleViewController.h"
#import "iOSCombobox.h"
#import "RMInmobiliariaModel.h"
#import "RMTipoBusquedaViewController.h"
#import "RMInmuebleArriendo.h"
#import "RMBienVenta.h"
#define FOR_INMUEBLE 0
@interface RMBusquedaInmuebleViewController ()

@property (nonatomic, strong) NSArray * parametrosBusqueda;
@property (nonatomic, strong) NSMutableArray * banosYHabitaciones;
@property (nonatomic, strong) NSMutableArray * parametros;
@property (nonatomic, strong) RMInmobiliariaModel* inmobiliaria;
@property (nonatomic) BOOL hayBien;

@end

@implementation RMBusquedaInmuebleViewController

-(id)initWithCase:(int)aCase{
    if (self = [super initWithNibName:nil bundle:nil]) {
        if (aCase == FOR_INMUEBLE) {
            self.title = @"Búsqueda de Inmuebles";
            self.hayBien = NO;
            self.parametrosBusqueda = @[@"Departamento:", @"Tipo de bien:", @"Tipo Inmueble:", @"Uso:", @"Baños:", @"Habitaciones:", @"Valor:"];
        }else{
            self.title = @"Búsqueda de Bienes en Venta";
            self.hayBien = YES;
            self.parametrosBusqueda = @[@"Tipo de Bien:", @"Ubicación:", @"Valor:"];

        }
        self.parametros = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.inmobiliaria = [RMInmobiliariaModel sharedManager];
    if (self.hayBien) {
        [self.inmobiliaria consumeBienesVenta];
    }else{
        [self fillArrays];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillArrays{
    //Recupero el listado de Departamentos en la carpeta de soporte
    //NSBundle * paquete = [NSBundle mainBundle];
    //NSString *ruta = [paquete pathForResource:@"Departamentos" ofType:@"plist"];
    //self.departamentos = [[NSArray alloc] initWithContentsOfFile:ruta];
    
    //Creo un arreglo, lo lleno del numeros
    NSMutableArray * auxCount = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 10; i++) {
        [auxCount addObject: [NSString stringWithFormat:@"%d", i]];
    }
    self.banosYHabitaciones = [auxCount copy];
    
    //Asigno los tipos de inmuebles
    //self.tiposInmuebles = @[@"Rural", @"Urbano"];
    //Asigno los tipos de bienes;
    //self.tiposdeBienes = @[@"Apartamento", @"Casa", @"Edificio", @"Finca", @"Hacienda", @"Lote", @"Oficina"];
    //Asigno los usos de los bienes
    //self.usos = @[ @"Agricultura", @"Agropecuario", @"Comercial", @"Oficina", @"Pecuario", @"Recreacional", @"Residencial",];
}

#pragma mark - UITableView data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.parametrosBusqueda count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.parametrosBusqueda objectAtIndex: indexPath.row];

    
    CGRect myRect = CGRectMake(cell.frame.size.width, 10.0f, 250.f, 32.0f);
    iOSCombobox *myCombo = [[iOSCombobox alloc] initWithFrame:myRect];
    myCombo.pickerView.tag = indexPath.row;
    if ([self.parametrosBusqueda count] == 3) {
        switch (indexPath.row) {
            case 0:
                [myCombo setValues:self.inmobiliaria.bnTiposdeBienes];
                break;
            case 1:
                [myCombo setValues:self.inmobiliaria.bnUbicaciones];
                break;
            case 2:
                [myCombo setValues:self.inmobiliaria.bnValor];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                [myCombo setValues:self.inmobiliaria.inDepartamentos];
                break;
            case 1:
                [myCombo setValues:self.inmobiliaria.inTiposdeBienes];
                break;
            case 2:
                [myCombo setValues:self.inmobiliaria.inTiposInmuebles];
                break;
            case 3:
                [myCombo setValues:self.inmobiliaria.inUsos];
                break;
            case 4:
                [myCombo setValues:self.banosYHabitaciones];
                break;
            case 5:
                [myCombo setValues:self.banosYHabitaciones];
                break;
            case 6:
                [myCombo setValues:self.inmobiliaria.inValor];
                break;
                
            default:
                break;
        }
    }
    
    [self.parametros addObject:myCombo];
    [myCombo setCurrentValue:@"Seleccione"];
    [cell.contentView addSubview:myCombo];

    return cell;

}


#pragma mark UIView methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

- (IBAction)searchInmueble:(id)sender {

    NSArray* listaParametros = [self getParamsList];
    NSMutableArray* listaInmueblesEncontrados = [[NSMutableArray alloc] init];
    
    if ([self.parametrosBusqueda count] == 3) {
        for (RMBienVenta* bien in [self.inmobiliaria bienesArray]) {
            if ([bien isABienByArray:listaParametros]){
                [listaInmueblesEncontrados addObject:bien];
            }
        }
    }else{
        for (RMInmuebleArriendo* inmu in [self.inmobiliaria inmueblesArray]) {
            if ([inmu isInmuebleByArray:listaParametros]){
                [listaInmueblesEncontrados addObject:inmu];
            }
        }
    }

    
    if ([listaInmueblesEncontrados count] == 0) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Alerta"
                                                          message:@"No se encontró ningún registro"
                                                         delegate:self cancelButtonTitle:@"Aceptar"
                                                otherButtonTitles:nil];
        [alerta show];
    }else{
        if ([self.parametrosBusqueda count] == 3) {
            RMTipoBusquedaViewController* encontradosVC = [[RMTipoBusquedaViewController alloc] initWithBien:[listaInmueblesEncontrados copy] style:UITableViewStylePlain];
            [self.navigationController pushViewController:encontradosVC animated:YES];
        }else{
            RMTipoBusquedaViewController* encontradosVC = [[RMTipoBusquedaViewController alloc] initWithInmueble:[listaInmueblesEncontrados copy] style:UITableViewStylePlain];
            [self.navigationController pushViewController:encontradosVC animated:YES];
        }
        
    }
}

//Método que obtiene un array con la lista de todos los parametros ingresados
-(NSArray*)getParamsList{
    NSMutableArray * params = [[NSMutableArray alloc] init];
    for (iOSCombobox * oi in self.parametros) {
        NSString * entrada = oi.currentValue;
        if (![entrada isEqualToString:@"Seleccione"]) {
            [params addObject:entrada];
        }
    }
    return [params copy];
}

@end
