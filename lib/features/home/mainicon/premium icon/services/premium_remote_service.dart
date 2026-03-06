import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PremiumRemoteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> activateTrial() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final trialEndDate = DateTime.now().add(const Duration(days: 7));

    await _firestore.collection('users').doc(user.uid).update({
      'isPremium': true,
      'premiumType': 'trial',
      'trialEndsAt': trialEndDate,
      'premiumActivatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restorePurchase() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists || doc.data()?['isPremium'] != true) {
      throw Exception("No active subscription found");
    }
  }
}