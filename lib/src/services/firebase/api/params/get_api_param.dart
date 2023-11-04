import 'filter_api_param.dart';
import 'order_by_api_param.dart';

class GetApiParam {
  const GetApiParam(
    this.endpoint, {
    this.filters = const [],
    this.orderBy,
    this.limit,
  });

  final String endpoint;
  final List<FilterApiParam> filters;
  final OrderByApiParam? orderBy;
  final int? limit;
}
