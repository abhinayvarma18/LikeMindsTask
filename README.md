# LikeMindsTask

## About App
App provides a medium to 2 users to chat one on one. User needs to signin from their mobile number using OTP. Once they are signed in they can see the available users signedup on the app and provides a reactive way to initiate one on one chat between them. There are 6 screens in the app namely -:
i) Welcome Screen
ii) Login Screen
iii) OTP Screen
iv) Profile Updation Screen
v) Chat Listing Screen
vi) ChatRoom Screen
vii) CreateAChatroom Screen

## Firebase Database Structure
```
{
  "ChatRooms" : {
    "sampleChatRoom" : {
      "lastMessageBody" : "hi there",
      "lastMessageTimeStamp" : "213431123"
    }
  },
  "Messages" : {
    "sampleM" : {
      "sample" : {
        "body" : "sdasda",
        "sentBy" : "userId",
        "timeStamp" : 312323231
      }
    }
  },
  "Users" : {
    "sampleU" : {
      "imageUrl" : "asd",
      "name" : "qweweq"
    }
  },
  "UsersChatRooms" : {
    "sampleUChat" : {
      "xuwq123jsad1" : {
        "senderImage" : "qwe",
        "senderName" : "xyz"
      },
      "xuwq123jsad2" : {
        "senderImage" : "qwe",
        "senderName" : "qas"
      }
    }
  }
}

```
**Users** This node stores the user information like its username and userimage.

**UserChatRooms** This node stores the chatrooms available for a specific user.

**ChatRooms** This node stores the lastMessage information of a chatroom.

**Messages** This node stores the messages in a specific chatroom.

## AppFlow
- On Sign-In by phone for the first time user is been taken to the profile updation screen to input their name(mandatory) + image(optional) which is been saved in the *Users* node with the mobilenumber as the unique ID key.

- On Second time signin the profile screen is skipped and is been taken to the chatroom listing screen directly.

- A chatroom is created on sending the first message to a specific user. While creating a chatroom we create a unique child key (termed as chatroom ID) in the node under ''UsersChatrooms->userId->'' and then save the receptines information under the same node.  This ChatroomId is been user further in addition to create node in ChatRooms -> chatroomID and Messages -> chatroomId.

- Chatroom Listing Screen -> here we setup a child added listener under the node UserChatrooms->UserId to populate existing chatrooms for the user or if there is any new chatroom which gets created . For the specific chatroom we setup a valuechange listner under the node Chatrooms->chatroomID to get to know any new message to be displayed in the chatlisting Page.
After both the calls of chatroom info and chatroom message info the data is been saved locally using CoreDatabase and is been populated using the same models.

- Chatroom Screen -> A chatroom is created from here while sending the first message . Post Creation of chatroom or for an existing chatroom , a child added listner is been added under the node Messages->chatroomID to populate all the messages correspondant to the specific chatroom. These messages are stored locally in the app using coredata which is been used to populate the UI further. 


## ProjectFilesStructure
  #### ``MainFiles``
   i) AppDelegate  ii) SceneDelegate -> deciding where to go if user is logged in.  iii) Main.storyboard -> containing the entire UI of the application.
   #### ``Views`` 
  this contains the tableviewcell components used to display chatrooms , contacts and messages .
  #### ``ViewControllers``
  Contains the 7 screens used in the application providing datasource to the UI and mediating the business logic between UI and separate layers.
  #### ``HelperFiles``
  contains hardcoded strings , extensions and reused UI components.
  #### ``Singletons`` 
  contains 3 core files of the project handling -:
    - Authentication and User 
    - ChatManager
    - LocalDB Manager
  #### ``Resources`` 
  contains images and coredata file.
  

## Frameworks Used
``SDWebImage -> for caching the images``

`` FirebaseAuth -> for authenticating user via phonenumber``

``FirebaseDatabase -> for using realtime database to implement reactive chatting experience``

``FirebaseStorage -> To upload the user profile image on cloud``

``IQKeyboardManager and UnderLineTextField -> For keyboardhandling of textfields``






