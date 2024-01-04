import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/block_report/blocked_accounts_model.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/common_models/avatar_urls.dart';
import 'package:socialv/models/common_models/common_message_response.dart';
import 'package:socialv/models/common_models/coverimage_response.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/models/delete_avatar_response.dart';
import 'package:socialv/models/delete_cover_image_response.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/models/forums/forum_detail_model.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/subsription_list_model.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/models/groups/accept_group_request_model.dart';
import 'package:socialv/models/groups/delete_group_response.dart';
import 'package:socialv/models/groups/group_membership_requests_model.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/models/groups/group_request_model.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/groups/reject_group_invite_response.dart';
import 'package:socialv/models/groups/remove_group_member.dart';
import 'package:socialv/models/login_response.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/models/members/friendship_response_model.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/models/members/member_model.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/models/members/profile_field_model.dart';
import 'package:socialv/models/members/profile_visibility_model.dart';
import 'package:socialv/models/members/remove_existing_friend.dart';
import 'package:socialv/models/posts/comment_model.dart';
import 'package:socialv/models/posts/get_post_likes_model.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/models/posts/post_in_list_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/models/register_user_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/utils/constants.dart';
import '../models/gallery/album_media_list_model.dart';
import '../models/gallery/albums.dart';
import '../models/gallery/media_active_statuses_model.dart';
import '../models/invitations/invite_list_model.dart';
import '../screens/auth/screens/sign_in_screen.dart';

bool get isTokenExpire =>
    JwtDecoder.isExpired(getStringAsync(SharePreferencesKey.TOKEN));

// region Auth
Future<RegisterUserModel> createUser(Map request) async {
  return RegisterUserModel.fromJson(await handleResponse(
      await buildHttpResponse(APIEndPoint.signup,
          request: request, method: HttpMethod.POST, isAuth: true)));
}

Future<LoginResponse> loginUser(
    {required Map request, required bool isSocialLogin}) async {
  LoginResponse response;
  if (isSocialLogin.validate()) {
    response = LoginResponse.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoint.socialLogin,
            request: request, method: HttpMethod.POST, isAuth: true)));
  } else {
    response = LoginResponse.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoint.login,
            request: request, method: HttpMethod.POST, isAuth: true)));
  }

  appStore.setToken(response.token.validate());
  appStore.setLoggedIn(true);

  appStore.setLoginName(response.userNicename.validate());
  appStore.setLoginFullName(response.userDisplayName.validate());
  appStore.setLoginEmail(response.userEmail.validate());
  return response;
}

Future<CommonMessageResponse> forgetPassword({required String email}) async {
  Map request = {"email": email};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.forgetPassword}',
        method: HttpMethod.POST,
        request: request,
        isAuth: true)),
  );
}

Future<void> logout(BuildContext context) async {
  appStore.setLoading(true);

  Map req = {
    "player_id": getStringAsync(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID),
    "add": 0
  };

  await setPlayerId(req).then((value) {
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    log("Player id error : ${e.toString()}");
  });
  await appStore.setToken('');
  await appStore.setNonce('');
  appStore.setLoginUserId('0');
  appStore.setLoginFullName('');
  appStore.setLoginAvatarUrl('');
  appStore.setVerificationStatus('');
  if (!appStore.doRemember) appStore.setLoginName('');
  appStore.recentMemberSearchList.clear();
  appStore.recentGroupsSearchList.clear();
  setValue(SharePreferencesKey.LMS_QUIZ_LIST, '');
  await appStore.setLoggedIn(false);
  finish(context);

  SignInScreen().launch(context,
      pageRouteAnimation: PageRouteAnimation.Scale, isNewTask: true);
}

Future<CommonMessageResponse> deleteAccount() async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse('${APIEndPoint.deleteAccount}',
          method: HttpMethod.DELETE),
    ),
  );
}

//endregion

//region Members

/// Members.

Future<MemberResponse> getLoginMember() async {
  return MemberResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.getMembers}/me')));
}

