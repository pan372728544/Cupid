//
//  HomeFlowLayout.m
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeFlowLayout.h"

@implementation HomeFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.minimumInteritemSpacing = 0;
    
    self.minimumLineSpacing = 0;
    
    if (self.collectionView.bounds.size.height) {
        
        self.itemSize = self.collectionView.bounds.size;
    }
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


@end
