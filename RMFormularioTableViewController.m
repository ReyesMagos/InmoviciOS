//
//  RMFormularioTableViewController.m
//  Inmovic
//
//  Created by Felipe on 1/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMFormularioTableViewController.h"
#import "RMBienVenta.h"
#import "RMInmuebleArriendo.h"

@interface RMFormularioTableViewController ()

#define TITLES_FOR_SECCIONS @[@"Datos Personales", @"Bien Seleccionado"]
#define CELLS_TITLES_FOR_DATOSPERSONALES @[@"Nombre:", @"Apellidos:", @"Número Documento:", @"Ciudad:", @"Teléfono:", @"Proponer un valor superior:"]
#define CELLS_TITLES_FOR_INMUEBLE @[@"Nombre", @"Tipo", @"Área", @"Ubicación", @"Departamento", @"Folio Matrícula", @"Precio"]

#define CORREOS_CONTACTO @[@"arriendos.frv@unidadvictimas.gov.co"]

@property (nonatomic, strong) NSArray * datosInmueble;
@property (nonatomic, strong) UIToolbar * numberToolbar;
@end

@implementation RMFormularioTableViewController

-(id)initWithObject:(id)aObject{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        //NSDictionary * dicc = [NSDictionary alloc]init
        if ([aObject isKindOfClass: [RMInmuebleArriendo class]]) {
            RMInmuebleArriendo* inmu = (RMInmuebleArriendo*)aObject;
            _datosInmueble = @[inmu.nombredelbien, inmu.tipodebien, inmu.tipodeinmueble, inmu.municipio,inmu.departamento, inmu.foliodematriculainmobiliaria, [NSString stringWithFormat:@"%d",inmu.canondearrendamiento]];
        }else if ([aObject isKindOfClass:[RMBienVenta class]]){
            RMBienVenta* inmu = (RMBienVenta*)aObject;
            _datosInmueble = @[@"Arriendo", inmu.tipodebien, @"", inmu.ubicacion,@"", @"No aplica", [NSString stringWithFormat:@"%d",inmu.valordeventa]];
        }
        self.title = @"Más información";
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setScrollEnabled:NO];
    
    UIButton * btnEnviar = [UIButton buttonWithType:UIButtonTypeSystem];
    btnEnviar.frame = CGRectMake(0, 0, 110, 30);
    [btnEnviar addTarget:self action:@selector(sendInformation) forControlEvents:UIControlEventTouchUpInside];
    [btnEnviar setTitle:@"Solicitar información" forState:UIControlStateNormal];
    [self.tableView setTableFooterView:btnEnviar];
    
    
    self.numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    self.numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                           nil];
    [self.numberToolbar sizeToFit];
}


-(IBAction)doneWithNumberPad: (id) sender{
    [[self view] endEditing:TRUE];
}

#pragma mark - Utils

-(void)sendInformation{
    NSString * datosUsuario = [self checkTextFields];
    if (datosUsuario) {
        if ([MFMailComposeViewController canSendMail]) {
            NSString * infoInmueble = [self informacionInmueble];
            NSString * emailTitulo = @"Mas información de un inmueble";
            NSString * messageBodt = [NSString stringWithFormat:@"Hay un usuario de Inmovic para iOS que desea más información acerca del inmueble: \n\n%@\nA continuación encontrará la información del usuario para que comunicarse con él:\n%@", infoInmueble, datosUsuario];
            NSArray * correos= CORREOS_CONTACTO;
            
            MFMailComposeViewController * mc = [[MFMailComposeViewController alloc]init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitulo];
            [mc setMessageBody:messageBodt isHTML:NO];
            [mc setToRecipients:correos];
            
            [self presentViewController:mc animated:YES completion:NULL];
        }
    }
}