Future<List<MemberResponse>> getAllMembers(
    {int page = 1, String? searchText}) async {
  Iterable it = await handleResponse(
    await buildHttpResponse(
        '${APIEndPoint.getMembers}${searchText != null ? '?search=$searchText&' : '?'}page=$page&per_page=20&current_user=${appStore.loginUserId}'),
  );

  return it.map((e) => MemberResponse.fromJson(e)).toList();
}

Future<List<AvatarUrls>> getMemberAvatarImage({required int memberId}) async {
  Iterable it = await handleResponse(
    await buildHttpResponse('${APIEndPoint.getMembers}/$memberId/avatar'),
  );

  return it.map((e) => AvatarUrls.fromJson(e)).toList();
}

Future<List<MemberResponse>> getOnlineMembers() async {
  Iterable it = await handleResponse(
    await buildHttpResponse(
        '${APIEndPoint.getMembers}?type=${MemberType.online}&page=1&per_page=10&user_id=${appStore.loginUserId}'),
  );

  return it.map((e) => MemberResponse.fromJson(e)).toList();
}

Future<MemberResponse> updateLoginUser({required Map request}) async {
  return MemberResponse.fromJson(await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getMembers}/me',
      method: HttpMethod.PUT,
      request: request)));
}

/// Friendship Connection

Future<List<FriendshipResponseModel>> requestNewFriend(Map request) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getFriends}',
      request: request,
      method: HttpMethod.POST));

  return it.map((e) => FriendshipResponseModel.fromJson(e)).toList();
}

Future<RemoveExistingFriend> removeExistingFriendConnection(
    {required String friendId, required bool passRequest}) async {
  Map request = {"force": true};

  return RemoveExistingFriend.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.getFriends}/$friendId',
          method: HttpMethod.DELETE, request: passRequest ? request : null)));
}

Future<List<FriendshipResponseModel>> acceptFriendRequest(
    {required int id}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getFriends}/$id',
      method: HttpMethod.PUT));

  return it.map((e) => FriendshipResponseModel.fromJson(e)).toList();
}

//endregion

// region Images

Future<DeleteCoverImageResponse> deleteGroupCoverImage(
    {required int id}) async {
  return DeleteCoverImageResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          '${APIEndPoint.getGroups}/$id/${APIEndPoint.coverImage}',
          method: HttpMethod.DELETE)));
}

Future<DeleteCoverImageResponse> deleteMemberCoverImage(
    {required int id}) async {
  return DeleteCoverImageResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          '${APIEndPoint.getMembers}/$id/${APIEndPoint.coverImage}',
          method: HttpMethod.DELETE)));
}

Future<void> attachMemberImage(
    {required String id, File? image, bool isCover = false}) async {
  appStore.setLoading(true);

  MultipartRequest multiPartRequest = await getMultiPartRequest(
      '${APIEndPoint.getMembers}/$id/${isCover ? APIEndPoint.coverImage : APIEndPoint.avatarImage}');

  multiPartRequest.headers['authorization'] = 'Bearer ${appStore.token}';

  multiPartRequest.fields['action'] =
      isCover ? GroupImageKeys.coverActionKey : GroupImageKeys.avatarActionKey;
  multiPartRequest.files.add(await MultipartFile.fromPath('file', image!.path));

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      List<AvatarUrls> imageList = [];

      List jsonResponse = json.decode(data);
      jsonResponse.map((i) {
        imageList.add(AvatarUrls.fromJson(i));
      }).toList();

      if (!isCover) appStore.setLoginAvatarUrl(imageList.first.full.validate());
      appStore.setLoading(false);
      toast(language.profilePictureUpdatedSuccessfully, print: true);
    },
    onError: (error) {
      log('error: ${error.toString()}');
    },
  );
}

