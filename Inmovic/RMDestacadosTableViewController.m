//
//  RMDestacadosTableViewController.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMDestacadosTableViewController.h"
#import "RMInmobiliariaModel.h"
#import "RMInmuebleArriendoViewController.h"
#import "RMInmuebleArriendo.h"
#import "AsyncImageView.h"
#import "RMTipoBusquedaViewController.h"

@interface RMDestacadosTableViewController ()

@end

@implementation RMDestacadosTableViewController

-(id)initWithInmobiliaria:(RMInmobiliariaModel *)aInmobiliaria
                    style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _inmobiliaria = aInmobiliaria;
        self.title = @"Destacados";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Agrego el color que tendrá el navigation controller
    /**
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.5
                                                                        green:0
                                                                         blue:0.13
                                                                        alpha:1];
     **/
    UIBarButtonItem *btnReload = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnReloadPressed:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = btnReload;
    btnReload.enabled=TRUE;
    //btnReload.style=UIBarButtonSystemItemRefresh;
    
    //Esto refresca el tableview. Especial para cuando se regresa de la vista de una búsqueda.
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == INMUEBLES_ARRIENDO_SECTION) {
        //return self.inmobiliaria.inmuebleArriendoCount;
        return 6;
    }else{
        return self.inmobiliaria.bienVentaCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    #define IMAGE_VIEW_TAG 99
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        //add AsyncImageView to cell
		//AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
		//imageView.contentMode = UIViewContentModeScaleAspectFill;
		//imageView.clipsToBounds = YES;
		//imageView.tag = IMAGE_VIEW_TAG;
		//[cell addSubview:imageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.indentationWidth = 44.0f;
		cell.indentationLevel = 1;
    }else{
        [(AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG] removeFromSuperview];
    }
    
    
    //Averiguo cuál es el bien o inmueble que debe ir en la respectiva celda
    if (indexPath.section == INMUEBLES_ARRIENDO_SECTION) {
        RMInmuebleArriendo * inmueble = [self.inmobiliaria inmuebleArriendoAtIndex:indexPath.row];
        cell.textLabel.text = inmueble.nombredelbien;
        if (!inmueble.portadaV) {
            [inmueble consumeFirstImage];
        }
        AsyncImageView * imageView = inmueble.portadaV;
        imageView.tag = IMAGE_VIEW_TAG;
        //[[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        [cell addSubview:imageView];
        
        //cell.imageView.image = inmueble.portada;
        //Agrego lo que va en la celda
        
        //AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
        //[[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        //imageView.imageURL = [inmueble.linksfotos objectAtIndex:0];
        
    }else{
        //RMBienVenta * bien = [self.inmobiliaria bienVentaAtIndex:indexPath.row];
        
        //Agrego lo que va en la celda
    }
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Averiguo cuál es el bien o inmueble que debe ir
    if (indexPath.section == INMUEBLES_ARRIENDO_SECTION) {
        RMInmuebleArriendo * inmueble = [self.inmobiliaria inmuebleArriendoAtIndex:indexPath.row];
        
        //Creo el controlador de la vista de detalle
        RMInmuebleArriendoViewController * inmuebleVC = [[RMInmuebleArriendoViewController alloc] initWithInmueble:inmueble];
        
        //Realizo un push al nuevo controllador
        [self.navigationController pushViewController:inmuebleVC animated:YES];
        
    }else{
       // RMBienVenta * bien = [self.inmobiliaria bienVentaAtIndex:indexPath.row];
        
        
    }
    
}

#pragma mark - utilis
-(IBAction)btnReloadPressed:(id)sender {
    RMTipoBusquedaViewController * tipoBusquedaVC = [[RMTipoBusquedaViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:tipoBusquedaVC animated:YES];
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
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
