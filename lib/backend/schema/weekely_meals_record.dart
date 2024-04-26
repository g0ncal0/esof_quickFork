import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class WeekelyMealsRecord extends FirestoreRecord {
  WeekelyMealsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "descriptionMeat" field.
  String? _descriptionMeat;
  String get descriptionMeat => _descriptionMeat ?? '';
  bool hasDescriptionMeat() => _descriptionMeat != null;

  // "descriptionFish" field.
  String? _descriptionFish;
  String get descriptionFish => _descriptionFish ?? '';
  bool hasDescriptionFish() => _descriptionFish != null;

  // "descriptionVegetarian" field.
  String? _descriptionVegetarian;
  String get descriptionVegetarian => _descriptionVegetarian ?? '';
  bool hasDescriptionVegetarian() => _descriptionVegetarian != null;

  // "weekdayMeal" field.
  String? _weekdayMeal;
  String get weekdayMeal => _weekdayMeal ?? '';
  bool hasWeekdayMeal() => _weekdayMeal != null;

  void _initializeFields() {
    _date = snapshotData['date'] as DateTime?;
    _descriptionMeat = snapshotData['descriptionMeat'] as String?;
    _descriptionFish = snapshotData['descriptionFish'] as String?;
    _descriptionVegetarian = snapshotData['descriptionVegetarian'] as String?;
    _weekdayMeal = snapshotData['weekdayMeal'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('WeekelyMeals');

  static Stream<WeekelyMealsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => WeekelyMealsRecord.fromSnapshot(s));

  static Future<WeekelyMealsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => WeekelyMealsRecord.fromSnapshot(s));

  static WeekelyMealsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      WeekelyMealsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static WeekelyMealsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      WeekelyMealsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'WeekelyMealsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is WeekelyMealsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createWeekelyMealsRecordData({
  DateTime? date,
  String? descriptionMeat,
  String? descriptionFish,
  String? descriptionVegetarian,
  String? weekdayMeal,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
      'descriptionMeat': descriptionMeat,
      'descriptionFish': descriptionFish,
      'descriptionVegetarian': descriptionVegetarian,
      'weekdayMeal': weekdayMeal,
    }.withoutNulls,
  );

  return firestoreData;
}

class WeekelyMealsRecordDocumentEquality
    implements Equality<WeekelyMealsRecord> {
  const WeekelyMealsRecordDocumentEquality();

  @override
  bool equals(WeekelyMealsRecord? e1, WeekelyMealsRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.descriptionMeat == e2?.descriptionMeat &&
        e1?.descriptionFish == e2?.descriptionFish &&
        e1?.descriptionVegetarian == e2?.descriptionVegetarian &&
        e1?.weekdayMeal == e2?.weekdayMeal;
  }

  @override
  int hash(WeekelyMealsRecord? e) => const ListEquality().hash([
        e?.date,
        e?.descriptionMeat,
        e?.descriptionFish,
        e?.descriptionVegetarian,
        e?.weekdayMeal
      ]);

  @override
  bool isValidKey(Object? o) => o is WeekelyMealsRecord;
}