Future<void> groupAttachImage(
    {required int id, File? image, bool isCoverImage = false}) async {
  appStore.setLoading(true);
  MultipartRequest multiPartRequest = await getMultiPartRequest(
      '${APIEndPoint.getGroups}/$id/${isCoverImage ? APIEndPoint.coverImage : APIEndPoint.avatarImage}');

  multiPartRequest.headers['authorization'] = 'Bearer ${appStore.token}';

  multiPartRequest.fields['action'] = isCoverImage
      ? GroupImageKeys.coverActionKey
      : GroupImageKeys.avatarActionKey;
  multiPartRequest.files.add(await MultipartFile.fromPath('file', image!.path));

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      appStore.setLoading(false);

      List<CoverImageResponse> imageList = [];

      toast(isCoverImage
          ? language.coverUpdatedSuccessfully
          : language.avatarUpdatedSuccessfully);

      List jsonResponse = json.decode(data);
      jsonResponse.map((i) {
        imageList.add(CoverImageResponse.fromJson(i));
      }).toList();
    },
    onError: (error) {
      appStore.setLoading(false);

      log(error.toString());
    },
  );
}

Future<void> deleteMemberAvatarImage({required String id}) async {
  appStore.setLoading(true);
  await deleteAvatarImage(id: id).then((value) async {
    await getMemberAvatarUrls(id: id).then((value) {
      appStore.setLoginAvatarUrl(value.first.full.validate());
      appStore.setLoading(false);
      toast(language.profilePictureRemovedSuccessfully);
    });
  }).catchError((e) {
    appStore.setLoading(false);

    toast(e.toString(), print: true);
  });
}

Future<List<AvatarUrls>> getMemberAvatarUrls({required String id}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getMembers}/$id/${APIEndPoint.avatarImage}'));

  return it.map((e) => AvatarUrls.fromJson(e)).toList();
}

Future<DeleteAvatarResponse> deleteAvatarImage(
    {required String id, bool isGroup = false}) async {
  return DeleteAvatarResponse.fromJson(await handleResponse(await buildHttpResponse(
      '${isGroup ? APIEndPoint.getGroups : APIEndPoint.getMembers}/$id/${APIEndPoint.avatarImage}',
      method: HttpMethod.DELETE)));
}

Future<List<CoverImageResponse>> getMemberCoverImage(
    {required String id}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getMembers}/$id/${APIEndPoint.coverImage}'));

  return it.map((e) => CoverImageResponse.fromJson(e)).toList();
}

//endregion

// region Groups

Future<List<GroupResponse>> getUserGroups(
    {int page = 1, String? searchText, bool searchScreen = true}) async {
  Iterable it = Iterable.empty();

  it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}?page=$page&per_page=20${searchScreen ? '&search=$searchText' : ''}'));

  return it.map((e) => GroupResponse.fromJson(e)).toList();
}

Future<DeleteGroupResponse> deleteGroup({String? id}) async {
  return DeleteGroupResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.getGroups}/$id',
          method: HttpMethod.DELETE)));
}

Future<List<GroupResponse>> createGroup(Map request) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      APIEndPoint.getGroups,
      request: request,
      method: HttpMethod.POST));

  return it.map((e) => GroupResponse.fromJson(e)).toList();
}

Future<List<GroupResponse>> updateGroup(
    {required Map request, required int groupId}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/$groupId',
      request: request,
      method: HttpMethod.PUT));

  return it.map((e) => GroupResponse.fromJson(e)).toList();
}

/// Group Invites

Future<RejectGroupInviteResponse> rejectGroupInvite({required int id}) async {
  return RejectGroupInviteResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          '${APIEndPoint.getGroups}/${APIEndPoint.groupInvites}/$id',
          method: HttpMethod.DELETE)));
}

Future<List<GroupRequestsModel>> acceptGroupInvite({required String id}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/${APIEndPoint.groupInvites}/$id',
      method: HttpMethod.PUT));

  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

/// Group Membership Requests

Future<List<GroupRequestsModel>> joinPublicGroup({required int groupId}) async {
  Map request = {"user_id": appStore.loginUserId.toInt()};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/$groupId/${APIEndPoint.groupMembers}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

Future<RemoveGroupMember> leaveGroup({required int groupId}) async {
  return RemoveGroupMember.fromJson(await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/$groupId/${APIEndPoint.groupMembers}/${appStore.loginUserId}',
      method: HttpMethod.DELETE)));
}

