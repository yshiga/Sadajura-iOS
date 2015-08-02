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
    self.senderId = [PFUser currentUser][PF_USER_FULLNAME];
    self.senderDisplayName = [PFUser currentUser][PF_USER_FULLNAME];
    
    // ② MessageBubble (背景の吹き出し) を設定
    JSQMessagesBubbleImageFactory *bubbleFactory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubble = [bubbleFactory  incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubble = [bubbleFactory  outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    // ③ アバター画像を設定
//    self.incomingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User2"] diameter:64];
 //   self.outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User1"] diameter:64];
    // ④ メッセージデータの配列を初期化
    self.messages = [NSMutableArray array];
    
    
        PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME];
    
    
    
		[query orderByDescending:PF_MESSAGE_CREATEDAT];
		[query setLimit:50];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
		{
			if (error == nil)
			{
                
                for (PFObject *object in [objects reverseObjectEnumerator])
				{
                    
                    NSString* senderId = object[PF_MESSAGE_SENDER];
                    NSString* senderDisplayName = object[PF_MESSAGE_SENDER];
                    NSString* text = object[PF_MESSAGE_TEXT];
                
                    // 新しいメッセージデータを追加する
                    JSQMessage *message = [JSQMessage messageWithSenderId:senderId
                                                  displayName:senderDisplayName
                                                         text:text];
                    [self.messages addObject:message];
                    // メッセージの送信処理を完了する (画面上にメッセージが表示される)
                    [self finishSendingMessageAnimated:YES];
                }
                
			}
            else {
                
            }
		}];
    
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
    object[PF_MESSAGE_SENDER] = [PFUser currentUser][PF_USER_FULLNAME];
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

#pragma mark - Auto Message

// ⑥ 返信メッセージを受信する (自動)
- (void)receiveAutoMessage
{
    // 1秒後にメッセージを受信する
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(didFinishMessageTimer:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didFinishMessageTimer:(NSTimer*)timer
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:@"user2"
                                              displayName:@"underscore"
                                                     text:@"Hello"];
    [self.messages addObject:message];
    // メッセージの受信処理を完了する (画面上にメッセージが表示される)
    [self finishReceivingMessageAnimated:YES];
}

@end