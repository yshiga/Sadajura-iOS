//
//  MyChatView.h
//  app
//
//  Created by shiga yuichi on 2015/08/01.
//  Copyright (c) 2015年 KZ. All rights reserved.
//

#import "JSQMessages.h"

#ifndef app_MyChatView_h
#define app_MyChatView_h

@interface MyChatView: JSQMessagesViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

- (id)initWith:(NSString *)recipient_;

@end
#endif
