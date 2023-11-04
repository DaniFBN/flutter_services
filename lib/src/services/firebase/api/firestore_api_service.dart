import 'package:cloud_firestore/cloud_firestore.dart';

import 'api_service.dart';
import 'params/_params.dart';

class FirestoreApiService implements ApiService {
  const FirestoreApiService(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<Map<String, dynamic>> retrieve(String endpoint, String id) async {
    final data = await _firestore.collection(endpoint).doc(id).get();

    return _docSnapshotToMap(data);
  }

  @override
  Future<List<Map<String, dynamic>>> get(GetApiParam param) async {
    final query = _defaultGet(param);
    final data = await query.get();

    final docs = data.docs.map(_docSnapshotToMap).toList();

    return docs;
  }

  @override
  Stream<List<Map<String, dynamic>>> snapshot(GetApiParam param) {
    final query = _defaultGet(param);
    final stream = query.snapshots();

    final docs = stream.map((querySnapshot) {
      return querySnapshot.docs.map(_docSnapshotToMap).toList();
    });

    return docs;
  }

  @override
  Future<int> count({
    required String endpoint,
    List<FilterApiParam> filters = const [],
  }) async {
    final collectionRef = _firestore.collection(endpoint);

    final query = _handleFilters(collectionRef, filters);

    final data = await query.count().get();

    return data.count;
  }

  @override
  Future<String> add(String endpoint, Map<String, dynamic> data) async {
    final doc = await _firestore.collection(endpoint).add(data);

    return doc.id;
  }

  @override
  Future<void> update(
    String endpoint,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(endpoint).doc(id).set(data);
  }

  @override
  Future<void> delete(String endpoint, String id) async {
    await _firestore.collection(endpoint).doc(id).delete();
  }

  Query _defaultGet(GetApiParam param) {
    final collectionRef = _firestore.collection(param.endpoint);

    Query query = collectionRef;
    query = _handleFilters(query, param.filters);
    query = _handleOrderBy(query, param.orderBy);
    query = _handleLimit(query, param.limit);

    return query;
  }

  Query _handleFilters(Query query, List<FilterApiParam> filters) {
    var handledQuery = query;
    for (final filter in filters) {
      Object field = filter.field;
      if (filter.field == 'id') {
        field = FieldPath.documentId;
      }

      switch (filter.type) {
        case FilterType.contains:
          handledQuery = handledQuery.where(
            field,
            arrayContains: filter.value,
          );
        case FilterType.whereIn:
          handledQuery = handledQuery.where(
            field,
            whereIn: filter.value as Iterable,
          );
        case FilterType.equal:
          handledQuery = handledQuery.where(
            field,
            isEqualTo: filter.value,
          );
      }
    }

    return handledQuery;
  }

  Query _handleLimit(Query query, int? limit) {
    if (limit == null || limit == 0) return query;

    return query.limit(limit);
  }

  Query _handleOrderBy(Query query, OrderByApiParam? param) {
    if (param == null) return query;

    return query.orderBy(param.orderBy, descending: param.descending);
  }

  Map<String, dynamic> _docSnapshotToMap(DocumentSnapshot doc) {
    return {
      'id': doc.id,
      ...Map<String, dynamic>.from(doc.data()! as Map),
    };
  }
}