Future<RemoveGroupMember> removeGroupMember(
    {required int groupId, required int memberId}) async {
  return RemoveGroupMember.fromJson(await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/$groupId/${APIEndPoint.groupMembers}/$memberId',
      method: HttpMethod.DELETE)));
}

Future<List<GroupRequestsModel>> groupMemberRoles(
    {required int groupId,
    required int memberId,
    required String role,
    required String action}) async {
  Map request = {"role": role, "action": action};
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/$groupId/${APIEndPoint.groupMembers}/$memberId',
      method: HttpMethod.PUT,
      request: request));

  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

Future<List<GroupMembershipRequestsModel>> sendGroupMembershipRequest(
    Map request) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/${APIEndPoint.groupMembershipRequests}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => GroupMembershipRequestsModel.fromJson(e)).toList();
}

Future<List<GroupRequestsModel>> acceptGroupMembershipRequest(
    {required int requestId}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroups}/${APIEndPoint.groupMembershipRequests}/$requestId',
      method: HttpMethod.PUT));
  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

Future<RejectGroupInviteResponse> rejectGroupMembershipRequest(
    {required int requestId}) async {
  return RejectGroupInviteResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          '${APIEndPoint.getGroups}/${APIEndPoint.groupMembershipRequests}/$requestId',
          method: HttpMethod.DELETE)));
}

/// Group Settings Requests

Future<CommonMessageResponse> editGroupSettings(
    {String? enableGallery, String? inviteStatus, int? groupId}) async {
  Map request = {
    "enable_gallery": enableGallery,
    "invite_status": inviteStatus,
    "group_id": groupId
  };
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.groupManageSettings}',
          method: HttpMethod.POST, request: request)));
}

//endregion

// region Post
Future<List<PostModel>> getPost(
    {int page = 1, int? userId, int? groupId, required String type}) async {
  Map request = {
    "user_id": userId ?? appStore.loginUserId.toInt(),
    "per_page": PER_PAGE,
    "page": page,
    "type": type,
    "group_id": groupId
  };

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.posts}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => PostModel.fromJson(e)).toList();
}

Future<PostModel> getSinglePost({required int postId}) async {
  Map request = {
    "type": PostRequestType.singleActivity,
    "activity_id": postId.toString(),
  };

  return PostModel.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.singlePosts}',
        method: HttpMethod.POST, request: request)),
  );
}

Future<List<MediaModel>> getMediaTypes({String? type}) async {
  Map request = {
    "component": type != null ? Component.members : Component.groups
  };
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.supportedMediaList}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => MediaModel.fromJson(e)).toList();
}

Future<List<PostInListModel>> getPostInList() async {
  Map request = {"current_user_id": appStore.loginUserId};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getPostInList}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => PostInListModel.fromJson(e)).toList();
}

