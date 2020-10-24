
import UIKit
import CoreLocation
/// Shared instance class
class USSRWS: NSObject {
    /// Shared object
    static let shared = USSRWS()
    var printRequest = true
    var printResponse = false
    var isCallFirstTimeForAllData = false
    var isOnNotification = "ON"
    var objSideMenu: SideMenuClass?
    var coordinateRWS = CLLocation()
    var coordinateUSER = CLLocation()
    var objLanguageKeyValues: LanguageKeyValues?
    var tabVC: TabBarDashBoard?
    var homeVC: HomeViewController?
    var guestServicesVC: GuestServicesVC?
    var amenitiesVC: AmenitiesVC?
    var webviewPreloader = WebViewPreloader()
    var handleNotificationClass = HandleNotificationManager()
    var contentUpdateManager = ContentUpdateManager()

    /// Init class
    override init() {
        super.init()
    }
    /// Get Localization Langugae key values
    ///
    /// - Returns: result data
    func getLanguageKeyValues() -> LanguageKeyValues? {
        if self.objLanguageKeyValues == nil {
            let data = Utility.getLanguageKeyValues().compactMap(LanguageKeyValues.init)
            self.objLanguageKeyValues = (data.filter({$0.languageId == UserDefaults.languageId})).first
        }
        return self.objLanguageKeyValues
    }
    /// Set localiation language data object
    ///
    /// - Returns: data
    func setLanguageKeyValues() -> LanguageKeyValues? {
        let data = Utility.getLanguageKeyValues().compactMap(LanguageKeyValues.init)
        self.objLanguageKeyValues = (data.filter({$0.languageId == UserDefaults.languageId})).first
        return self.objLanguageKeyValues
    }
    // MARK: - get tabVC
    /// tabbar class object instance
    ///
    /// - Returns: class object
    func getTabVC() -> TabBarDashBoard? {
        if self.tabVC == nil {
            self.tabVC = UIStoryboard.rws.instantiateViewController(withIdentifier:
                VCIdentifier.TabBarDashBoard) as? TabBarDashBoard
        }
        return self.tabVC
    }
}
