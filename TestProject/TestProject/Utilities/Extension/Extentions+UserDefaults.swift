
import Foundation

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UserDefaults
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension UserDefaults {
    static var language: Language {
        get {
            if let lang = UserDefaults.standard.string(forKey: UserDefaultKey.kCurrentLanguage),
                let language = Language(rawValue: lang) {
                return language
            } else {
                //Set Default Language and return
                UserDefaults.standard.set(Language.enLang.rawValue, forKey: UserDefaultKey.kCurrentLanguage)
                return .enLang
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultKey.kCurrentLanguage)
        }
    }
    static var languageId: String {
        get {
            if let langId = UserDefaults.standard.string(forKey: UserDefaultKey.kCurrentLanguageId) {
                return langId
            } else {
                //Set Default Language and return
                UserDefaults.standard.set("1", forKey: UserDefaultKey.kCurrentLanguageId)
                return "1"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.kCurrentLanguageId)
        }
    }
}
