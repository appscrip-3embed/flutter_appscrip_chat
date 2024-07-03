import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatBroadcastController extends GetxController {
  IsmChatBroadcastController(this._viewModel);

  final IsmChatBroadcastViewModel _viewModel;

  TextEditingController broadcastName = TextEditingController();

  final refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.idle,
  );

  final refreshControllerEligibleMembers = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.idle,
  );

  final Rx<BroadcastMemberModel?> _broadcastMembers =
      Rx<BroadcastMemberModel?>(null);
  BroadcastMemberModel? get broadcastMembers => _broadcastMembers.value;
  set broadcastMembers(BroadcastMemberModel? value) {
    _broadcastMembers.value = value;
  }

  final _broadcastList = <BroadcastModel>[].obs;
  List<BroadcastModel> get broadcastList => _broadcastList;
  set broadcastList(List<BroadcastModel> value) {
    _broadcastList.value = value;
  }

  final RxList<UserDetails> _eligibleMembers = <UserDetails>[].obs;
  List<UserDetails> get eligibleMembers => _eligibleMembers;
  set eligibleMembers(List<UserDetails> value) {
    _eligibleMembers.value = value;
  }

  final RxBool _isApiCall = false.obs;
  bool get isApiCall => _isApiCall.value;
  set isApiCall(bool value) {
    _isApiCall.value = value;
  }

  Future<void> getBroadCast({
    bool isShowLoader = true,
    bool isloading = false,
    int skip = 0,
  }) async {
    if (isShowLoader) isApiCall = true;

    final response = await _viewModel.getBroadCast(
      isloading: isloading,
      skip: skip,
    );
    if (skip == 0 && response != null) {
      broadcastList = response;
    } else if (skip != 0 && response != null) {
      broadcastList.addAll(response);
    } else if (skip == 0) {
      broadcastList.clear();
    }
    if (isShowLoader) isApiCall = false;
  }

  Future<void> deleteBroadcast({
    required String groupcastId,
    bool isloading = false,
  }) async {
    final respones = await _viewModel.deleteBroadcast(
        groupcastId: groupcastId, isloading: isloading);
    if (respones) {
      await getBroadCast(
        isShowLoader: false,
        isloading: isloading,
      );
    }
  }

  Future<void> updateBroadcast({
    required String groupcastId,
    bool isloading = false,
    List<String>? searchableTags,
    Map<String, dynamic>? metaData,
    String? groupcastTitle,
    String? groupcastImageUrl,
    String? customType,
    bool shouldCallBack = false,
  }) async {
    final response = await _viewModel.updateBroadcast(
      groupcastId: groupcastId,
      customType: customType,
      groupcastImageUrl: groupcastImageUrl,
      groupcastTitle: groupcastTitle,
      isloading: isloading,
      metaData: metaData,
      searchableTags: searchableTags,
    );
    if (response && shouldCallBack) {
      unawaited(getBroadCast(
        isShowLoader: false,
        isloading: false,
      ));
      Get.back();
    }
  }

  Future<void> getBroadcastMembers({
    required String groupcastId,
    bool isloading = false,
    int skip = 0,
    int limit = 20,
    List<String>? ids,
    String? searchTag,
  }) async {
    final response = await _viewModel.getBroadcastMembers(
      groupcastId: groupcastId,
      isloading: isloading,
      ids: ids,
      limit: limit,
      searchTag: searchTag,
      skip: skip,
    );
    if (response != null) {
      broadcastMembers = response;
    }
  }

  Future<void> deleteBroadcastMember({
    required BroadcastModel broadcast,
    bool isloading = false,
    required List<String> members,
  }) async {
    final response = await _viewModel.deleteBroadcastMember(
      groupcastId: broadcast.groupcastId ?? '',
      members: members,
      isloading: isloading,
    );
    if (response != null) {
      final memberList = broadcast.metaData?.membersDetail ?? [];
      memberList.removeWhere((e) => e.memberId == members.first);
      broadcast.metaData?.copyWith(membersDetail: memberList);
      unawaited(
        updateBroadcast(
          groupcastId: broadcast.groupcastId ?? '',
          metaData: broadcast.metaData?.toMap(),
        ),
      );
      unawaited(getBroadCast(
        isShowLoader: false,
        isloading: false,
      ));
      await getBroadcastMembers(
          groupcastId: broadcast.groupcastId ?? '', isloading: true);
    }
  }

  Future<void> getEligibleMembers({
    required String groupcastId,
    bool isloading = false,
    int skip = 0,
    int limit = 20,
    String? searchTag,
    bool shouldShowLoader = true,
  }) async {
    if (shouldShowLoader) isApiCall = true;
    final response = await _viewModel.getEligibleMembers(
      groupcastId: groupcastId,
      isloading: isloading,
      skip: skip,
      limit: limit,
      searchTag: searchTag,
    );
    if (skip == 0 && response != null) {
      eligibleMembers = response;
    } else if (skip != 0 && response != null) {
      eligibleMembers.addAll(response);
    } else if (skip == 0) {
      eligibleMembers.clear();
    }
    if (shouldShowLoader) isApiCall = false;
  }
}
