//
//  V2EXNodesListModel.h
//  V2EX
//
//  Created by WildCat on 2/14/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "V2EXRequestDataDelegate.h"

@interface V2EXNodesListModel : NSObject <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_data;
    FMDatabase *_db;
}

@property(nonatomic, assign) id<V2EXRequestDataDelegate> delegate;

- (id)initWithIndex:(NSUInteger)index;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
