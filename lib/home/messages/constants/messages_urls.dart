import 'package:job_me/_shared/api/constants/base_url.dart';

class ChatsUrls {
  static String numberOfNewMessages(){
    return "${BaseUrls.baseUrl()}/newNotAndMsg";
  }

  static String fetchChatUrl(){
    return "${BaseUrls.baseUrl()}/messages";
  }

  static String sendMessageUrl(){
    return "${BaseUrls.baseUrl()}/messages";
  }

  static String makeChatSeenUrl(){
    return "${BaseUrls.baseUrl()}/messageSeen";
  }

  static String getChatRoomMessages(int adId,int senderId,int currentPage){
    return "${BaseUrls.baseUrl()}/messages/$senderId?adsId=$adId&skip=${currentPage * 20}&take=20";
  }

}
