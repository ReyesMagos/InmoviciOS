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

@interface RMBienEnVentaViewController ()

@property (nonatomic, strong) RMBienVenta * bienVenta;

@end

@implementation RMBienEnVentaViewController

-(id)initWithBienVenta:(RMBienVenta *)aBienV{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _bienVenta = aBienV;
        self.title = @"Bien en Venta";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setUserInteractionEnabled:YES];
    self.splitViewFotos.delegate = self;
    self.splitViewFotos.scrollEnabled = YES;
    self.splitViewFotos.contentSize = CGSizeMake(120,80);
    self.descripcionTxtV.text = self.bienVenta.descripcion;
    
    //Agrego un reconocedor al scroll para detectar cuando le han dado touch
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.splitViewFotos addGestureRecognizer:singleTap];
    
    [self consumeImages];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.splitViewFotos];
    for(int index=0;index<[self.bienVenta.fotos count];index++)
    {
        UIImageView *imgView = [self.bienVenta.fotos objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], touchPoint))
        {
            self.imageViewGrande.image = imgView.image;
            break;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.imageViewGrande.image = [(UIImageView*)[self.bienVenta.fotos objectAtIndex:0] image];
    //[self consumeImages];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [[event allTouches] anyObject];
    for(int index=0;index<[self.bienVenta.fotos count];index++)
    {
        UIImageView *imgView = [self.bienVenta.fotos objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], [touch locationInView:self.splitViewFotos]))
        {
            self.imageViewGrande.image = imgView.image;
            break;
        }
    }

}




-(void)consumeImages{
    int xOffset = 0;
    int scrollWidth = 120;
    self.splitViewFotos.contentSize = CGSizeMake(scrollWidth,80);
    for (int i = 0; i < [self.bienVenta.linksfotos count]; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] init];
        imageView.frame = CGRectMake(5+xOffset, 10, 320, 200);
        
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        
        //load the image
        imageView.imageURL = [self.bienVenta.linksfotos objectAtIndex:i];
        [self.bienVenta.fotos addObject:imageView];
        self.splitViewFotos.contentSize = CGSizeMake(scrollWidth+xOffset,110);
        [self.splitViewFotos addSubview:imageView];
        
        xOffset += 350;
        
    }
    self.splitViewFotos.contentSize = CGSizeMake(self.splitViewFotos.contentSize.width + 205,110);
    //self.imageViewGrande.image = [(UIImageView*)[self.bienVenta.fotos objectAtIndex: 0] image];
    xOffset += 350;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
