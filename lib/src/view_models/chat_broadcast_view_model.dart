import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatBroadcastViewModel {
  IsmChatBroadcastViewModel(this._repository);

  final IsmChatBroadcastRepository _repository;

  Future<IsmChatResponseModel?> getBroadCast({
    List<String>? ids,
    String customType = '',
    String searchTag = '',
    int sort = -1,
    int skip = 0,
    int limit = 20,
    bool sortByCustomType = false,
    bool executionPending = false,
    bool isloading = false,
  }) async =>
      await _repository.getBroadCast(
        ids: ids ?? [],
        customType: customType,
        searchTag: searchTag,
        sort: sort,
        skip: skip,
        limit: limit,
        sortByCustomType: sortByCustomType,
        executionPending: executionPending,
      );
}
