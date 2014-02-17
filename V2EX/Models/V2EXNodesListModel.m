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
        _data = [array objectAtIndex:idx];
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"db/v2ex_normal.db"];
        _db = [FMDatabase databaseWithPath:dbPath];
        [_db open];
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
    return [_data count];
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
    NSString *uri = [_data objectAtIndex:index];
    
    FMResultSet *retSet = [_db executeQuery:@"SELECT * FROM nodes WHERE uri = ?",uri];
    [retSet next];
    
    cell.nodeTitle.text = [retSet stringForColumn:@"title"];
    cell.nodeHeader.text = [retSet stringForColumn:@"header"];
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
