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
	return 3;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 190, 44)];
    [title setText:@"test"];
    [title setFont:[UIFont systemFontOfSize:25]];
    [title setTextColor:[UIColor blackColor]];
    [cell.contentView addSubview:title];
    
    
    UIImage *image = [UIImage imageNamed:@"tab_people"];
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