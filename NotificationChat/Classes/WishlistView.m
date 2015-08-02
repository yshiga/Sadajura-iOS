//
//  WishlistView.m
//  app
//
//  Created by shiga yuichi on 2015/08/02.
//  Copyright (c) 2015年 KZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WishlistView.h"
#import "UIColor+JSQMessages.h"


@interface WishlistView()


@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation WishlistView



/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_people"]];
		self.tabBarItem.title = @"wishlist";
	}
	return self;
}
 */

-(id)init {
    self = [super init];
	if (self)
	{
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_people"]];
		self.tabBarItem.title = @"wishlist";
	}
	return self;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
	self.title = @"Wishlist";
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
//	self.tableView.tableHeaderView = viewHeader;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 5;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
    
    NSString* name;
    if(indexPath.row == 0) {
        name = @"Legacy Khaki - Pleated $25";
    } else if(indexPath.row == 1) {
        name = @"Women's Air Max 360 $10";
    } else if(indexPath.row == 2) {
        name = @"Hampton Big Pony Shirt $20";
    } else if(indexPath.row == 3) {
        name = @"Big Pony Skinny Polo";
    } else if(indexPath.row == 4) {
        name = @"Birthday Party Supplies";
    } else if(indexPath.row == 5) {
        name = @"Collection Legacy Khaki";
    }
    
    
    [title setNumberOfLines:2];
    [title setText:name];
    [title setFont:[UIFont systemFontOfSize:18]];
    [title setTextColor:[UIColor blackColor]];
    [cell.contentView addSubview:title];
    
    NSString* imgName;
    if(indexPath.row == 0) {
        imgName = @"legackhaki.jpeg";
    } else if(indexPath.row == 1) {
        imgName = @"hampton.jpeg";
    } else if(indexPath.row == 2) {
        imgName = @"airmax.jpeg";
    } else if(indexPath.row == 3) {
        imgName = @"legackhaki.jpeg";
    } else if(indexPath.row == 4) {
        imgName = @"birthdays.jpeg";
    } else if(indexPath.row == 5) {
        imgName = @"airmax.jpeg";
    }
    
    
    
    UIImage *image = [UIImage imageNamed:imgName];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(20, 0, 44, 44);
    imageView.image = image;
    
    [cell.contentView addSubview:imageView];
    
    UISwitch *check = [[UISwitch alloc] initWithFrame:CGRectMake(260, 5, 40, 40)];
    [check addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventTouchUpInside];
    
    check.tag = indexPath.row;
    
    [cell.contentView addSubview:check];
    
	return cell;
}

- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    
    
    
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end