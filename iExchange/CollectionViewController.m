//
//  CollectionViewController.m
//  iExchange
//
//  Created by JIN on 15/6/4.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController {
    NSArray *_localeIdentifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self configureForLocaleIdentifiers];
    
    NSArray *array = [NSLocale availableLocaleIdentifiers];
    for (NSString *str in array) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:str];
        NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
        for (NSString *cc in _localeIdentifiers) {
            if ([code isEqualToString:cc]) {
                //NSString *symbol = [locale objectForKey:NSLocaleCurrencySymbol];
                NSLog(@"identifier for %@ : %@", cc, str);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma initialization

- (void)configureForLocaleIdentifiers {
    _localeIdentifiers = [NSArray arrayWithObjects:@"USD", @"EUR", @"HKD", @"JPY", @"GBP", @"AUD", @"CAD", @"THB", @"SGD", @"NOK", @"MYR", @"MOP", @"KRW", @"CHF", @"DKK", @"SEK", @"RUB", @"NZD", @"PHP", @"TWD", nil];
}


#pragma collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.width/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
