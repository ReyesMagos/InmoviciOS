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

@interface RMTipoBusquedaViewController ()

@property (nonatomic, strong) NSArray* inmuebles;
@property (nonatomic, strong) NSArray* bienes;

@property (nonatomic, strong) NSArray* encontrados;

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
        self.title = @"Inmuebles Encontrados";
    }
    return self;
}

-(id)initWithBien:(NSArray *)aBien style:(UITableViewStyle)aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _bienes = aBien;
        self.title = @"Bienes Encontrados";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    

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
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (self.bienes) {
        RMBienVenta * bienVta = [self.bienes objectAtIndex:indexPath.row];
        cell.textLabel.text = [bienVta tipodebien];
        if (!bienVta.portadaV) {
            [bienVta consumeFirstImage];
        }
        AsyncImageView * imageView = bienVta.portadaV;
        imageView.tag = IMAGE_VIEW_TAG;
        [cell addSubview:imageView];
        
    }else if(self.inmuebles) {
        RMInmuebleArriendo * inmueble = [self.inmuebles objectAtIndex: indexPath.row];
        cell.textLabel.text = inmueble.nombredelbien;
        if (!inmueble.portadaV) {
            [inmueble consumeFirstImage];
        }
        AsyncImageView * imageView = inmueble.portadaV;
        imageView.tag = IMAGE_VIEW_TAG;
        [cell addSubview:imageView];
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = TEXT_ON_LABELCELL_FOR_INMUEBLE;
        }else{
            cell.textLabel.text = TEXT_ON_LABELCELL_FOR_aBIEN;
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.indentationWidth = 44.0f;
    cell.indentationLevel = 1;

    return cell;

}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.bienes && !self.inmuebles) {
        RMBusquedaInmuebleViewController * busquedaInmuVC = [[RMBusquedaInmuebleViewController alloc]initWithCase:indexPath.row];
        [self.navigationController pushViewController:busquedaInmuVC animated:YES];
    }else if (!self.bienes){
        RMInmuebleArriendoViewController * inmuebleVC = [[RMInmuebleArriendoViewController alloc] initWithInmueble:[self.inmuebles objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:inmuebleVC animated:YES];
    }else{
        RMBienEnVentaViewController * bienVC = [[RMBienEnVentaViewController alloc] initWithBienVenta:[self.bienes objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:bienVC animated:YES];
    }
    
    
}

@end
