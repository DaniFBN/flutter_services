class OrderByApiParam {
  const OrderByApiParam({
    required this.orderBy,
    this.descending = true,
  });

  final String orderBy;
  final bool descending;
}
