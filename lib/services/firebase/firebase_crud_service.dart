import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreCrudService<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath;
  final T Function(DocumentSnapshot<Map<String, dynamic>>) fromMap;
  final Map<String, dynamic> Function(T) toMap;

  FirestoreCrudService({
    required this.collectionPath,
    required this.fromMap,
    required this.toMap,
  });

  // Create a new document and return the created object
  Future<T> createDocument(T data) async {
    try {
      debugPrint('Creating document in $collectionPath');
      await _collection.doc().set(toMap(data));
      debugPrint('Document created successfully.');
      return data; // Return the created object
    } catch (e) {
      debugPrint('Failed to create document: $e');
      throw Exception('Failed to create document');
    }
  }

  // Retrieve a document by ID and return the object
  Future<T?> getDocument(String docId) async {
    try {
      debugPrint('Fetching document with ID: $docId from $collectionPath');
      DocumentSnapshot<Map<String, dynamic>> doc = await _collection.doc(docId).get();

      if (doc.exists) {
        debugPrint('Document found. Returning data.');
        return fromMap(doc); // Convert the document to T and return it
      } else {
        debugPrint('Document with ID $docId does not exist.');
        return null;
      }
    } catch (e) {
      debugPrint('Failed to get document: $e');
      throw Exception('Failed to get document');
    }
  }

  // Update an existing document and return the updated object
  Future<Map<String, dynamic>> updateDocument(String docId, Map<String, dynamic> data) async {
    try {
      debugPrint('Updating document with ID: $docId in $collectionPath');
      await _collection.doc(docId).update(data);
      debugPrint('Document updated successfully.');
      return data; // Return the updated object
    } catch (e) {
      debugPrint('Failed to update document: $e');
      throw Exception('Failed to update document');
    }
  }

  // Delete a document by ID
  Future<void> deleteDocument(String docId) async {
    try {
      debugPrint('Deleting document with ID: $docId from $collectionPath');
      await _collection.doc(docId).delete();
      debugPrint('Document deleted successfully.');
    } catch (e) {
      debugPrint('Failed to delete document: $e');
      throw Exception('Failed to delete document');
    }
  }

  // Retrieve all documents in the collection
  Stream<List<T>> getDocuments() {
    try {
      debugPrint('Fetching all documents from $collectionPath');
      return _collection.snapshots().map((snapshot) => snapshot.docs.map((doc) => fromMap(doc)).toList());
    } catch (e) {
      debugPrint('Failed to get documents: $e');
      throw Exception('Failed to get documents');
    }
  }

  // Retrieve all documents in the collection that ordered by the field
  Stream<List<T>> getDocumentsOrderBy(String field, {bool descending = false}) {
    try {
      debugPrint('Fetching all documents from $collectionPath order by $field, descending: $descending');
      return _collection.orderBy(field, descending: descending).snapshots().map((snapshot) => snapshot.docs.map((doc) => fromMap(doc)).toList());
    } catch (e) {
      debugPrint('Failed to get documents: $e');
      throw Exception('Failed to get documents');
    }
  }

  // Retrieve all documents in the collection that match the query
  Stream<List<T>> getDocumentsByQuery(String field, dynamic value, bool isEqualTo) {
    try {
      debugPrint('Fetching documents from $collectionPath where $field is $value');
      return _collection.where(field, isEqualTo: value).snapshots().map((snapshot) => snapshot.docs.map((doc) => fromMap(doc)).toList());
    } catch (e) {
      debugPrint('Failed to get documents by query: $e');
      throw Exception('Failed to get documents by query');
    }
  }

  // Retrieve all documents in the collection that match the query and ordered
  Stream<List<T>> getDocumentsByQueryOrderBy(String field, dynamic value, bool isEqualTo, String orderby, {bool descending = false}) {
    try {
      String notString = isEqualTo ? '' : 'not';
      debugPrint('Fetching documents from $collectionPath where $field is $notString $value and order by $orderby descending: $descending');
      Query<Map<String, dynamic>> filter = isEqualTo ? _collection.where(field, isEqualTo: value) : _collection.where(field, isNotEqualTo: value);
      return filter.orderBy(orderby, descending: descending).snapshots().map((snapshot) => snapshot.docs.map((doc) => fromMap(doc)).toList());
    } catch (e) {
      debugPrint('Failed to get documents by query: $e');
      throw Exception('Failed to get documents by query');
    }
  }

  Stream<List<T>> getDocumentsByQueriesOrderBy(Map<String, Map<String, dynamic>> queries, String orderby, {bool descending = false}) {
    try {
      debugPrint('Fetching documents from $collectionPath order by $orderby descending: $descending');
      Query<Map<String, dynamic>> filter = _collection;
      for (String queryKey in queries.keys) {
        debugPrint('Filter by $queryKey is ${queries[queryKey]!['isEqualTo']} ${queries[queryKey]!['value']}');
        filter = queries[queryKey]!['isEqualTo'] ? filter.where(queryKey, isEqualTo: queries[queryKey]!['value']) : filter.where(queryKey, isNotEqualTo: queries[queryKey]!['value']);
      }

      return filter.orderBy(orderby, descending: descending).snapshots().map((snapshot) => snapshot.docs.map((doc) => fromMap(doc)).toList());
    } catch (e) {
      debugPrint('Failed to get documents by query: $e');
      throw Exception('Failed to get documents by query');
    }
  }

  /* Getter and Setters */
  FirebaseFirestore get firestore => _firestore;

  FirebaseFirestore getFirestoreInstance() {
    return _firestore;
  }

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection(collectionPath);
}