Future<void> uploadPost({
  List<PostMedia>? postMedia,
  String? content,
  bool isMedia = false,
  String postIn = "0",
  String? mediaType,
  int? id,
  String? gif,
  String? type,
  String? parentPostId,
  String? mediaId,
  String? currentActivityType,
}) async {
  MultipartRequest multiPartRequest =
      await getMultiPartRequest('${APIEndPoint.createPosts}');

  multiPartRequest.headers['authorization'] = 'Bearer ${appStore.token}';

  if (id != null) multiPartRequest.fields['id'] = id.validate().toString();
  multiPartRequest.fields['content'] = content.validate();
  multiPartRequest.fields['activity_type'] = type != null
      ? type
      : isMedia
          ? gif != null
              ? PostActivityType.activityUpdate
              : PostActivityType.mppMediaUpload
          : PostActivityType.activityUpdate;
  multiPartRequest.fields['post_in'] = postIn.validate();
  if (postMedia.validate().isNotEmpty)
    multiPartRequest.fields['media_count'] =
        postMedia.validate().length.toString();
  if (gif.validate().isNotEmpty) multiPartRequest.fields['media_count'] = "1";
  multiPartRequest.fields['media_type'] = isMedia ? mediaType.validate() : "0";
  multiPartRequest.fields['media_id'] = mediaId.validate();
  multiPartRequest.fields['child_id'] = parentPostId.validate();
  multiPartRequest.fields['current_type'] = currentActivityType != null
      ? currentActivityType
      : isMedia
          ? gif != null
              ? PostActivityType.activityUpdate
              : PostActivityType.mppMediaUpload
          : PostActivityType.activityUpdate;
  multiPartRequest.fields['component'] =
      postIn.validate() != '0' ? Component.groups : '';

  if (postMedia.validate().isNotEmpty) {
    await Future.forEach(postMedia.validate(), (PostMedia element) async {
      int index = postMedia.validate().indexOf(element);

      if (element.isLink) {
        multiPartRequest.fields['media_$index'] = element.link.validate();
      } else {
        multiPartRequest.files.add(
            await MultipartFile.fromPath("media_$index", element.file!.path));
      }
    });
  } else if (gif.validate().isNotEmpty) {
    multiPartRequest.fields['media_0'] = gif.validate();
  }

  log('files ${multiPartRequest.files.map((e) => e.filename).toList()}');
  log('fields ${multiPartRequest.fields}');

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      CommonMessageResponse message =
          CommonMessageResponse.fromJson(jsonDecode(data));
      toast(message.message);
    },
    onError: (error) {
      toast(error.toString(), print: true);
    },
  );
}

Future<List<GetPostLikesModel>> getPostLikes(
    {required int id, int page = 1}) async {
  Map request = {"activity_id": id, "per_page": PER_PAGE, "page": page};
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getAllPostLike}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => GetPostLikesModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> likePost({required int postId}) async {
  Map request = {
    "activity_id": postId.toString(),
    "current_user_id": appStore.loginUserId
  };
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.likePost}',
        method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> deletePost({required int postId}) async {
  Map request = {"activity_id": postId, "user_id": appStore.loginUserId};
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.deletePost}',
        method: HttpMethod.DELETE, request: request)),
  );
}

Future<CommonMessageResponse> savePostComment(
    {required int postId,
    String? content,
    int? parentId,
    int? id,
    String? gifId,
    String? gifUrl}) async {
  Map request = {
    "activity_id": postId,
    "content": content,
    "parent_comment_id": parentId,
    "id": id != null ? id : null,
    "media_type": gifUrl.validate().isNotEmpty ? MediaTypes.gif : "",
    "media_id": gifId,
    "media": gifUrl,
  };
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.savePostComment}',
          method: HttpMethod.POST, request: request)));
}

Future<CommonMessageResponse> deletePostComment(
    {required int commentId, required int postId}) async {
  Map request = {
    "post_id": postId,
    "comment_id": commentId,
    "user_id": appStore.loginUserId
  };
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.deletePostComment}',
          method: HttpMethod.DELETE, request: request)));
}

Future<List<CommentModel>> getComments({required int id, int? page}) async {
  Map request = {"activity_id": id, "per_page": PER_PAGE, "page": page};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getPostComment}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => CommentModel.fromJson(e)).toList();
}

Future<void> hidePost({required int id}) async {
  Map request = {"activity_id": id};

  await handleResponse(await buildHttpResponse('${APIEndPoint.hidePost}',
      method: HttpMethod.POST, request: request));
}

Future<CommonMessageResponse> favoriteActivity({required int postId}) async {
  Map request = {"post_id": postId, "is_favorite": 1};
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.favoriteActivity}',
          method: HttpMethod.POST, request: request)));
}

Future<CommonMessageResponse> pinActivity(
    {required int postId, required int pinActivity}) async {
  Map request = {"post_id": postId, "pin_activity": pinActivity};
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.pinActivity}',
          method: HttpMethod.POST, request: request)));
}

//endregion

