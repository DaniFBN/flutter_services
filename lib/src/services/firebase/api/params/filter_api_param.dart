enum FilterType { contains, equal, whereIn }

class FilterApiParam {
  const FilterApiParam._({
    required this.field,
    required this.type,
    required this.value,
  });

  factory FilterApiParam.contains(String field, Object value) {
    return FilterApiParam._(
      field: field,
      type: FilterType.contains,
      value: value,
    );
  }

  factory FilterApiParam.equal(String field, Object value) {
    return FilterApiParam._(
      field: field,
      type: FilterType.equal,
      value: value,
    );
  }

  factory FilterApiParam.whereIn(String field, Iterable<Object> value) {
    return FilterApiParam._(
      field: field,
      type: FilterType.equal,
      value: value,
    );
  }

  final String field;
  final FilterType type;
  final Object value;
}
