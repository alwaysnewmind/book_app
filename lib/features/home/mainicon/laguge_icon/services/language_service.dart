import 'package:book_app/features/home/mainicon/laguge_icon/models/language_model.dart' show LanguageModel;



class LanguageService {

  List<LanguageModel> getLanguages() {
    return [

      LanguageModel(
        code: "en",
        name: "English",
        subtitle: "English (Default)",
      ),

      LanguageModel(
        code: "hi",
        name: "हिन्दी",
        subtitle: "Hindi",
      ),

      LanguageModel(
        code: "gu",
        name: "ગુજરાતી",
        subtitle: "Gujarati",
      ),

      LanguageModel(
        code: "ta",
        name: "தமிழ்",
        subtitle: "Tamil",
      ),

      LanguageModel(
        code: "te",
        name: "తెలుగు",
        subtitle: "Telugu",
      ),

      LanguageModel(
        code: "ml",
        name: "മലയാളം",
        subtitle: "Malayalam",
      ),

      LanguageModel(
        code: "mr",
        name: "मराठी",
        subtitle: "Marathi",
      ),

      LanguageModel(
        code: "bn",
        name: "বাংলা",
        subtitle: "Bengali",
      ),

      LanguageModel(
        code: "pa",
        name: "ਪੰਜਾਬੀ",
        subtitle: "Punjabi",
      ),

      LanguageModel(
        code: "kn",
        name: "ಕನ್ನಡ",
        subtitle: "Kannada",
      ),
    ];
  }
}