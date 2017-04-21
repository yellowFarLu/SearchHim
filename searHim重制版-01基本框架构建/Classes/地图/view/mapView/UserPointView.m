//
//  UserPointView.m
//  JLUFind
//
//  Created by DymondKEN on 2016/03/19.
//  Copyright © 2016年 Yakoresya. All rights reserved.
//

#import "UserPointView.h"

@implementation UserPointView

- (void)setImage:(UIImage *)image
{
    self.portView.image = image;
}

-(void)initSubView{
    //add picture
    self.portView =[[UIImageView alloc]initWithFrame:CGRectMake(portMargin, portMargin,portWidth, portHeight)];
    self.portView.backgroundColor = [UIColor whiteColor];
}



@end
