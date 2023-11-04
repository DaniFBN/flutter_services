import 'params/filter_api_param.dart';
import 'params/get_api_param.dart';

abstract interface class ApiService {
  /// Should return Future with values
  Future<List<Map<String, dynamic>>> get(GetApiParam param);

  /// Should return a Stream with values
  Stream<List<Map<String, dynamic>>> snapshot(GetApiParam param);

  /// Should return an item filtered by ID
  Future<Map<String, dynamic>> retrieve(String endpoint, String id);

  /// Should add an item and return your ID
  Future<String> add(String endpoint, Map<String, dynamic> data);

  /// Should update an item, the current value will be OVERRIDE by the new
  Future<void> update(String endpoint, String id, Map<String, dynamic> data);

  /// Should delete an item
  Future<void> delete(String endpoint, String id);

  /// Should return amount itens had with those filters in an endpoint
  Future<int> count({
    required String endpoint,
    List<FilterApiParam> filters,
  });
}
