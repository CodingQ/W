//
//  RunUserTableViewCell.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "WUserTableViewCell.h"

@implementation WUserTableViewCell

+ (instancetype)cellWith:(UITableView *)tableView identifity:(NSString *)identifity {
    NSInteger index = 0;
    
    if ([identifity isEqualToString:@"WUserHeadCell"]) {
        index = 0;
    } else if ([identifity isEqualToString:@"WUserNameCell"]) {
        index = 1;
    } else if ([identifity isEqualToString:@"WUserNormalCell"]) {
        index = 2;
    }
    
    WUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WUserTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    return cell;
}



@end
