import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBroadcastController extends GetxController {
  IsmChatBroadcastController(this._viewModel);

  final IsmChatBroadcastViewModel _viewModel;

  TextEditingController broadcastName = TextEditingController();

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

  final RxBool _isApiCall = false.obs;
  bool get isApiCall => _isApiCall.value;
  set isApiCall(bool value) {
    _isApiCall.value = value;
  }

  Future<void> getBroadCast({
    bool isCallFromDelete = false,
    bool isloading = false,
  }) async {
    if (!isCallFromDelete) isApiCall = true;

    final response = await _viewModel.getBroadCast(isloading: isloading);
    if (response != null) {
      broadcastList = response;
    }
    if (!isCallFromDelete) isApiCall = false;
  }

  Future<void> deleteBroadcast({
    required String groupcastId,
    bool isloading = false,
  }) async {
    final respones = await _viewModel.deleteBroadcast(
        groupcastId: groupcastId, isloading: isloading);
    if (respones) {
      await getBroadCast(
        isCallFromDelete: true,
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
    );
    if (response != null) {
      broadcastMembers = response;
    }
  }

  Future<void> deleteBroadcastMember({
    required String groupcastId,
    bool isloading = false,
    required List<String> members,
  }) async {
    final response = await _viewModel.deleteBroadcastMember(
        groupcastId: groupcastId, members: members, isloading: isloading);
    if (response != null) {
      await getBroadcastMembers(groupcastId: groupcastId, isloading: true);
    }
  }
}