// region group
Future<List<GroupModel>> getGroupList(
    {String? groupType, int? page, int? userId}) async {
  Map request = {
    "group_type": groupType,
    "user_id": userId ?? appStore.loginUserId,
    "per_page": PER_PAGE,
    "page": page,
  };

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroupList}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => GroupModel.fromJson(e)).toList();
}

Future<List<GroupModel>> getGroupDetail({int? groupId, String? userId}) async {
  Map request = {
    "group_id": groupId,
    "current_user_id": userId ?? appStore.loginUserId,
  };

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroupDetail}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => GroupModel.fromJson(e)).toList();
}

Future<List<MemberModel>> getGroupMembersList(
    {int? groupId, int page = 1}) async {
  Map request = {"group_id": groupId, "per_page": 20, "page": page};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroupMembersList}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => MemberModel.fromJson(e)).toList();
}

Future<List<GroupRequestModel>> getGroupMembershipRequest(
    {int? groupId, int page = 1}) async {
  Map request = {"group_id": groupId, "per_page": 20, "page": page};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroupRequests}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => GroupRequestModel.fromJson(e)).toList();
}

Future<List<GroupInviteModel>> getGroupInviteList(
    {int? groupId, int page = 1}) async {
  Map request = {"group_id": groupId, "per_page": 10, "page": page};
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroupInvites}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => GroupInviteModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> invite(
    {required int isInviting,
    required int userId,
    required int groupId}) async {
  Map request = {
    "group_id": groupId,
    "user_id": userId,
    "is_inviting": isInviting
  };
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.manageInvitation}',
          method: HttpMethod.POST, request: request)));
}

Future<List<SuggestedGroup>> getSuggestedGroupList({int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getGroupList}?type=suggestions&per_page=20&page=$page',
      method: HttpMethod.GET));

  return it.map((e) => SuggestedGroup.fromJson(e)).toList();
}

Future<CommonMessageResponse> removeSuggestedGroup(
    {required int groupId}) async {
  Map request = {"refuse_id": groupId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.refuseGroupSuggestion}',
        method: HttpMethod.POST,
        request: request)),
  );
}

//endregion

// region member
Future<List<MemberDetailModel>> getMemberDetail({required int userId}) async {
  Map request = {"user_id": userId};
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getMemberDetail}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => MemberDetailModel.fromJson(e)).toList();
}

Future<List<FriendRequestModel>> getFriendList(
    {required int userId, int page = 1}) async {
  Map request = {"user_id": userId, "per_page": 20, "page": page};
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getFriendList}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => FriendRequestModel.fromJson(e)).toList();
}

Future<List<FriendRequestModel>> getFriendRequestList({int page = 1}) async {
  Map request = {
    "current_user_id": appStore.loginUserId.toInt(),
    "per_page": PER_PAGE,
    "page": page
  };
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getFriendRequestList}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => FriendRequestModel.fromJson(e)).toList();
}

Future<List<FriendRequestModel>> getFriendRequestSent({int page = 1}) async {
  Map request = {
    "current_user_id": appStore.loginUserId.toInt(),
    "per_page": 20,
    "page": page
  };
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getFriendRequestSent}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => FriendRequestModel.fromJson(e)).toList();
}

Future<List<FriendRequestModel>> getSuggestedUserList({int page = 1}) async {
  Map request = {"type": MemberType.suggested, "per_page": 20, "page": page};
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getUserList}',
      method: HttpMethod.POST,
      request: request));

  return it.map((e) => FriendRequestModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> removeSuggestedUser({required int userId}) async {
  Map request = {"refuse_id": userId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.refuseUserSuggestion}',
        method: HttpMethod.POST,
        request: request)),
  );
}

//endregion

// region settings and dashboard
Future<DashboardAPIResponse> getDashboardDetails() async {
  return DashboardAPIResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.getDashboard}',
        method: HttpMethod.GET)),
  );
}

