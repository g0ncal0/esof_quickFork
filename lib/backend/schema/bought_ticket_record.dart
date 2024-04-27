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

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  bool hasDate() => _date != null;

  // "fullDish" field.
  bool? _fullDish;
  bool get fullDish => _fullDish ?? false;
  bool hasFulldish() => _fullDish != null;

  // "meal_id" field.
  String? _meal_id;
  String get meal_id => _meal_id ?? '';
  bool hasMeal_id() => _meal_id != null;

  // "qrcodeinfo" field.
  String? _qrcodeinfo;
  String get qrcodeinfo => _qrcodeinfo ?? '';
  bool hasQrcodeinfo() => _qrcodeinfo != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "scanned" field
  bool? _scanned;
  bool get scanned => _scanned ?? false;
  bool hasScanned() => _scanned != null;



  void _initializeFields() {
    _date = snapshotData['date'] as String?;
    _fullDish = snapshotData['fullDish'] as bool?;
    _meal_id = snapshotData['meal_id'] as String?;
    _qrcodeinfo = snapshotData['qrcodeinfo'] as String?;
    _type = snapshotData['type'] as String?;
    _uid = snapshotData['uid'] as String?;
    _scanned = snapshotData['scanned'] as bool?;
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
  String? date,
  bool? fullDish,
  String? meal_id,
  String? qrcodeinfo,
  String? type,
  String? uid,
  bool? scanned
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date' : date,
      'fullDish' : fullDish,
      'meal_id' : meal_id,
      'qrcodeinfo' : qrcodeinfo,
      'type' : type,
      'uid' : uid,
      'scanned' : scanned
    }.withoutNulls,
  );

  return firestoreData;
}

class BoughtTicketRecordDocumentEquality
    implements Equality<BoughtTicketRecord> {
  const BoughtTicketRecordDocumentEquality();

  @override
  bool equals(BoughtTicketRecord? e1, BoughtTicketRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.fullDish == e2?.fullDish &&
        e1?.meal_id == e2?.meal_id &&
        e1?.qrcodeinfo == e2?.qrcodeinfo &&
        e1?.type == e2?.type &&
        e1?.uid == e2?.uid &&
        e1?.scanned == e2?.scanned;
  }

  @override
  int hash(BoughtTicketRecord? e) =>
      const ListEquality().hash([
e?.date,e?.fullDish,e?.meal_id,e?.qrcodeinfo,e?.type,e?.uid,e?.scanned
      ]);

  @override
  bool isValidKey(Object? o) => o is BoughtTicketRecord;
}
