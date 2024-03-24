import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserBoughtTicketsRecord extends FirestoreRecord {
  UserBoughtTicketsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('user_bought_tickets');

  static Stream<UserBoughtTicketsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserBoughtTicketsRecord.fromSnapshot(s));

  static Future<UserBoughtTicketsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => UserBoughtTicketsRecord.fromSnapshot(s));

  static UserBoughtTicketsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserBoughtTicketsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserBoughtTicketsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserBoughtTicketsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserBoughtTicketsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserBoughtTicketsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserBoughtTicketsRecordData({
  String? email,
  String? uid,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'uid': uid,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserBoughtTicketsRecordDocumentEquality
    implements Equality<UserBoughtTicketsRecord> {
  const UserBoughtTicketsRecordDocumentEquality();

  @override
  bool equals(UserBoughtTicketsRecord? e1, UserBoughtTicketsRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(UserBoughtTicketsRecord? e) =>
      const ListEquality().hash([e?.email, e?.uid, e?.createdTime]);

  @override
  bool isValidKey(Object? o) => o is UserBoughtTicketsRecord;
}
