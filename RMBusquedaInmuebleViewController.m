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
#define PRIMERO_DEPTO @"Ingrese primero depto"
#define SELECCIONE @"-Seleccione"

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
            self.title = @"Búsqueda";
            self.hayBien = NO;
            self.parametrosBusqueda = @[@"Departamento:", @"Municipio:", @"Tipo de bien:", @"Tipo Inmueble:", @"Uso:", @"Baños:", @"Habitaciones:", @"Valor:"];
        }else{
            self.title = @"Búsqueda";
            self.tituloLB.text = @"Búsqueda de Bienes en Venta";
            self.hayBien = YES;
            self.parametrosBusqueda = @[@"Tipo de Bien:", @"Ubicación:", @"Valor:"];

        }
        
        //Elimino los espacios sobrantes del table
        [self.parametrosTView setTableFooterView:[UIView new]];
        
        self.parametros = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(void)loadView{
    if (IS_IPHONE) {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMBusquedaInmuebleViewController~iphone" owner:self options:nil][0];
    }else{
        self.view = [[NSBundle mainBundle] loadNibNamed:@"RMBusquedaInmuebleViewController~ipad" owner:self options:nil][0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Cargo la configuración de la apariencia
    [self appearance];
    
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

#pragma mark - Utils

//Configura el aspecto fisico del view
-(void)appearance{
    if ([self.parametrosBusqueda count] == 3) {
        self.tituloLB.text = @"Búsqueda de Bienes";
        self.parametrosTView.scrollEnabled = NO;
        if (IS_IPHONE) {
            [self viewsForSplitInfo];
        }
        
    }else{
        self.tituloLB.text = @"Búsqueda de Inmuebles";
        if (IS_IPHONE) {
            [self viewsForSplitInfo];
        }
        
    }
    [self.parametrosTView setTableFooterView:[UIView new]];
    self.tituloLB.font = [UIFont fontWithName:@"FuturaStd-Heavy" size:25];
    
}

-(void)fillArrays{
    //Recupero el listado de Departamentos en la carpeta de soporte
    //NSBundle * paquete = [NSBundle mainBundle];
    //NSString *ruta = [paquete pathForResource:@"Departamentos" ofType:@"plist"];
    //self.departamentos = [[NSArray alloc] initWithContentsOfFile:ruta];
    
    //Creo un arreglo, lo lleno del numeros
    NSMutableArray * auxCount = [[NSMutableArray alloc]init];
    [auxCount addObject:SELECCIONE];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.parametrosBusqueda count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    iOSCombobox *myCombo = (iOSCombobox*)[cell viewWithTag:indexPath.section];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCombo = [[iOSCombobox alloc] init];
        myCombo.tag = indexPath.section;
        myCombo.delegate = self;

    }
    
    //cell.textLabel.text = [self.parametrosBusqueda objectAtIndex: indexPath.row];

    
    if (IS_IPHONE) {
        CGRect  myRect = CGRectMake(20, 10.0f, 250.f, 32.0f);
        [myCombo setFrame:myRect];
        
    }else{
        [myCombo setFrame:CGRectMake(20, 10.0f, self.view.frame.size.width/2, 32.0f)];
        CGPoint centerCell = CGPointMake((self.view.frame.size.width/2), cell.center.y);
        [myCombo setCenter:centerCell];
    }
    
    
    
    //[myCombo setCurrentValue:SELECCIONE];
    
    
    if ([self.parametrosBusqueda count] == 3) {
        switch (indexPath.section) {
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
        switch (indexPath.section) {
            case 0:
                [myCombo setValues:self.inmobiliaria.inDepartamentos];
                break;
            case 1:
                myCombo.enabled = NO;
                [myCombo setCurrentValue:PRIMERO_DEPTO];
                //[myCombo setValues:self.inmobiliaria.inMunicipios];
                break;
            case 2:
                [myCombo setValues:self.inmobiliaria.inTiposdeBienes];
                break;
            case 3:
                [myCombo setValues:self.inmobiliaria.inTiposInmuebles];
                break;
            case 4:
                [myCombo setValues:self.inmobiliaria.inUsos];
                break;
            case 5:
                [myCombo setValues:self.banosYHabitaciones];
                break;
            case 6:
                [myCombo setValues:self.banosYHabitaciones];
                break;
            case 7:
                [myCombo setValues:self.inmobiliaria.inValor];
                break;
                
            default:
                break;
        }
    }
    
    //Pongo el combo box en el centro de la celda
    //CGPoint centerCell = CGPointMake((self.view.frame.size.width/2), cell.center.y);
    //[myCombo setCenter:centerCell];
    
    
    
    [self.parametros addObject:myCombo];
    
    [cell addSubview:myCombo];

    return cell;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.parametrosBusqueda objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
        if (![entrada isEqualToString:SELECCIONE] && ![entrada isEqualToString: PRIMERO_DEPTO] ) {
            [params addObject:entrada];
        }
    }
    return [params copy];
}

#pragma mark - UIScrollView delegate
-(void) viewsForSplitInfo{
    
    float tamanoTable = 600;
    //Para preguntar cómo debe ser el tamaño del uitable view
    if ([self.parametrosBusqueda count] == 3) {
        tamanoTable = 250;
    }
    
    UITableView * all = (UITableView*)[self.scrollViews viewWithTag:111];
    if (!all) {
        all = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollViews.frame.size.width, tamanoTable)];
        self.parametrosTView = all;
        all.dataSource = self;
        all.delegate = self;
        all.tag = 111;
        [self.scrollViews addSubview:all];
        [all setTableFooterView:[UIView new]];
        
        UIButton * btnEnviar = [UIButton buttonWithType:UIButtonTypeSystem];
        btnEnviar.frame = CGRectMake(0, 0, 110, 30);
        btnEnviar.center = CGPointMake(all.frame.size.width/2, tamanoTable);
        [btnEnviar setTitle:@"Buscar" forState:UIControlStateNormal];
        [self.scrollViews addSubview:btnEnviar];
        
        //Asigno las acciones:
        [btnEnviar addTarget:self action:@selector(searchInmueble:) forControlEvents: UIControlEventTouchUpInside];
        
        self.scrollViews.contentSize = CGSizeMake(self.scrollViews.frame.size.width, tamanoTable+170);
    }
    
}

-(void)comboboxChanged:(iOSCombobox *)combobox toValue:(NSString *)toValue{
    //Preguntamos si el combo box es el primero del TableView y preguntamos también si la TableView es la de inmuebles
    if (combobox.tag == 0 && [self.parametrosTView numberOfSections] != 3) {
        UITableViewCell * muni = [self.parametrosTView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        iOSCombobox * combo = (iOSCombobox*)[muni viewWithTag:1];
        NSString * textoDepto = combobox.currentValue;
        if ([textoDepto isEqualToString:SELECCIONE]) {
            if ([combo isEnabled]) {
                combo.enabled = NO;
                combo.currentValue = PRIMERO_DEPTO;
            }
        }else{
            combo.currentValue = SELECCIONE;
            [combo setValues:[self.inmobiliaria searchMunicipiosWithDepartamento:combobox.currentValue]];
            combo.enabled = YES;
        }
    }
}

#pragma mark UIPickerViewDelegate methods

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[self view] endEditing:TRUE];
    [pickerView removeFromSuperview];
}

@end
