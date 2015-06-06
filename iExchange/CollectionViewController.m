//
//  CollectionViewController.m
//  iExchange
//
//  Created by JIN on 15/6/4.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "CurrencyExchange.h"

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController {
    NSArray *_localeIdentifiers;
    NSMutableArray *_currencyExchangeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //registe collectionViewCell Nib
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self configureForLocaleIdentifiers];
    
    [self configureForCurrencyExchangeArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma initialization

- (void)configureForLocaleIdentifiers {
    _localeIdentifiers = [NSArray arrayWithObjects:@"es_US", @"fr_FR", @"en_HK", @"ja_JP", @"en_GB", @"en_AU", @"en_CA", @"th_TH", @"en_SG", @"nb_NO", @"ms_Latn_MY", @"en_MO", @"ko_KR", @"en_CH", @"da_DK", @"sv_SE", @"ru_RU", @"en_NZ", @"en_PH", @"zh_Hant_TW", nil];
}

- (void)configureForCurrencyExchangeArray {
    if (_currencyExchangeArray == nil) {
        _currencyExchangeArray = [[NSMutableArray alloc] init];
        for (NSString *identifier in _localeIdentifiers) {
            NSLocale *locale = [NSLocale localeWithLocaleIdentifier:identifier];
            CurrencyExchange *currencyExchange = [[CurrencyExchange alloc] init];
            currencyExchange.localeCurrencyCode = @"CNY";
            currencyExchange.currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
        }
    }
}

#pragma currency exchange dictionary

- (NSDictionary)currencyExchangeDictionary {
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://stock.finance.sina.com.cn/forex/api/openapi.php/ForexService.getAllBankForex"]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *bocCurrencyExchangeDictionary = [[[jsonDictionary objectForKey:@"results"] objectForKey:@"data"] objectForKey:@"boc"];
}

#pragma collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_localeIdentifiers count];
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