-(NSString *)informacionInmueble{
    int lol = 0;
    NSMutableString * aux = [[NSMutableString alloc ]init];
    for (NSString * dd in CELLS_TITLES_FOR_INMUEBLE) {
        NSString * infoinmu = [NSString stringWithFormat:@"%@: %@\n", dd, [self.datosInmueble objectAtIndex:lol]];
        [aux appendString:infoinmu];
        lol++;
    }
    return [aux copy];
}

-(NSString*)checkTextFields{
    NSMutableString * datosUsuario = [[NSMutableString alloc] init];
    //Verifico que las celdas no estén vacias
    int num = 0;
    for (UITableViewCell * cell in self.tableView.visibleCells) {
        
        UITextField * txt = (UITextField *)[cell viewWithTag:123];
        
        NSError * error = nil;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-z0-9.]+" options:NSRegularExpressionCaseInsensitive error:&error];
        if (txt.text == nil) {
            txt.text = @"";
        }
        NSInteger countMatches = [regex numberOfMatchesInString:txt.text options:0 range:NSMakeRange(0, [[txt text] length])];

        if (countMatches == 0) {
            UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Campo vacio" message:@"Tiene que llenar todos los campos para solicitar más información" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            return nil;
        }
        if (num == 5) {
            NSString * valorInmu = [self.datosInmueble objectAtIndex:6];
            if ([txt.text integerValue] < [valorInmu integerValue]) {
                UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Solo puede sugerir un valor de arriendo del inmueble mayor al estipulado que es: %@", valorInmu] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alerta show];
                return nil;
            }
        }
        NSString * aux = [NSString stringWithFormat:@"%@ %@\n", [CELLS_TITLES_FOR_DATOSPERSONALES objectAtIndex:num], txt.text];
        [datosUsuario appendString:aux];
        num++;
    }
    return [datosUsuario copy];
}

#pragma mark - MailCompose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remover Mail view
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    return [TITLES_FOR_SECCIONS count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [TITLES_FOR_SECCIONS objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [CELLS_TITLES_FOR_DATOSPERSONALES count];
    }else{
        return [CELLS_TITLES_FOR_INMUEBLE count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        
        UITextField * txt = (UITextField *)[cell viewWithTag:123];
        //Si hay algo en la celda reutilizada, utilize los subviews que tiene
        if (txt.text) {
            return cell;
        }else{ //Si no, elimine el textfield contenido en la celda
            [[cell viewWithTag:123]removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        //cell.textLabel.text = [CELLS_TITLES_FOR_DATOSPERSONALES objectAtIndex:indexPath.row];
        UITextField * txt = [[UITextField alloc]initWithFrame:CGRectMake(cell.textLabel.frame.size.width, 10.0f, 250.f, 32.0f)];
        txt.clearsOnBeginEditing = NO;
        txt.tag = 123;
        txt.textAlignment = UITextAlignmentLeft;
        txt.delegate = self;
        if (indexPath.row == 5) {
            txt.placeholder = [NSString stringWithFormat:@"%@", [CELLS_TITLES_FOR_DATOSPERSONALES objectAtIndex:indexPath.row]];
        }else{
            txt.placeholder = [NSString stringWithFormat:@"Ingrese %@", [CELLS_TITLES_FOR_DATOSPERSONALES objectAtIndex:indexPath.row]];
        }
        [cell.contentView addSubview:txt];
        [cell setSelected:NO];
        switch (indexPath.row) {
            case 2: case 6: case 5:
                [txt setKeyboardType:UIKeyboardTypeNumberPad];
                txt.inputAccessoryView = self.numberToolbar;
                break;
            
            default:
                //[txt setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                break;
        }
    }else{
        //cell.textLabel.text = [CELLS_TITLES_FOR_INMUEBLE objectAtIndex:indexPath.row];
        [cell setSelected:NO];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width, 10.0f, 250.f, 32.0f)];
        label.text = [self.datosInmueble objectAtIndex:indexPath.row];
        [cell addSubview:label];
        
    }
    
    
    return cell;
}

#pragma mark - TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
