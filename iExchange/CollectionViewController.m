//
//  CollectionViewController.m
//  iExchange
//
//  Created by JIN on 15/6/4.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "CurrencyExchange.h"

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController {
    NSArray *_localeIdentifiers;
    NSMutableArray *_currencyExchangeArray;
    BOOL _isLoading;
    NSOperationQueue *_queue;
    NSDecimalNumber *_cnyAmount;
    NSDecimalNumber *_multiplier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _multiplier = [[NSDecimalNumber alloc] initWithDouble:0.01];
    
    //registe collectionViewCell Nib
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self configureForLocaleIdentifiers];
    
    [self configureForCurrencyExchangeArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PassAmountNotification:) name:@"PassAmountNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)configureForLocaleIdentifiers {
    _localeIdentifiers = [NSArray arrayWithObjects:@"zn_CH", @"es_US", @"fr_FR", @"en_HK", @"ja_JP", @"en_GB", @"en_AU", @"en_CA", @"th_TH", @"en_SG", @"nb_NO", @"ms_Latn_MY", @"en_MO", @"ko_KR", @"en_CH", @"da_DK", @"sv_SE", @"ru_RU", @"en_NZ", @"en_PH", @"zh_Hant_TW", nil];
    _cnyAmount = [[NSDecimalNumber alloc] initWithInt:1000];
}

- (void)configureForCurrencyExchangeArray {
    //let the spinner start to spin
    _isLoading = YES;
    [self configureForSpinner];
    
    _currencyExchangeArray = [NSMutableArray arrayWithCapacity:[_localeIdentifiers count]];
    
    CurrencyExchange *cny = [[CurrencyExchange alloc] init];
    cny.currencyName = @"人民币";
    cny.currencyCode = @"CNY";
    cny.localeCurrencyCode = cny.currencyCode;
    NSLog(@"%@",cny.currencyCode);
    cny.exchangeRate = [[NSDecimalNumber alloc] initWithDouble:1.0];
    NSLog(@"%@",cny.exchangeRate);
        
    [_currencyExchangeArray addObject:cny];
    NSURL *url = [NSURL URLWithString:@"http://stock.finance.sina.com.cn/forex/api/openapi.php/ForexService.getAllBankForex" ];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parseDictionary:responseObject];
        [_collectionView reloadData];
        _isLoading = NO;
        [self configureForSpinner];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.cancelled) {
            return;
        }
        [self showNetworkError];
        _isLoading = NO;
        [self configureForSpinner];
    }];
    
    [_queue addOperation:operation];
    
//    if (_currencyExchangeArray == nil) {
//        _currencyExchangeArray = [[NSMutableArray alloc] init];
//        for (NSString *identifier in _localeIdentifiers) {
//            NSLocale *locale = [NSLocale localeWithLocaleIdentifier:identifier];
//            CurrencyExchange *currencyExchange = [[CurrencyExchange alloc] init];
//            currencyExchange.localeCurrencyCode = @"CNY";
//            currencyExchange.currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
//        }
//    }
}

#pragma parse dictionary

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *bocArray = dictionary[@"result"][@"data"][@"boc"];
    if (bocArray == nil) {
        NSLog(@" Failed to update Currency Exchange information");
        return;
    }
    for (NSDictionary *currencyDict in bocArray) {
        CurrencyExchange *currencyExchange = [[CurrencyExchange alloc] init];
        NSLog(@"code before parse %@", currencyExchange.exchangeRate);
        
        currencyExchange.currencyCode = currencyDict[@"symbol"];
        if (currencyExchange.currencyCode.length == 0) {
            NSLog(@"Fail to get currency code");
            continue;
        }
        
        currencyExchange.currencyName = currencyDict[@"name"];
        if (currencyExchange.currencyName.length == 0) {
            NSLog(@"Fail to get currency name");
            continue;
        }
        if ([currencyDict[@"xc_buy"] isKindOfClass:[NSString class]]) {
            currencyExchange.exchangeRate = [[NSDecimalNumber alloc] initWithString:currencyDict[@"xc_buy"]];
        } else {
            if ([currencyDict[@"mid"] isKindOfClass:[NSString class]]) {
                currencyExchange.exchangeRate = [[NSDecimalNumber alloc] initWithString:currencyDict[@"mid"]];
            } else {
                NSLog(@"Fail to get exchange rate");
                continue;
            }
        }
        
        currencyExchange.exchangeRate = [currencyExchange.exchangeRate decimalNumberByMultiplyingBy:_multiplier];
        NSLog(@"code after parse %@", currencyExchange.exchangeRate);
        if (currencyExchange != nil) {
            [_currencyExchangeArray addObject:currencyExchange];
        }
    }
    
    NSLog(@"%lu", (unsigned long)[_currencyExchangeArray count]);
}

#pragma collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"items: %lu",(unsigned long)[_currencyExchangeArray count]);
    NSLog(@"current thread in numberof: %@", [NSThread currentThread]);
    return [_currencyExchangeArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.width/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    CurrencyExchange *ce = [_currencyExchangeArray objectAtIndex:indexPath.row];
    [cell configureForCell:ce cnyAmount:_cnyAmount];
    return cell;
}

#pragma spinner

- (void)configureForSpinner {
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[self.view viewWithTag:100];
    spinner.hidesWhenStopped = true;
    if (_isLoading) {
        [spinner startAnimating];
        NSLog(@"start animating");
    } else {
        [spinner stopAnimating];
        NSLog(@"stop animating");
    }
}

#pragma show errors

- (void)showNetworkError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"parse json failded" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

#pragma NotificationCenter for accepting amount

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)PassAmountNotification: (NSNotification*)notification {
    NSLog(@"current thread in vc's notification: %@", [NSThread currentThread]);
    NSDictionary *amountDic = [notification userInfo];
    NSLog(@"amount in view controller: %@", [amountDic objectForKey:@"amount"]);
    _cnyAmount = [[NSDecimalNumber alloc] initWithString:[amountDic objectForKey:@"amount"]];
    NSLog(@"cny: %@", _cnyAmount);
    [_collectionView reloadData];
    NSLog(@"after reloaddata");
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
