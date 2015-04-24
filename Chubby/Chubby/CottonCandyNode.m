//
//  CottonCandyNode.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 24/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "CottonCandyNode.h"

@implementation CottonCandyNode



-(id)initWithPosition: (CGPoint)position{
    
    CottonCandyNode *_cottonCandy;
    
    _cottonCandy = [CottonCandyNode spriteNodeWithImageNamed:@"Candy"];
    _cottonCandy.position = position;
    
    return _cottonCandy;
    
}
@end
