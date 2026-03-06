import 'package:book_app/features/home/mainicon/premium%20icon/models/premium_model.dart' show PremiumModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PremiumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<PremiumModel> fetchPremiumStatus() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return PremiumModel(
        isPremium: false,
        expiryDate: null,
        trialUsed: false,
      );
    }

    final doc = await _firestore.collection('users').doc(uid).get();

    return PremiumModel.fromMap(doc.data() ?? {});
  }
}