import '../models/help_faq_model.dart';

class HelpService {

  /// FETCH FAQS
  Future<List<HelpFaqModel>> fetchFAQs() async {

    await Future.delayed(const Duration(milliseconds: 500));

    return [
      HelpFaqModel(
        question: "How do I reset my password?",
        answer:
            "Go to Settings > Account > Reset Password and follow instructions.",
      ),
      HelpFaqModel(
        question: "What payment methods are accepted?",
        answer:
            "We accept Credit Card, Debit Card, UPI, PayPal and Google Pay.",
      ),
      HelpFaqModel(
        question: "How can I read offline books?",
        answer:
            "Download the book first then open Offline Vault.",
      ),
    ];
  }

  /// SEND SUPPORT EMAIL
  Future<void> sendSupportEmail(String message) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// CREATE SUPPORT TICKET
  Future<void> createSupportTicket(String issue) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}