Future<List<ProfileFieldModel>> getProfileFields() async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getProfileFields}',
      method: HttpMethod.GET));

  return it.map((e) => ProfileFieldModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> updateProfileFields(
    {required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.saveProfileFields}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<List<ProfileVisibilityModel>> getProfileVisibility() async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getProfileVisibility}',
      method: HttpMethod.GET));

  return it.map((e) => ProfileVisibilityModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> saveProfileVisibility(
    {required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.saveProfileVisibility}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<CommonMessageResponse> changePassword({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.changePassword}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<void> setPlayerId(Map req) async {
  await handleResponse(await buildHttpResponse('${APIEndPoint.setPlayerId}',
      method: HttpMethod.POST, request: req));
}

Future<CommonMessageResponse> saveNotificationsSettings(
    {List? requestList}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.saveNotificationSettings}',
        requestList: requestList,
        method: HttpMethod.POST)),
  );
}

Future<CommonMessageResponse> updateActiveStatus() async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
        await buildHttpResponse('${APIEndPoint.updateActiveStatus}')),
  );
}

//endregion

// region block report

Future<CommonMessageResponse> blockUser(
    {required String key, required int userId}) async {
  Map request = {"user_id": userId, "key": key};
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.blockMemberAccount}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<List<BlockedAccountsModel>> getBlockedAccounts() async {
  Iterable it = await handleResponse(
      await buildHttpResponse('${APIEndPoint.getBlockedMembers}'));

  return it.map((e) => BlockedAccountsModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> reportPost(
    {required String report,
    required String reportType,
    required int postId,
    required int userId}) async {
  Map request = {
    "user_id": userId,
    "item_id": postId,
    "report_type": reportType,
    "details": report
  };
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.reportPost}',
        method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> reportUser(
    {required String report,
    required int userId,
    required String reportType}) async {
  Map request = {
    "user_id": userId,
    "report_type": reportType,
    "details": report
  };
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.reportUserAccount}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<CommonMessageResponse> reportGroup(
    {required String report,
    required int groupId,
    required String reportType}) async {
  Map request = {
    "group_id": groupId,
    "report_type": reportType,
    "details": report
  };
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.reportGroup}',
        method: HttpMethod.POST, request: request)),
  );
}

//endregion

// region forums

Future<List<ForumModel>> getForumList({int page = 1, String? keyword}) async {
  Map request = {
    "keyword": keyword,
    "posts_per_page": PER_PAGE,
    "page": page,
  };

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.forums}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => ForumModel.fromJson(e)).toList();
}

Future<ForumDetailModel> getForumDetail(
    {required int forumId, int page = 1}) async {
  Map request = {
    "forum_id": forumId,
    "forums_page": page,
    "forums_per_page": PER_PAGE,
    "topics_page": page,
    "topics_per_page": PER_PAGE
  };

  return ForumDetailModel.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.forumDetails}',
        method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> subscribeForum({required int forumId}) async {
  Map request = {"id": forumId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.subscribeForum}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<CommonMessageResponse> createForumsTopic({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.createForumsTopic}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<List<TopicModel>> getTopicDetail(
    {required int topicId, int page = 1}) async {
  Map request = {"topic_id": topicId, "page": page, "posts_per_page": PER_PAGE};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.topicDetails}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => TopicModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> favoriteTopic({required int topicId}) async {
  Map request = {"topic_id": topicId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.favoriteTopic}',
        method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> replyTopic({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.replyTopic}',
        method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> editTopicReply({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
        '${APIEndPoint.editTopicReply}',
        method: HttpMethod.POST,
        request: request)),
  );
}

Future<SubscriptionListModel> subscribedList(
    {int page = 1, int perPage = PER_PAGE}) async {
  Map request = {"page": page, "posts_per_page": perPage};

  return SubscriptionListModel.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.subscriptionList}',
          method: HttpMethod.POST, request: request)));
}

Future<List<TopicReplyModel>> forumRepliesList(
    {int page = 1, int perPage = PER_PAGE}) async {
  Map request = {"is_user_replies": 1, "page": page, "posts_per_page": perPage};

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.forumRepliesList}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => TopicReplyModel.fromJson(e)).toList();
}

