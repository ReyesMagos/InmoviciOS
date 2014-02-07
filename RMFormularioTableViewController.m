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
#define CELLS_TITLES_FOR_DATOSPERSONALES @[@"Nombre:", @"Apellidos:", @"Número Documento:", @"Ciudad:", @"Teléfono:", @"Correo electrónico:"]
#define CELLS_TITLES_FOR_INMUEBLE @[@"Nombre", @"Tipo", @"Área", @"Ubicación", @"Departamento", @"Folio Matrícula", @"Precio"]
@property (nonatomic, strong) NSArray * datosInmueble;
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

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
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [CELLS_TITLES_FOR_DATOSPERSONALES objectAtIndex:indexPath.row];
        UITextField * txt = [[UITextField alloc]initWithFrame:CGRectMake(cell.textLabel.frame.size.width, 10.0f, 250.f, 32.0f)];
        txt.clearsOnBeginEditing = NO;
        
        txt.textAlignment = UITextAlignmentLeft;
        txt.delegate = self;
        txt.placeholder = [NSString stringWithFormat:@"Ingrese %@", cell.textLabel.text];
        [cell.contentView addSubview:txt];
    }else{
        cell.textLabel.text = [CELLS_TITLES_FOR_INMUEBLE objectAtIndex:indexPath.row];
        [cell setSelected:NO];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width, 10.0f, 250.f, 32.0f)];
        label.text = [self.datosInmueble objectAtIndex:indexPath.row];
        [cell addSubview:label];
        
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
