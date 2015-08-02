//
//  MyChatView.m
//  app
//
//  Created by shiga yuichi on 2015/08/01.
//  Copyright (c) 2015年 KZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AppConstant.h"
#import "MyChatView.h"

@interface MyChatView()
{
    NSString *recipient;
    NSTimer *timer;
}

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubble;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubble;
@property (strong, nonatomic) JSQMessagesAvatarImage *incomingAvatar;
@property (strong, nonatomic) JSQMessagesAvatarImage *outgoingAvatar;

@end

@implementation MyChatView

- (id)initWith:(NSString *)recipient_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
    recipient = recipient_;
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ① 自分の senderId, senderDisplayName を設定
    self.senderId = [PFUser currentUser][PF_USER_USERNAME];
    self.senderDisplayName = [PFUser currentUser][PF_USER_USERNAME];
    
    // ② MessageBubble (背景の吹き出し) を設定
    JSQMessagesBubbleImageFactory *bubbleFactory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubble = [bubbleFactory  incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubble = [bubbleFactory  outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    // ③ アバター画像を設定
//    self.incomingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User2"] diameter:64];
 //   self.outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User1"] diameter:64];
    // ④ メッセージデータの配列を初期化
    self.messages = [NSMutableArray array];
    
    [self loadMessages];
}

- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    [self showActionSheet];
    
}

- (void)takePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    PFFile* filePicture = [PFFile fileWithName:@"ios_iamge.png" data:UIImageJPEGRepresentation(chosenImage, 0.6)];
    
    
    PFObject *object = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
    object[PF_MESSAGE_SENDER] = [PFUser currentUser][PF_USER_USERNAME];
	object[PF_MESSAGE_RECIPIENT] = recipient;
    object[PF_MESSAGE_PHOTO] = filePicture;
 	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error == nil)
		{
			[JSQSystemSoundPlayer jsq_playMessageSentSound];
		}
        else {
            
        }
	}];
    
    JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:chosenImage ];
    
    Boolean isOutgoing = YES;
    mediaItem.appliesMediaViewMaskAsOutgoing = isOutgoing;
    
    JSQMessage *message;
    message = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:self.senderId date:[NSDate date] media:mediaItem];
    [self.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];   
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)loadMessages {
    
    NSString* whereFormat = @"sender == '%@' AND receiver == '%@' OR sender == '%@' AND receiver == '%@'";
    NSString* username = [PFUser currentUser][PF_USER_USERNAME];
    NSString* where = [[NSString alloc]initWithFormat:whereFormat, recipient,username,username,recipient];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:where];

    PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME predicate:predicate];
    
		[query orderByDescending:PF_MESSAGE_CREATEDAT];
		[query setLimit:50];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
		{
			if (error == nil)
			{
                
                self.messages = [NSMutableArray array];
                for (PFObject *object in [objects reverseObjectEnumerator])
				{
                    
                    
                    PFFile *filePicture = object[PF_MESSAGE_PHOTO];
                    JSQMessage *message;
                    NSString* senderId = object[PF_MESSAGE_SENDER];
                    NSString* senderDisplayName = object[PF_MESSAGE_SENDER];
                    
                    if(filePicture == nil) {
                        
                        // text

                        NSString* text = object[PF_MESSAGE_TEXT];
                        message = [JSQMessage messageWithSenderId:senderId
                                                      displayName:senderDisplayName
                                                             text:text];
                        // image
                    }else {
                        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
                            Boolean isOutgoing = [self.senderId isEqualToString:senderId];
                            mediaItem.appliesMediaViewMaskAsOutgoing = isOutgoing;
                        
                            message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:[NSDate date] media:mediaItem];
                        //-----------------------------------------------------------------------------------------------------------------------------------------
                            [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
                             {
                                 if (error == nil)
                                 {
                                     mediaItem.image = [UIImage imageWithData:imageData];
                                     [self.collectionView reloadData];
                                 }
                         }];
                                    
                    }
                    
                    
                    
                    [self.messages addObject:message];
                    // メッセージの送信処理を完了する (画面上にメッセージが表示される)
                    [self finishSendingMessageAnimated:YES];
                }
                
			}
            else {
                
            }
		}];
    
}



- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}
#pragma mark - JSQMessagesViewController


// ⑤ Sendボタンが押下されたときに呼ばれる
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId
                                              displayName:senderDisplayName
                                                     text:text];
    [self.messages addObject:message];
    // メッセージの送信処理を完了する (画面上にメッセージが表示される)
    
    
    PFObject *object = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
    object[PF_MESSAGE_SENDER] = [PFUser currentUser][PF_USER_USERNAME];
	object[PF_MESSAGE_RECIPIENT] = recipient;
	object[PF_MESSAGE_TEXT] = text;

	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error == nil)
		{
			[JSQSystemSoundPlayer jsq_playMessageSentSound];
		}
        else {
            
        }
	}];
    
    [self finishSendingMessageAnimated:YES];
    
}

#pragma mark - JSQMessagesCollectionViewDataSource

// ④ アイテムごとに参照するメッセージデータを返す
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

// ② アイテムごとの MessageBubble (背景) を返す
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubble;
    }
    return self.incomingBubble;
}

// ③ アイテムごとのアバター画像を返す
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingAvatar;
    }
    return self.incomingAvatar;
}

#pragma mark - UICollectionViewDataSource

// ④ アイテムの総数を返す
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}


-(void)showActionSheet {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Send Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Gallery" otherButtonTitles:@"Take Photo", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    /**
     * OR use the following switch statement
     * Suggested by Colin =)
     */
     switch (buttonIndex) {
     case 0:
             [self selectPhoto];
     break;
     case 1:
             [self takePhoto];
     break;
     }
}


@end