Future<List<TopicModel>> topicList(
    {int page = 1,
    int perPage = PER_PAGE,
    int? forumId,
    bool isFav = false,
    bool isEngagement = false,
    bool isUserTopic = false}) async {
  Map request = {
    "is_favorites": isFav ? 1 : 0,
    "is_engagements": isEngagement ? 1 : 0,
    "is_user_topic": isUserTopic ? 1 : 0,
    "page": 1,
    "posts_per_page": 10,
  };

  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.topicList}',
      method: HttpMethod.POST,
      request: request));
  return it.map((e) => TopicModel.fromJson(e)).toList();
}
//endregion

// region verified user badges

Future<CommonMessageResponse> verificationRequest() async {
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.verificationRequest}')));
}
//endregion

// region gallery
Future<CommonMessageResponse> deleteMedia(
    {required int id, required String type}) async {
  Map request = {"id": id, "type": type};
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.deleteAlbumMedia}',
          method: HttpMethod.DELETE, request: request)));
}

Future<List<MediaActiveStatusesModel>> getMediaStatus({String? type}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.mediaActiveStatus}?component=$type',
      method: HttpMethod.GET));
  return it.map((e) => MediaActiveStatusesModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> createAlbum(
    {required String component,
    int? groupID,
    required String type,
    required String title,
    required String description,
    required String status}) async {
  Map request = {
    "component": component,
    "title": title,
    "description": description,
    "type": type,
    "status": status,
    "group_id": groupID
  };

  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.createAlbum}',
          method: HttpMethod.POST, request: request)));
}

Future<List<Album>> getAlbums(
    {String? type, int? userId, String? groupId, int? page}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.getAlbums}?user_id=$userId&type=$type&group_id=$groupId&per_page=$PER_PAGE&page=$page',
      method: HttpMethod.GET));
  return it.map((e) => Album.fromJson(e)).toList();
}

Future<List<AlbumMediaListModel>> getAlbumDetails(
    {int? galleryID, int? page}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.albumMediaList}?gallery_id=$galleryID&per_page=$PER_PAGE&page=$page',
      method: HttpMethod.GET));
  return it.map((e) => AlbumMediaListModel.fromJson(e)).toList();
}

Future<void> uploadMediaFiles({
  int? galleryId,
  int? count,
  int? groupId,
  List<PostMedia>? media,
}) async {
  MultipartRequest multiPartRequest =
      await getMultiPartRequest('${APIEndPoint.uploadMedia}');

  multiPartRequest.headers['authorization'] = 'Bearer ${appStore.token}';

  if (galleryId != null)
    multiPartRequest.fields['gallery_id'] = galleryId.validate().toString();
  if (count != null)
    multiPartRequest.fields['count'] = count.validate().toString();
  if (groupId != null)
    multiPartRequest.fields['group_id'] = groupId.validate().toString();
  if (media.validate().isNotEmpty) {
    await Future.forEach(media.validate(), (PostMedia element) async {
      int index = media.validate().indexOf(element);
      multiPartRequest.files.add(
          await MultipartFile.fromPath("media_$index", element.file!.path));
    });
    log(appStore.token);
    log('files ${multiPartRequest.files.map((e) => e.filename).toList()}');
    log('fields ${multiPartRequest.fields}');

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        CommonMessageResponse message =
            CommonMessageResponse.fromJson(jsonDecode(data));
        toast(message.message);
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }
}
//endregion

// invitation region

Future<List<InviteListModel>> getInviteList({String? type}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
      '${APIEndPoint.inviteList}',
      method: HttpMethod.GET));
  return it.map((e) => InviteListModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> sendInvite(
    {String? email,
    String? message,
    List? inviteId,
    required bool isResend}) async {
  Map request = isResend
      ? {"type": "resend", "invite_id": inviteId}
      : {"email": email, "message": message};
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.sendInvite}',
          method: HttpMethod.POST, request: request)));
}

Future<CommonMessageResponse> deleteInvitedList({List? id}) async {
  Map request = {
    "id": id,
  };
  return CommonMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoint.inviteList}',
          method: HttpMethod.DELETE, request: request)));
}
