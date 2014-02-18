//
//  V2EXNodesListModel.m
//  V2EX
//
//  Created by WildCat on 2/14/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNodesListModel.h"
#import "V2EXNodesListCell.h"

@implementation V2EXNodesListModel

- (id)initWithIndex:(NSUInteger)idx {

    if ([super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NodesList" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
        _nodeURIs = [array objectAtIndex:idx];
        
        _nodeTitles = [[NSMutableArray alloc] init];
        _nodeHeaders = [[NSMutableArray alloc] init];
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"db/v2ex_normal.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        
        [db open];
        for (NSString *nodeURI in _nodeURIs) {
            FMResultSet *retSet = [db executeQuery:@"SELECT * FROM nodes WHERE uri = ?",nodeURI];
            [retSet next];
            NSString *title = [retSet stringForColumn:@"title"];
            NSString *header = [retSet stringForColumn:@"header"];
            [_nodeTitles addObject:title];
            if (header) {
                [_nodeHeaders addObject:header];
            } else {
                [_nodeHeaders addObject:@""];
            }
        }
        [db close];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nodeTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"nodesListCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    } else {
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
//        }
//    }
    
    UINib *nib = [UINib nibWithNibName:@"V2EXNodesListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    V2EXNodesListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self.delegate;

    NSUInteger index = [indexPath row];
    NSString *uri = [_nodeURIs objectAtIndex:index];
    
    cell.nodeTitle.text = [_nodeTitles objectAtIndex:index];
    cell.nodeHeader.text = [_nodeHeaders objectAtIndex:index];
    cell.nodeURI = uri;
    
    return cell;
}

#pragma mark - UITableViewDelegate
// TODO: Find the better scheme for page view because this method don't working while UITableView in UISrollView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    NSLog(@"%i",index);
}

@end
