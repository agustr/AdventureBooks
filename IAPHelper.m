//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

// 3
@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    DownloadProgressHandler _downloadHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
    
}

- (void)setDownloadProgressHandler:(DownloadProgressHandler)downloadHandler{
    _downloadHandler = [downloadHandler copy];
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    if (transaction.downloads.count > 0) {
        NSLog(@"Adding downloads to Queue...");
        [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
    }
    else{
        NSLog(@"Completing transaction...");
        [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    [self completeTransaction:transaction];
    /*[self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
     */
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [[[UIAlertView alloc] initWithTitle:@"Transaction Error" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    NSLog(@"providing switch for productIdentifier %@...", productIdentifier);
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    for (SKDownload *download in downloads)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:download.transaction.payment.productIdentifier object:download];
        switch (download.downloadState)
        {
            
            case SKDownloadStateActive:
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"UpdateDownload"
                 object:download];
#ifdef DEBUG
                NSLog(@"%f", download.progress);  //float
                NSLog(@"%f remaining", download.timeRemaining); //nstimeiterval
                NSLog(@"product id: %@", download.transaction.payment.productIdentifier);  //nsstring
#endif

                
                if (_downloadHandler!=nil)
                {
                    _downloadHandler(download.progress, download.timeRemaining, download.transaction.payment.productIdentifier);
                }
                
                //SHOW THE PROGRESS OF THE DOWNLOAD.
                //if (download.progress == 0.0 && !_progress)
                break;
            }
                
            case SKDownloadStateCancelled: { break; }
            case SKDownloadStateFailed:
            {
                /*
                [Utility showAlert:@"Download Failed"
                           message:@"Failed to download. Please retry later"
                       cancelTitle:@"OK"
                        otherTitle:nil
                          delegate:nil];
                 */
                break;
            }
                
            case SKDownloadStateFinished:
            {
                NSError *err;
                NSFileManager *fm = [NSFileManager defaultManager];
                
                NSLog(@"this is the url to the downloaded content: %@", download.contentURL.relativePath);
                
                NSURL *contentsUrl = [download.contentURL URLByAppendingPathComponent:@"Contents"];
                
                NSURL *libraryURL =[[fm URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask]objectAtIndex:0 ];
                
                NSURL *storiesURL = [libraryURL URLByAppendingPathComponent:@"stories"];
                
                NSArray *subpaths = [fm contentsOfDirectoryAtURL:contentsUrl
                                    includingPropertiesForKeys:nil
                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                    error:&err];
                if (subpaths.count ==0) {
                    return;
                }
                NSURL *receivedStoryUrl = [subpaths objectAtIndex:0];
                NSURL *destinationUrl = [storiesURL URLByAppendingPathComponent:receivedStoryUrl.lastPathComponent];
                
                NSLog(@"the receivedStoryURL:\n %@ \n\n",receivedStoryUrl.relativePath);
                NSLog(@"the storiesURL is:\n %@ \n\n", storiesURL.relativePath);
                NSLog(@"the destinationURL is:\n %@ \n\n", destinationUrl.relativePath);
                BOOL isDir;
                if (![fm fileExistsAtPath:storiesURL.path isDirectory:&isDir]) {
                    NSError* err;
                    NSLog(@"the stories url does not exist");
                    [fm createDirectoryAtURL:storiesURL withIntermediateDirectories:YES attributes:nil error:&err];
                }
                
                if ([fm removeItemAtURL:destinationUrl error:&err]) {
                    NSLog(@"deleing the folder before copying to it!");
                }
                
                if ([fm moveItemAtURL:receivedStoryUrl
                                toURL:destinationUrl error:&err]) {
                    NSLog(@"the contents has been copied");
                    [self provideContentForProductIdentifier:download.transaction.payment.productIdentifier];
                    [[SKPaymentQueue defaultQueue] finishTransaction:download.transaction];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadFinished" object:nil];
                    return;
                } else {
                    NSLog(@"the contents could not be copied %@",err);
                }
                
                [self provideContentForProductIdentifier:download.transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:download.transaction];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadFinished" object:nil];
                break;
            }
                
            case SKDownloadStatePaused:
            {
#ifdef DEBUG
                NSLog(@"SKDownloadStatePaused");
#endif
                break;
            }
                
            case SKDownloadStateWaiting:
            {
#ifdef DEBUG
                NSLog(@"SKDownloadStateWaiting");
#endif
                break;
            }
        }
    }
}

@end