import 'package:esof/backend/backend.dart';
import 'package:esof/index.dart';
import 'package:esof/pages/checkout/checkout_model.dart';
import 'package:esof/pages/place_holder/bought_meals_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore{}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main(){
  group('qr code', (){
    CheckoutWidget checkoutWidget = CheckoutWidget(weekDay: 'monday', mealID: 'lunch');

    // Ticket Creation
    test('Generated QR code length', () {
      String qrCode = checkoutWidget.createQrCode();
      DateTime now = DateTime.now();
      String timeStamp = now.microsecondsSinceEpoch.toString(); // Unique timestamp
      expect(qrCode.length, equals(16 + timeStamp.length)); // Timestamp (13 characters) + Random string (6 characters)
    });

    test('Generated QR codes are unique', () {
      String qrCode1 = checkoutWidget.createQrCode();
      String qrCode2 = checkoutWidget.createQrCode();
      expect(qrCode1, isNot(equals(qrCode2)));
    });

    test('Generated QR code character set', () {
      String qrCode = checkoutWidget.createQrCode();
      const characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
      for (int i = 0; i < qrCode.length; i++) {
        expect(characters.contains(qrCode[i]), isTrue);
      }
    });

    // Ticket Scan (Cannot be tested)
    /*test('Generated QR code character set', () async {
        final mockFirebaseFirestore = MockFirebaseFirestore();
        final mockDocumentReference = MockDocumentReference();
        final mockDocumentSnapshot = MockDocumentSnapshot();
        PlaceHolderModel placeHolderModel = PlaceHolderModel();

        placeHolderModel.firebaseFirestore = mockFirebaseFirestore;

        final scannedValue = 'someScannedValue';

        when(mockFirebaseFirestore.collection("bought_ticket").doc(scannedValue)).thenReturn(mockDocumentReference as DocumentReference<Map<String, dynamic>>);
        when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data()).thenReturn({'scanned': false});
        when(mockDocumentReference.set(any, SetOptions(merge: true))).thenAnswer((_) async => null);

        placeHolderModel.scanQrCode();

        verify(mockFirebaseFirestore.collection("bought_ticket").doc(scannedValue)).called(1);
        verify(mockDocumentReference.get()).called(1);
        verify(mockDocumentReference.set({'scanned': true}, SetOptions(merge: true))).called(1);
    });*/
  });
}