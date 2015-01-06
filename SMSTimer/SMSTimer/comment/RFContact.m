//
//  RFContact.m
//  CalendarSDK
//
//  Created by chengenlin on 1/6/14.
//  Copyright (c) 2014 richinfo. All rights reserved.
//

#import "RFContact.h"

@implementation RFContact

@synthesize sortLetter,nameFirst,nameLast,company,displayName,phoneArray,emailArray;

-(id) init
{
	if ((self = [super init]))
    {
        self.sortLetter = @"";
        self.nameFirst = @"";
        self.nameLast = @"";
        self.company = @"";
        self.displayName = @"";
        phoneArray = [[NSMutableArray alloc] init];
        emailArray = [[NSMutableArray alloc] init];
    }
	return self;
}

-(void)setSortLetter{
    if ([self.nameFirst isEqualToString:@""]) {
		
        if ([self.nameLast isEqualToString:@""]) {
            if ([self.company isEqualToString:@""]) {
                self.sortLetter=@"#";
            }
			else{
                self.sortLetter = [[RFUtility GetThePinYinString:self.company] substringToIndex:1];
            }
        }
		else{
            self.sortLetter = [[RFUtility GetThePinYinString:self.nameLast] substringToIndex:1];
        }
    }
	else{
        self.sortLetter = [[RFUtility GetThePinYinString:self.nameFirst] substringToIndex:1];
    }
}

-(void)setDisplayName{
    if ([self.nameFirst isEqualToString:@""]) {
        if ([self.nameLast isEqualToString:@""]) {
            if ([self.company isEqualToString:@""]) {
                if ([self.phoneArray count]==0) {
                    if([self.emailArray count]==0){
                        self.displayName=@"";
                    }else{
                        self.displayName=[self.emailArray objectAtIndex:0];
                    }
                }else{
                    self.displayName=[self.phoneArray objectAtIndex:0];
                }
            }else{
                self.displayName=self.company;
            }
        }else{
            self.displayName=self.nameLast;
        }
    }else{
        if (![self.nameLast isEqualToString:@""]) {
            self.displayName=[NSString stringWithFormat:@"%@ %@",self.nameFirst,self.nameLast];
        }else{
            self.displayName=self.nameFirst;
        }
    }
}
@end
