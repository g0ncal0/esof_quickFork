import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class BoughtTicketRecord extends FirestoreRecord {
  BoughtTicketRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  bool hasDate() => _date != null;

  // "qrcodeinfo" field.
  String? _qrcodeinfo;
  String get qrcodeinfo => _qrcodeinfo ?? '';
  bool hasQrcodeinfo() => _qrcodeinfo != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _date = snapshotData['date'] as String?;
    _qrcodeinfo = snapshotData['qrcodeinfo'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('bought_ticket');

  static Stream<BoughtTicketRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BoughtTicketRecord.fromSnapshot(s));

  static Future<BoughtTicketRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BoughtTicketRecord.fromSnapshot(s));

  static BoughtTicketRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BoughtTicketRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BoughtTicketRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BoughtTicketRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BoughtTicketRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BoughtTicketRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBoughtTicketRecordData({
  String? uid,
  String? date,
  String? qrcodeinfo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'date': date,
      'qrcodeinfo': qrcodeinfo,
    }.withoutNulls,
  );

  return firestoreData;
}

class BoughtTicketRecordDocumentEquality
    implements Equality<BoughtTicketRecord> {
  const BoughtTicketRecordDocumentEquality();

  @override
  bool equals(BoughtTicketRecord? e1, BoughtTicketRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.date == e2?.date &&
        e1?.qrcodeinfo == e2?.qrcodeinfo;
  }

  @override
  int hash(BoughtTicketRecord? e) =>
      const ListEquality().hash([e?.uid, e?.date, e?.qrcodeinfo]);

  @override
  bool isValidKey(Object? o) => o is BoughtTicketRecord;
}
