

import UIKit
import MobileCoreServices
import Accelerate
import NaturalLanguage

// MARK: - Extension of UIApplication
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

// MARK: UIDevice extensions
public extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}

// MARK: - Extension of UIStoryboard
extension UIStoryboard {
    static let main = UIStoryboard(name: "Name", bundle: nil)
}

// MARK: - Extension of UINavigationController
extension UINavigationController {
    
    /// Pop to root view controller by checking no of controller in navigation stack.
    ///
    /// - Parameter animated: Set this value to true to animate the transition.
    func customPopToRootViewController(animated: Bool) {
        if self.viewControllers.count > 2 {
            self.popToRootViewController(animated: animated)
        }
        else if self.viewControllers.count > 1 {
            self.popViewController(animated: animated)
        }
    }
}

// MARK: - Extension of UIViewController
extension UIViewController {
    
    var tabBarVC: TabBarVC? {
        return self.tabBarController as? TabBarVC
    }
    
    var currentTopViewController: UIViewController? {
        let tabbarVC = self is UITabBarController ? self as? UITabBarController : self.tabBarController
        return (tabbarVC?.selectedViewController as? UINavigationController)?.topViewController
    }
    
    /// Show alert with title and message.
    ///
    /// - Parameters:
    ///   - title: Title that need to display with alert popup. Default is nil.
    ///   - message: Message that need to display with alert popup.
    ///   - firstBtnName: First button name of alert popup. Default is OK.
    ///   - firstBtnHandler: First button handler of alert popup. Default is nil.
    ///   - secondBtnName: Set to display second button with alert popup. Default is nil.
    ///   - secondBtnHandler: Second button handler of alert popup. Default is nil.
    func showAlert(title: String? = nil, message: String, firstBtnName: String = "OK", firstBtnHandler: ((UIAlertAction) -> Void)? = nil, secondBtnName: String? = nil, secondBtnHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: firstBtnName, style: .default, handler: firstBtnHandler))
        if secondBtnName != nil {
            alertController.addAction(UIAlertAction(title: secondBtnName, style: .default, handler: secondBtnHandler))
        }
        self.present(alertController, animated: true)
    }
    
    /// Show custom error popup.
    ///
    /// - Parameters:
    ///   - message: Message that need to display with alert popup.
    ///   - buttons: Title of two buttons.
    ///   - buttonHandler: First Button handler of custom alert popup. Default is nil.
    ///   - secondButtonHandler: Second Button handler of custom alert popup. Default is nil.
    func showErrorPopup(withMessage message: String, buttons: [String] = ["OK"], buttonHandler: (()->Void)? = nil, secondButtonHandler: (()->Void)? = nil) {
        guard !message.isEmpty else { return }
        let vc = SuccessPopupVC.successPopupVC(withMessage: message, buttonTitle: buttons.first ?? "", isForError: true)
        vc.buttonHandler = {
            vc.dismiss(animated: false, completion: {
                buttonHandler?()
            })
        }
        if buttons.count == 2 {
            vc.showSecondButton = true
            vc.secondButtonTitle = buttons.last ?? ""
            vc.secondButtonHandler = {
                vc.dismiss(animated: false, completion: {
                    secondButtonHandler?()
                })
            }
        }
        if let tabbarVC = self.tabBarController {
            tabbarVC.present(vc, animated: true)
        }
        else {
            self.present(vc, animated: true)
        }
    }
    
    /// Show custom prompt popup for contact fields.
    ///
    /// - Parameters:
    ///   - message: Message that need to display with alert popup.
    ///   - cancelButtonHandler: Cancel button handler of alert popup. Default is nil.
    ///   - editButtonHandler: Edit button handler of alert popup. Default is nil.
    func showCustomPromptPopup(withMessage message: String, cancelButtonHandler: (()->Void)? = nil,editButtonHandler: (()->Void)? = nil) {
        let vc = CustomSuccessPopupVC.errorPopupVC(withMessage: message, button1Title: "Cancel", button2Title: "Edit", isForError: true)
        vc.button1Handler = cancelButtonHandler
        vc.button2Handler = editButtonHandler
        if let tabbarVC = self.tabBarController {
            tabbarVC.present(vc, animated: true)
        }
        else {
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Extension of UITabBar
extension UITabBar {
    var notificationItem: UITabBarItem? {
        return self.items?[3]
    }
    
    var dailyWalkInItem: UITabBarItem? {
        return self.items?[4]
    }
}

// MARK: - Extension of UITabBarItem
extension UITabBarItem {
    
    /// Set read notification image icon for notification tab.
    func setReadNotificationImage() {
        self.image = UIImage(named: "tab_notification")
        self.selectedImage = UIImage(named: "tab_notification")
    }
    
    /// Set unread notification image icon for notification tab.
    func setUnreadNotificationImage() {
        self.image = UIImage(named: "tab_notification_unread")
        self.selectedImage = UIImage(named: "tab_notification_unread")
    }
    
    /// Set disable daily walkin icon for DailyWalkIn tab.
    func setDisableDailyWalkInImage() {
        self.image = UIImage(named: "tab_dailywalkin_disable")
        self.selectedImage = UIImage(named: "tab_dailywalkin_disable")
    }
    
    /// Set enable daily walkin icon for DailyWalkIn tab.
    func setDailyWalkInImage() {
        self.image = UIImage(named: "tab_dailywalkin")
        self.selectedImage = UIImage(named: "tab_dailywalkin")
    }
}

// MARK: - Extension of UIView
extension UIView {
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    /// Make square view to circle by setting corner radius.
    func makeCircleRadius() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }
    
    /// Make square view to circle by setting corner radius.
    func makeCircleRadius(withValue value:CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    
    /// Show bottom shadow with view.
    ///
    /// - Parameters:
    ///   - color: Shadow color for view. Default is gray.
    ///   - opacity: Opacity of shadow. Default is 0.6.
    func showBottomShadow(withColor color: UIColor = .gray, opacity: Float = 0.6) {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
    }
    
    /// Show top shadow with view.
    ///
    /// - Parameters:
    ///   - color: Shadow color for view. Default is gray.
    ///   - opacity: Opacity of shadow. Default is 0.6.
    func showTopShadow(withColor color: UIColor = .gray, opacity: Float = 0.6) {
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
    }
    
    /// Draw dashed line in view using CAShapeLayer.
    ///
    /// - Parameters:
    ///   - color: Color of dash line.
    ///   - lineLength: Length of dash between two gap. Default line length is 5.
    ///   - gapLength: Length of gap between two dash. Default gap length is 3.
    ///   - rect: Frame of view in which need to draw dashed line.
    func drawDashedLine(color: UIColor = .black, lineLength: NSNumber = 5, gapLength: NSNumber = 3, rect: CGRect = .zero) {
        for layer in self.layer.sublayers ?? [] {
            if layer.name == "DashLine" {
                layer.removeFromSuperlayer()
                break
            }
        }
        let newBounds = rect == .zero ? self.bounds : rect
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashLine"
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [lineLength, gapLength]
        let start = CGPoint(x: newBounds.minX, y: newBounds.minY)
        let end = CGPoint(x: newBounds.maxX, y: newBounds.minY)
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    /// Add dashed border line around view.
    ///
    /// - Parameters:
    ///   - color: Color of dashed border line.
    ///   - lineLength: Length of dash between two gap. Default line length is 3.
    ///   - gapLength: Length of gap between two dash. Default gap length is 1.
    ///   - size: Size of view that need to show dashed border line.
    func addDashedBorder(color: UIColor = UIColor.AppColor.dashBorder, lineLength: NSNumber = 3, gapLength: NSNumber = 1, size: CGSize = .zero) {
        for layer in self.layer.sublayers ?? [] {
            if layer.name == "DashBorder" {
                layer.removeFromSuperlayer()
                break
            }
        }
        let color = color.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.name = "DashBorder"
        let frameSize = size == .zero ? self.frame.size : size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [lineLength, gapLength]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    /// Show border around view.
    ///
    /// - Parameters:
    ///   - color: Border color that need to show around view.
    ///   - width: Width of border.
    func showBorder(withColor color: UIColor = .black, width:CGFloat = 1) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    /// Remove border from view.
    func removeBorder() {
        self.layer.borderWidth = 0
    }
}

// MARK: - Extension of UITableView
extension UITableView {
    
    /// Register nib with tableview.
    ///
    /// - Parameters:
    ///   - name: Name of xib file.
    ///   - identifier: Cell reuse identifier for this xib. If this argument don't pass then reuse identifier is same as name of xib file.
    func registerNib(withName name: String, identifier: String = "") {
        let cellIdentifier = identifier.isEmpty ? name : identifier
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    /// Scroll at the top of tableview.
    func scrollToTop() {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    /// Get indexPath for view that is inside in table cell.
    ///
    /// - Parameter view: View from which need to get indexPath.
    /// - Returns: IndexPath of tableview cell. May nil if indexPath not found for this view.
    func indexPathFor(view: UIView) -> IndexPath? {
        if let point = view.superview?.convert(view.center, to: self) {
            return self.indexPathForRow(at: point)
        }
        return nil
    }
    
    func checkAndReloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .none) {
        DispatchQueue.main.async {
            let totalRows = self.numberOfRows(inSection: 0)
            let array = indexPaths.filter({ $0.row < totalRows })
            if !array.isEmpty {
                self.reloadRows(at: array, with: animation)
            }
        }
    }
}

// MARK: - Extension of UITableViewCell
extension UITableViewCell {
    
    /// Set background color of cell on basis of current app mode.
    func setBackgroundColor() {
        let color = currentAppMode == .live ? UIColor.white : .clear
        self.contentView.backgroundColor = color
        self.backgroundColor = color
    }
}

// MARK: - Extension of UICollectionView
extension UICollectionView {
    
    /// Register nib with collectionView.
    ///
    /// - Parameters:
    ///   - name: Name of xib file.
    ///   - identifier: Cell reuse identifier for this xib. If this argument don't pass then reuse identifier is same as name of xib file.
    func registerNib(withName name: String, identifier: String = "") {
        let cellIdentifier = identifier.isEmpty ? name : identifier
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    /// Get indexPath for view that is inside in collectionview cell.
    ///
    /// - Parameter view: View from which need to get indexPath.
    /// - Returns: IndexPath of collectionview cell. May nil if indexPath not found for this view.
    func indexPathFor(view: UIView) -> IndexPath? {
        if let point = view.superview?.convert(view.center, to: self) {
            return self.indexPathForItem(at: point)
        }
        return nil
    }
}


// MARK: - Extension of UITextField
extension UITextField {
    
    /// Check textfield is empty or not.
    var isEmpty: Bool {
        return (self.text ?? "").trim.isEmpty
    }
    
    /// Check textfield have valid mobile no format
    var isValidMobileNo: Bool {
        let pattern = "^\\+[0-9]{1,4} [0-9]{4,6} [0-9]{4,6}$"
        return (self.text ?? "").range(of: pattern, options: .regularExpression) != nil
    }
    
    /// Trimmed extra white space of textfield.
    func trimmed() {
        self.text = self.text?.trim ?? ""
    }
    
    /// Used to set attributed placeholder string.
    ///
    /// - Parameters:
    ///   - color: Color of attributed placeholder.
    ///   - font: Font of attributed placeholder.
    ///   - baselineOffset: Base line offset for attributed placeholder. Default is 0.
    func setAttributedPlaceholder(color: UIColor = UIColor.AppColor.placeHolder, font: UIFont? = nil, baselineOffset: CGFloat = 0) {
        let placeholderFont = font == nil ? UIFont.avenirLTProMediumFont(ofSize: 16) : font!
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor : color, .font : placeholderFont, .baselineOffset : baselineOffset])
    }
    
    /// Add left padding with textField.
    ///
    /// - Parameter width: Width of padding view.
    func addLeftPadding(withWidth width: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
        view.isUserInteractionEnabled = false
        self.leftView = view
        self.leftViewMode = .always
    }
    
    /// Add right padding with textField.
    ///
    /// - Parameter width: Width of padding view.
    func addRightPadding(withWidth width: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
        view.isUserInteractionEnabled = false
        self.rightView = view
        self.rightViewMode = .always
    }
    
    override open func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if ((action == #selector(UIResponderStandardEditActions.paste(_:)) || (action == #selector(UIResponderStandardEditActions.cut(_:)))) && (self.inputView is UIPickerView || self.inputView is UIDatePicker)) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
}

// MARK: - Extension of UIButton
extension UIButton {
    
    /// Set title of button without animation.
    ///
    /// - Parameters:
    ///   - title: Title of button.
    ///   - state: UIControl state that uses the specified title. Default is .normal.
    func setTitleWithoutAnimation(_ title: String?, for state: UIControl.State = .normal) {
        UIView.performWithoutAnimation({
            self.setTitle(title, for: state)
            self.layoutIfNeeded()
        })
    }
}

// MARK: - Extension of UIBarButtonItem
extension UIBarButtonItem {
    
    /// Set attributed title with bar button item.
    ///
    /// - Parameters:
    ///   - font: Font for attributed title. Default is AvenirLTPro-Medium with size 16.
    ///   - color: Text color for attributed title. Default is UIColor.AppColor.placeHolder.
    func setAttributedTitle(withFont font: UIFont = UIFont.avenirLTProMediumFont(ofSize: 16), color: UIColor = UIColor.AppColor.placeHolder) {
        let attributes: [NSAttributedString.Key : Any] = [.font : font, .foregroundColor : color]
        self.setTitleTextAttributes(attributes, for: .normal)
        self.setTitleTextAttributes(attributes, for: .highlighted)
    }
}

// MARK: - Extension of UILabel
extension UILabel {
    
    /// Check AnimatedTextInput field is empty or not.
    var isEmpty: Bool {
        return (self.text ?? "").trim.isEmpty
    }
    
    var canCall: Bool {
        let numner = (self.text?.trim ?? "").replace(" ", with: "")
        let isNumeric = numner.replace("+", with: "").isNumeric
        guard !numner.isEmpty, isNumeric, let phoneUrl = URL(string: "telprompt:\(numner)") else {
            return false
        }
        return UIApplication.shared.canOpenURL(phoneUrl)
    }
    
    func needToShowMoreButton(width: CGFloat, approxHeight: CGFloat) -> Bool {
        let font = self.font ?? UIFont.avenirLTProMediumFont(ofSize: 17)
        let sizeConstraint = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let attributedText = NSAttributedString(string: self.text ?? "", attributes: [.font: font])
        let boundingRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        return boundingRect.size.height > approxHeight
    }
    
    func setUpLabel() {
        self.attributedText = nil
        self.text = nil
    }
    
    func setLabelWith(text: String?, attributedText: NSAttributedString?, searchActive: Bool = true) {
        if searchActive, let attributedText = attributedText {
            self.text = nil
            self.attributedText = attributedText
        }
        else {
            self.attributedText = nil
            self.text = text
        }
    }
}

// MARK: - Extension of MediaBrowser
extension MediaBrowser {
    
    /// Set up media browser to browse media.
    ///
    /// - Parameters:
    ///   - delegate: Delegate of MediaBrowserDelegate.
    ///   - index: Current index from where need to browse images.
    /// - Returns: Navigation controller with MediaBrowser as rootViewController.
    class func mediaBrowser(withDelegate delegate: MediaBrowserDelegate, index: Int = 0) -> UINavigationController {
        let browser = MediaBrowser(delegate: delegate)
        browser.displayActionButton = false
        browser.enableGrid = false
        browser.enableSwipeToDismiss = false
        browser.loadingIndicatorShouldShowValueText = false
        browser.autoPlayOnAppear = true
        browser.setCurrentIndex(at: index)
        let nc = UINavigationController.init(rootViewController: browser)
        nc.modalTransitionStyle = .crossDissolve
        nc.modalPresentationStyle = .fullScreen
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return nc
    }
}

// MARK: - Extension of SVProgressHUD
extension SVProgressHUD {
    class func checkAndShow(_ needToShow: Bool) {
        if needToShow {
            SVProgressHUD.show()
        }
    }
    
    class func checkAndDismiss(_ needToHide: Bool) {
        if needToHide {
            SVProgressHUD.dismiss()
        }
    }
}

// MARK: - Extension of AnimatedTextInput
extension AnimatedTextInput {
    
    var isTappableField: Bool {
        return self.animatedTxtField?.isUserInteractionEnabled == false && self.tapAction != nil
    }
    
    /// Check AnimatedTextInput field is empty or not.
    var isEmpty: Bool {
        return (self.text ?? "").trim.isEmpty
    }
    
    /// Check input of field is valid email or not.
    var isValidEmail: Bool {
        return (self.text ?? "").isValidEmail
    }
    
    /// Check input of field is valid name or not.
    var isValidName: Bool {
        return (self.text ?? "").rangeOfCharacter(from: .letters) != nil
    }
    
    /// Check textfield have valid mobile no format
    var isValidMobileNo: Bool {
        let pattern = "^\\+[0-9]{1,4} [0-9]{4,6} [0-9]{4,6}$"
        return (self.text ?? "").range(of: pattern, options: .regularExpression) != nil
    }
    
    var haveJapValue: Bool {
        return self.text?.detectLanguage?.lowercased() == "japanese"
    }
    
    /// Trimmed extra white space of text field.
    func trimmed() {
        self.text = self.text?.trim ?? ""
    }
    
    /// Make field disable, so user cannot edit value.
    ///
    /// - Parameter clearLineColor: Line color should be made with clear color or not. Default is false.
    func makeFieldDisable(clearLineColor: Bool = false, bottomMargin: CGFloat = 2) {
        var textInputStyle = clearLineColor ? THGTextInputStyle(lineColor: .clear, bottomMargin: bottomMargin) : THGTextInputStyle(bottomMargin: bottomMargin)
        textInputStyle.textInputFontColor = UIColor.black.withAlphaComponent(0.3)
        textInputStyle.placeholderInactiveColor = UIColor.black.withAlphaComponent(0.3)
        self.style = textInputStyle
        self.isEnabled = false
    }
    
    /// Make field enable, so user can edit value.
    func makeFieldEnable(bottomMargin: CGFloat = 2) {
        self.style = bottomMargin != 2 ? THGTextInputStyle(bottomMargin: bottomMargin) : THGTextInputStyle()
        self.isEnabled = true
    }
    
    func setInputView(_ view: UIView?) {
        self.configureInputView(inputView: view)
        self.clearButtonMode = .never
    }
    
    func removeInputView() {
        self.configureInputView(inputView: nil)
        self.clearButtonMode = .whileEditing
    }
    
    func checkForValidName(showError: Bool, message: String) -> Bool {
        if !self.isEmpty && !self.isValidName {
            if showError { self.showErrorOnPlaceHolder(error: message)}
            return false
        }
        return true
    }
    
    func showAndEnableField(from field: AnimatedTextInput) {
        self.isHidden = field.isHidden
        self.style = field.style
        self.isEnabled = field.isEnabled
        self.type = field.type
        self.configureInputView(inputView: field.animatedTxtField?.inputView)
    }
    
    func updateFieldRequirement(to require: Bool) {
        self.isRequiredField = require
        let value = self.text
        let placeHolder = self.placeHolderText
        self.placeHolderText = placeHolder
        self.text = value
    }
}

// MARK: - Extension of TagListView
extension TagListView {
    
    /// Set default configuration of TagListView.
    func setDefaultConfiguration() {
        self.textFont = UIFont.avenirLTProMediumFont(ofSize: 13)
        self.textColor = .white
        self.tagBackgroundColor = .black
        self.cornerRadiusOfView = 12
        self.paddingY = 6
        self.paddingX = 10
        self.marginX = 8
        self.marginY = 8
        self.enableRemoveButton = true
        self.removeButtonIconSize = 7
        self.removeIconLineWidth = 1.2
        self.removeIconLineColor = .white
    }
    
    /// Set tag background color to black and text color to white.
    func setBlackBackgroundColor() {
        self.tagBackgroundColor = .black
        self.textColor = .white
    }
    
    /// Set tag background color to light gray and text color to dark gray.
    func setGrayBackgroundColor() {
        self.tagBackgroundColor = UIColor.AppColor.notApplicableBG
        self.textColor = UIColor.AppColor.notApplicableText
    }
}

// MARK: - Extension of UIImage
extension UIImage {
    
    static var cartPlusImage: UIImage {
        let isTrayEmpty = ThgCEM.shared.productsInTray.isEmpty
        let imageName = isTrayEmpty ? "ic_cart" : "ic_cart_plus_\(ThgCEM.shared.productsInTray.count)"
        return UIImage(named: imageName)!
    }
    
    static var cartItemImage: UIImage {
        return UIImage(named: "ic_cart_item_\(ThgCEM.shared.productsInTray.count)")!
    }
    
    /// Compressed image by making some transformation on basis of image orientation.
    ///
    /// - Returns: Comprassed image object. May be nil if failed to comprassed.
    func compressedImage() -> UIImage? {
        guard let imgRef = self.cgImage else {
            return nil
        }
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var transform: CGAffineTransform = .identity
        let imageSize = CGSize(width: width, height: height)
        
        let scaleRatio = bounds.size.width / width
        var boundHeight: CGFloat = 0.0
        let orient = self.imageOrientation
        switch orient {
        case .up /*EXIF = 1 */:
            transform = .identity
        case .upMirrored /*EXIF = 2 */:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .down /*EXIF = 3 */:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: .pi)
        case .downMirrored /*EXIF = 4 */:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case .leftMirrored /*EXIF = 5 */:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * .pi / 2.0)
        case .left /*EXIF = 6 */:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * .pi / 2.0)
        case .rightMirrored /*EXIF = 7 */:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right /*EXIF = 8 */:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: .pi / 2.0)
        @unknown default:
            break
        }
        UIGraphicsBeginImageContext(bounds.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .right || orient == .left {
            context?.scaleBy(x: -scaleRatio, y: scaleRatio)
            context?.translateBy(x: -height, y: 0)
        } else {
            context?.scaleBy(x: scaleRatio, y: -scaleRatio)
            context?.translateBy(x: 0, y: -height)
        }
        
        context?.concatenate(transform)
        
        UIGraphicsGetCurrentContext()?.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCopy
    }
    
    /// Compressed image using vImage.
    ///
    /// - Parameter size: Size of compressed image.
    /// - Returns: Comprassed image object. May be nil if failed to comprassed.
    func resizeVI(size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate()
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        return resizedImage
    }
    
    /// Encode image to base64 string.
    ///
    /// - Returns: Base64 encoded string data.
    func encodeToBase64String() -> String {
        let pngData = self.pngData()
        let jpegData = self.jpegData(compressionQuality: 0.9)
        if let data = jpegData {
            return data.base64EncodedString(options: .lineLength64Characters)
        }
        if let data = pngData {
            return data.base64EncodedString(options: .lineLength64Characters)
        }
        return ""
    }
    
    /// Resiz image and reduce its dimension.
    ///
    /// - Parameter percentage: Reduce dimesion in percentage(0 to 1).
    /// - Returns: Resized image.
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Generate thumbnail of image with specific size.
    ///
    /// - Parameter targetSize: Size of thumbnail.
    /// - Returns: Return newly generate thumbnail of image.
    func thumbnailImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Save image in repair directory of document direcotry.
    ///
    /// - Returns: Return URL of location where image is saved.
    func saveImageInRepairDirectory() -> URL? {
        guard let repairDirectory = FileManager.checkAndCreateRepairDirectory() else { return nil }
        let imageName = Date().timeStampString
        do {
            if let data = self.jpegData(compressionQuality: 0.9) {
                let url = repairDirectory.appendingPathComponent(imageName + ".jpg")
                try data.write(to: url)
                return url
            }
            else if let data = self.pngData() {
                let url = FileManager.documentDirectoryURL.appendingPathComponent(imageName + ".png")
                try data.write(to: url)
                return url
            }
            return nil
        }
        catch {
            return nil
        }
    }
}

// MARK: - Extension of FileManager
extension FileManager {
    
    /// Document directory URL of application.
    static var documentDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// Clear all files of temp directory.
    func clearTempDirectory() {
        let urls = (try? contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil)) ?? []
        urls.forEach {
            try? removeItem(at: $0)
        }
    }
    
    /// Create repair directory in Document directory if not exist.
    ///
    /// - Returns: Return URL of repair directory.
    static func checkAndCreateRepairDirectory() -> URL? {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("RepairImages")
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
                return url
            } catch {
                return nil
            }
        }
        else {
            return url
        }
    }
    
    /// Clear all files of repair directory.
    func clearRepairDirectory() {
        let urls = (try? contentsOfDirectory(at: FileManager.documentDirectoryURL.appendingPathComponent("RepairImages"), includingPropertiesForKeys: nil)) ?? []
        urls.forEach {
            try? removeItem(at: $0)
        }
    }
}

// MARK: - Extension of UIFont
extension UIFont {
    
    /// Get avenir pro medium font with specific size.
    ///
    /// - Parameter size: Font size.
    /// - Returns: AvenirLTPro-Medium font.
    class func avenirLTProMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirLTPro-Medium", size: size)!
    }
    
    /// Get Noto JP Regular font with specific size.
    ///
    /// - Parameter size: Font size.
    /// - Returns: NotoSansJP-Regular font.
    class func notoJPRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansJP-Regular", size: size)!
    }
    
}

// MARK: - Extension of UIColor
extension UIColor {
    
    /// Struct of Custom color that is used in application.
    struct AppColor {
        static let placeHolder = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        static let textColor = #colorLiteral(red: 0.1725490196, green: 0.1960784314, blue: 0.2117647059, alpha: 1)
        static let bottomLine = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        static let imageBorder = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        static let converted = #colorLiteral(red: 0.137254902, green: 0.7764705882, blue: 0.2901960784, alpha: 1)
        static let requiredField = #colorLiteral(red: 1, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        static let new = #colorLiteral(red: 0.9607843137, green: 0.1019607843, blue: 0.1215686275, alpha: 1)
        static let recycled = #colorLiteral(red: 0.2039215686, green: 0.4901960784, blue: 0.9725490196, alpha: 1)
        static let selectedRelatedTab = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
        static let inProcess = #colorLiteral(red: 1, green: 0.6666666667, blue: 0.0431372549, alpha: 0.96)
        static let awaitingReply = #colorLiteral(red: 1, green: 0.8509803922, blue: 0.0431372549, alpha: 1)
        static let pending = #colorLiteral(red: 1, green: 0.6549019608, blue: 0, alpha: 1)
        static let closed = #colorLiteral(red: 0.2, green: 0.4901960784, blue: 0.9725490196, alpha: 1)
        static let cancel = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        static let no = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        static let rsvp = #colorLiteral(red: 0.1294117647, green: 0.5333333333, blue: 0.007843137255, alpha: 1)
        static let pendingButton = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        static let dashBorder = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.5960784314, alpha: 1)
        static let attended = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        static let notAttended = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        static let highlightBG = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.7333333333, alpha: 1)
        static let notApplicableBG = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        static let notApplicableText = #colorLiteral(red: 0.6352941176, green: 0.6352941176, blue: 0.6352941176, alpha: 1)
        static let eventGuestTagVIP =  #colorLiteral(red: 0.7450980392, green: 0.6039215686, blue: 0.231372549, alpha: 1)
        static let eventGuestTagMEDIA =  #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        static let notificationUnreadBG =  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        static let greenBorder = #colorLiteral(red: 0, green: 0.5803921569, blue: 0, alpha: 1)
    }
    
    struct Hex {
        static let placeHolder = "#707070"
        static let text = "#2C3236"
    }
    
    var hexCode: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// MARK: - Extension of Notification
extension Notification {
    static let showFloatingButton = Notification.Name("ShowFloatingButton")
    static let appEnterForeground = Notification.Name("AppEnterForeground")
    static let userUpdated = Notification.Name("UserUpdated")
    static let moduleAdded = Notification.Name("ModuleAdded")
    static let moduleUpdated = Notification.Name("ModuleUpdated")
    static let moduleDeleted = Notification.Name("ModuleDeleted")
    static let employeeUpdated = Notification.Name("EmployeeUpdated")
    static let brandUpdated = Notification.Name("BrandUpdated")
    static let newProspectAdded = Notification.Name("NewProspectAdded")
    static let prospectUpdated = Notification.Name("ProspectUpdated")
    static let prospectConverted = Notification.Name("ProspectConverted")
    static let prospectDeleted = Notification.Name("ProspectDeleted")
    static let newClientAdded = Notification.Name("NewClientAdded")
    static let clientUpdated = Notification.Name("ClientUpdated")
    static let updateClientCell = Notification.Name("UpdateClientCell")
    static let clientDeleted = Notification.Name("ClientDeleted")
    static let newAddressAdded = Notification.Name("NewAddressAdded")
    static let addressUpdated = Notification.Name("AddressUpdated")
    static let newRepairAdded = Notification.Name("NewRepairAdded")
    static let repairUpdated = Notification.Name("RepairUpdated")
    static let repairCentreUpdated = Notification.Name("RepairCentreUpdated")
    static let newQuotationAdded = Notification.Name("NewQuotationAdded")
    static let quotationUpdated = Notification.Name("QuotationUpdated")
    static let newRepairAckAdded = Notification.Name("NewRepairAckAdded")
    static let newEnquiryAdded = Notification.Name("NewEnquiryAdded")
    static let enquiryUpdated = Notification.Name("EnquiryUpdated")
    static let newInterestAdded = Notification.Name("NewInterestAdded")
    static let interestUpdated = Notification.Name("InterestUpdated")
    static let newSpecialSaleAdded = Notification.Name("NewSpecialSaleAdded")
    static let specialSaleUpdated = Notification.Name("SpecialSaleUpdated")
    static let newTaskAdded = Notification.Name("NewTaskAdded")
    static let taskUpdated = Notification.Name("TaskUpdated")
    static let newProductCatalogAdded = Notification.Name("ProductCatalogAdded")
    static let productCatalogUpdated = Notification.Name("ProductCatalogUpdated")
    static let eventUpdated = Notification.Name("EventUpdated")
    static let newEventGuestAdded = Notification.Name("NewEventGuestAdded")
    static let eventGuestUpdated = Notification.Name("EventGuestUpdated")
    static let newAccompanyingGuestAdded = Notification.Name("NewAccompanyingGuestAdded")
    static let accompanyingGuestUpdated = Notification.Name("AccompanyingGuestUpdated")
    static let newCallAdded = Notification.Name("NewCallAdded")
    static let callUpdated = Notification.Name("CallUpdated")
    static let newDocumentAdded = Notification.Name("NewDocumentAdded")
    static let documentUpdated = Notification.Name("DocumentUpdated")
    static let newMeetingAdded = Notification.Name("NewMeetingAdded")
    static let meetingUpdated = Notification.Name("MeetingUpdated")
    static let newNoteAdded = Notification.Name("NewNoteAdded")
    static let noteUpdated = Notification.Name("NoteUpdated")
    static let newTransactionAdded = Notification.Name("NewTransactionAdded")
    static let transactionUpdated = Notification.Name("TransactionUpdated")
    static let newProductOwnershipAdded = Notification.Name("NewProductOwnershipAdded")
    static let productOwnershipUpdated = Notification.Name("ProductOwnershipUpdated")
    static let appNotificationUpdated = Notification.Name("AppNotificationUpdated")
}

// MARK: - Extension of Date
extension Date {
    
    /// Check date is today's date or not.
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isWithIn10Min: Bool {
        let minute = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
        return minute <= 10
    }
    
    /// Get maximum birthdate year by decreasing 16 years from current date.
    static var minBirthDateYear: Int {
        let date = Calendar.current.date(byAdding: .year, value: -101, to: Date())!
        return Calendar.current.dateComponents([.year], from: date).year ?? 0
    }
    
    /// Get maximum birthdate year by decreasing 16 years from current date.
    static var maxBirthDateYear: Int {
        let date = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
        return Calendar.current.dateComponents([.year], from: date).year ?? 0
    }
    
    /// Get maximum birthdate by decreasing 16 years from current date.
    static var maxBirthDate: Date? {
        let date = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
        var dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponent.month = 12
        dateComponent.day = 31
        return Calendar.current.date(from: dateComponent)
    }
    
    /// Get time stamp of date as string.
    var timeStampString: String {
        return String(Int(self.timeIntervalSince1970))
    }
    
    /// Get String from date in specific date format using date formatter.
    ///
    /// - Parameter format: Specific date format.
    /// - Returns: String formatted date.
    func getString(in format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// Get String from date in specific date format using date formatter.
    ///
    /// - Parameter format: Specific date format.
    /// - Returns: String formatted date.
    func getString(in df: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = df.format
        return dateFormatter.string(from: self)
    }
    
    /// Get Day month and year from date.
    ///
    /// - Returns: A *tuple* with the day, month and year.
    func getDayMonthYear() -> (day: String, month: String, year: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: self)
        return (day, month, year)
    }
    
    /// Change time in one date from another date using DateComponents.
    ///
    /// - Parameter date: Date from which need to take time.
    /// - Returns: Changed time object of *Date*. May be *nil* if failed to change time.
    func changeTime(withDate date: Date) -> Date? {
        var dateComponent = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let timeComponent = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponent.hour = timeComponent.hour
        dateComponent.minute = timeComponent.minute
        return Calendar.current.date(from: dateComponent)
    }
    
    /// Get date by removing time from the date.
    ///
    /// - Returns: Return date by setting hour, minute and second to *0 (Zero)*.
    func getDateByRemovingTime() -> Date {
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
    
    /// Get formatted time ago string from date.
    ///
    /// - Returns: Formatted time ago string.
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfMonth, .month]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        let dateString = self.getString(in: DateFormat.AppShortDF1)
        
        switch (month, weekOfMonth, day, hour, minute, second) {
        case (let month, _, _, _, _, _) where month >= 2: return dateString
        case (let month, _, _, _, _, _) where month == 1: return "Last month"
        case (_, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth) weeks ago"
        case (_, let weekOfMonth, _, _, _, _) where weekOfMonth == 1: return "Last week"
        case (_, _, let day, _, _, _) where day >= 2: return "\(day) days ago"
        case (_, _, let day, _, _, _) where day == 1: return "a day ago"
        case (_, _, _, let hour, _, _) where hour >= 2: return "\(hour) hours ago"
        case (_, _, _, let hour, _, _) where hour == 1: return "An hour ago"
        case (_, _, _, _, let minute, _) where minute >= 2: return "\(minute) minutes ago"
        case (_, _, _, _, let minute, _) where minute == 1: return "a minute ago"
        case (_, _, _, _, _, let second) where second >= 3: return "\(second) seconds ago"
        default: return "just now"
        }
    }
    
    /// Get formatted time ago string from date.
    ///
    /// - Returns: Formatted time ago string.
    func timeAgoForStatus() -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (self < now ? self : now).getDateByRemovingTime()
        let latest =  (self > now ? self : now).getDateByRemovingTime()
        
        let unitFlags: Set<Calendar.Component> = [.day, .weekOfMonth, .month]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        
        switch (month, weekOfMonth, day) {
        case (let month, _, _) where month > 3: return self.getString(in: DateFormat.AppFullDF1)
        case (let month, _, _) where month == 3: return "3 months ago"
        case (let month, _, _) where month == 2: return "2 months ago"
        case (let month, _, _) where month == 1: return "A month ago"
        case (_, let weekOfMonth, _) where weekOfMonth >= 2: return "\(weekOfMonth) weeks ago"
        case (_, let weekOfMonth, _) where weekOfMonth == 1: return "A week ago"
        case (_, _, let day) where day >= 2: return "\(day) days ago"
        default:
            return (self.isToday ? "Today " : "Yesterday ") + self.getString(in: DateFormat.AppShortDF3)
        }
    }
    
    /// Returns a new Date representing the date calculated by adding an amount of a specific component to a date.
    ///
    /// - Parameters:
    ///   - component: A single component to add.
    ///   - value: The value of the specified component to add.
    /// - Returns: A new calculated date.
    func date(byAdding component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
}

// MARK: - Extension of DateFormat
extension DateFormat {
    static let APIFullDF1 = DateFormat(format: "yyyy-MM-dd'T'HH:mm:ssZ")
    static let APIFullDF2 = DateFormat(format: "yyyy-MM-dd HH:mm:ss")
    static let APIShortDF1 = DateFormat(format: "yyyy-MM-dd")
    static let AppFullDF1 = DateFormat(format: "MMM d, yyyy hh:mm a")
    static let AppShortDF1 = DateFormat(format: "MMM d, yyyy")
    static let AppShortDF2 = DateFormat(format: "MMM d, yyyy (EEE)")
    static let AppShortDF3 = DateFormat(format: "hh:mm a")
}

// MARK: - Extension of Error
extension Error {
    var isCancelledError: Bool {
        return self.localizedDescription.lowercased() == "cancelled"
    }
}

// MARK: - Extension of UserDefaults
extension UserDefaults {
    
    /// Computed property to know user is already login or not.
    static var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.kIsLogin)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIsLogin)
        }
    }
    
    /// Computed property to know user has enabled face id autehntication or not.
    static var isFaceIdAuthenticate: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isFaceIdAuthenticate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFaceIdAuthenticate")
        }
    }
    
    /// Computed property to know user has enabled auto login for face id autehntication or not.
    static var autoLogIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "autoLogIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoLogIn")
        }
    }
    
    /// Computed property to know need to show blank view while face id authentication is on going.
    static var isBlankView: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isBlankView")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isBlankView")
        }
    }
    
    /// Computed property for login user username.
    static var userName: String {
        get {
            return (UserDefaults.standard.string(forKey: "userName") ?? "")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
    }
    
    /// Computed property for login user password for face id login.
    static var userPass: String {
        get {
            return (UserDefaults.standard.string(forKey: "userPass") ?? "")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userPass")
        }
    }
    
    /// Computed property for login user password for face id login.
    static var userPassword: String {
        get {
            if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kEncryptedPassword), let password = CryptoManager.shared.decrypt(data, with: UserDefaults.randomPasswordIV) {
                return password
            }
            return ""
        }
        set {
            UserDefaults.randomPasswordIV = String.randomString(withLength: 16)
            let encryptedPass = newValue.isEmpty ? nil : CryptoManager.shared.encrypt(newValue, with: UserDefaults.randomPasswordIV)
            UserDefaults.standard.set(encryptedPass, forKey: UserDefaultsKey.kEncryptedPassword)
        }
    }
    
    static var randomPasswordIV: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kRandomPasswordIV) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kRandomPasswordIV)
        }
    }
    
    /// Computed property for already login user response.
    static var loginUser: OAuthUser? {
        get {
            if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kLoginUser), let oauthUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? OAuthUser {
                return oauthUser
            }
            return nil
        }
        set {
            if let oauthUser = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: oauthUser)
                UserDefaults.standard.set(data, forKey: UserDefaultsKey.kLoginUser)
            }
            else {
                UserDefaults.standard.set(nil, forKey: UserDefaultsKey.kLoginUser)
            }
        }
    }
    
    static var language: Language {
        get {
            if let lang = UserDefaults.standard.string(forKey: UserDefaultsKey.kCurrentLanguage), let language = Language(rawValue: lang) {
                return language
            }
            else {
                //Set Default Language and return
                UserDefaults.standard.set(Language.en.rawValue, forKey: UserDefaultsKey.kCurrentLanguage)
                return .en
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKey.kCurrentLanguage)
        }
    }
    
    /// Get user profile dictionary form UserDefaults.
    ///
    /// - Returns: Optional Dictionary of User profile.
    static func getUserProfileDictionary() -> [String:Any]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kUserProfile), let dic = data.jsonResponse as? [String:Any] else {
            return nil
        }
        return dic
    }
    
    /// Set user profile dictionary in UserDefaults.
    ///
    /// - Parameter dict: Dictionary of user profile.
    static func saveUserProfileDictionary(dict: [String:Any]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kUserProfile)
    }
    
    /// Get app list string dictionary of all key/value selection options from UserDefaults.
    ///
    /// - Returns: Optional Dictionary of app list string.
    static func getAppListStringsDictionary() -> [String:Any]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kAppListStrings), let dic = data.jsonResponse as? [String:Any] else {
            return nil
        }
        return dic
    }
    
    /// Set app list string dictionary of all key/value selection options in UserDefaults.
    ///
    /// - Parameter dict: Dictionary of app list string.
    static func saveAppListStringsDictionary(dict: [String:Any]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kAppListStrings)
    }
    
    /// Get japanese app list string dictionary of all key/value selection options from UserDefaults.
    ///
    /// - Returns: Optional Dictionary of app list string.
    static func getJapaneseAppListStringsDictionary() -> [String:Any]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kJapAppListStrings), let dic = data.jsonResponse as? [String:Any] else {
            return nil
        }
        return dic
    }
    
    /// Set japanese app list string dictionary of all key/value selection options in UserDefaults.
    ///
    /// - Parameter dict: Dictionary of app list string.
    static func saveJapaneseAppListStringsDictionary(dict: [String:Any]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kJapAppListStrings)
    }
    
    /// Get keys order dictionary of all key/value selection options from UserDefaults.
    ///
    /// - Returns: Optional Dictionary of keys order dictionary.
    static func getAppListKeysOrderDictionary() -> [String:Any]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kAppListKeysOrder), let dic = data.jsonResponse as? [String:Any] else {
            return nil
        }
        return dic
    }
    
    /// Set keys order dictionary of all key/value selection options in UserDefaults.
    ///
    /// - Parameter dict: Dictionary of keys order.
    static func saveAppListKeysOrderDictionary(dict: [String:Any]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kAppListKeysOrder)
    }
    
    static func getModStringDictionary() -> [String:Any]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kModStrings), let dic = data.jsonResponse as? [String:Any] else {
            return nil
        }
        return dic
    }
    
    static func saveModStringDictionary(dict: [String:Any]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kModStrings)
    }
    
    static func getAppStringDictionary() -> [String:Any]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kAppStrings), let dic = data.jsonResponse as? [String:Any] else {
            return nil
        }
        return dic
    }
    
    static func saveAppStringDictionary(dict: [String:Any]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kAppStrings)
    }
    
    
    /// Get app list string dictionary of all key/value selection options from UserDefaults.
    ///
    /// - Returns: Optional Dictionary of app list string.
    static func getDocumentSubcategoryDictionary() -> [String:[String]]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kDocumentSubcategoryId), let dic = data.jsonResponse as? [String:[String]] else {
            return nil
        }
        return dic
    }
    
    /// Set app list string dictionary of all key/value selection options in UserDefaults.
    ///
    /// - Parameter dict: Dictionary of app list string.
    static func saveDocumentSubcategoryDictionary(dict: [String:[String]]?) {
        UserDefaults.standard.set(dict?.jsonData, forKey: UserDefaultsKey.kDocumentSubcategoryId)
    }
    
    static func getAppCurrencyList() -> [Currency]? {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.kCurrencyList), let currencies = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Currency] {
            return currencies
        }
        return nil
    }
    
    static func saveAppCurrencyList(array:[Currency]?) {
        if let array = array {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(data, forKey: UserDefaultsKey.kCurrencyList)
        }
        else {
            UserDefaults.standard.set(nil, forKey: UserDefaultsKey.kCurrencyList)
        }
    }
}

// MARK: - Extension of Bundle
extension Bundle {
    var appVersion: String {
        return self.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
    }
}

// MARK: - Extension of Int
extension Int {
    static let homeTab = 0
    static let searchTab = 1
    static let scanTab = 2
    static let notificationTab = 3
    static let dailyWalkinTab = 4
}

// MARK: - Extension of String
extension String {

    var addJPSalutation: String {
        return ThgCEM.shared.myCompany == .jp && !self.isEmpty ? "\(self) 様" : self
    }
    
    var toUInt8Array: [UInt8] {
        return Array(self.utf8)
    }
    
    var firstWord: String {
        return self.components(separatedBy: " ").first ?? ""
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func replace(_ str: String, with string: String) -> String {
        return self.replacingOccurrences(of: str, with: string)
    }
    
    func replacingCharacters(in range: NSRange, with string: String) -> String {
        return (self as NSString).replacingCharacters(in: range, with: string)
    }
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        guard self.count >= 6 else { return false }
        let upperCaseRegEx = ".*[A-Z].*"
        let upperCaseTest = NSPredicate(format:"SELF MATCHES %@", upperCaseRegEx).evaluate(with: self)
        let lowerCaseRegEx = ".*[a-z].*"
        let lowerCaseTest = NSPredicate(format:"SELF MATCHES %@", lowerCaseRegEx).evaluate(with: self)
        let digitRegEx = ".*[0-9].*"
        let digitTest = NSPredicate(format:"SELF MATCHES %@", digitRegEx).evaluate(with: self)
        return upperCaseTest && lowerCaseTest && digitTest
    }
    
    var isNoPicture: Bool {
        return self.isEmpty || self.lowercased() == "nopicture.jpg"
    }
    
    var ext: String {
        return self.components(separatedBy: ".").last ?? ""
    }
    
    var isImageType: Bool {
        return self.contains("image") || ["png", "jpeg", "jpg"].contains(self.lowercased())
    }
    
    var isVideoType: Bool {
        return self.contains("video") || self == "application/x-mpegURL"
    }
    
    var isImageOrVideoType: Bool {
        return self.contains("image") || self.contains("video") || self == "application/x-mpegURL"
    }
    
    var encodedURLString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var localFileURL: URL? {
        let fileURL = FileManager.documentDirectoryURL.appendingPathComponent(self)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        return nil
    }
    
    var removeStrongTag: String {
        return self.replace("<strong>", with: "").replace("</strong>", with: "")
    }
    
    var addBodyTag: String {
        return "<body>\(self)</body>"
    }
    
    var addStrongTag: String {
        return self.contains("<strong>") ? self : "<strong>\(self)</strong>"
    }
    
    var setSpanTag: String {
        let span = "<span style=\"color: #707070;font-size: 17;font-family: 'AvenirLTPro-Medium';background: #FFE5BB; vertical-align: top; line-height: 17px\">"
        guard self.contains("<strong>") else {
            return span + self + "</span>"
        }
        return self.replace("<strong>", with: span).replace("</strong>", with: "</span>")
    }
    
    var formattedDecimalNumber: String {
        guard let doubleValue = Double(self) else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        guard let num = formatter.string(from: NSNumber(value: doubleValue)) else { return "" }
        return num
    }
    
    var decimalPrice: Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter.number(from: self)?.doubleValue
    }
    
    var multiValues: [String] {
        return self.replace("^", with: "").components(separatedBy: ",")
    }
    
    var detectLanguage: String? {
        if #available(iOS 12.0, *) {
            let recognizer = NLLanguageRecognizer()
            recognizer.processString(self)
            if let languageCode = recognizer.dominantLanguage?.rawValue {
                let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
                return detectedLanguage
            }
        }
        if #available(iOS 11.0, *) {
            guard let languageCode = NSLinguisticTagger.dominantLanguage(for: self) else { return nil }
            let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)            
            return detectedLanguage
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    var generateProductId: String {
        return self.replacingOccurrences(of: "[%&#?=^~ ]", with: "", options: .regularExpression) + "V13"
    }
    
    static func randomString(withLength length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func ifEmpty(set value: String) -> String {
        return self.isEmpty ? value : self
    }
    
    func getRelatedModuleLink(forModule module: Module) -> Module? {
        var modules = Module.allCases
        if let index = modules.firstIndex(of: module) {
            modules.remove(at: index)
        }
        for mod in modules {
            let stringModule = mod.rawValue.replacingOccurrences(of: "thg_", with: "")
            let linkName = mod.relatedLinkName
            if self.localizedCaseInsensitiveContains(stringModule) || self.localizedCaseInsensitiveContains(linkName){
                return mod
            }
        }
        if self == "secondary_contact" {
            return .client
        }
        return nil
    }
    
    func getDate(fromFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func getDate(fromFormat df: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = df.format
        return dateFormatter.date(from: self)
    }
    
    func convertDate(fromFormat format1: String, to format2: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format1
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = format2
        return dateFormatter.string(from: date)
    }
    
    func convertDate(fromFormat format: DateFormat, to toFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.format
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = toFormat.format
        return dateFormatter.string(from: date)
    }
    
    func formattedPhoneNumber(for country: PhoneCountry) -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in country.numberFormatter where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        if cleanPhoneNumber.count > country.minDigitsCount {
            result += " \(cleanPhoneNumber[index..<cleanPhoneNumber.endIndex])"
        }
        return result
    }
    
    func formattedCurrency(symbol: String = ThgCEM.shared.currencySymbol) -> String {
        let double = Double(self) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ThgCEM.shared.groupingSeparator
        formatter.decimalSeparator = ThgCEM.shared.decimalSeparator
        let decimalPrecision = ThgCEM.shared.decimalPrecision
        formatter.maximumFractionDigits = decimalPrecision
        formatter.minimumFractionDigits = decimalPrecision
        guard let formattedNum = formatter.string(from: NSNumber(value: double)) else {
            return symbol + "0".formattedCurrencyNumber()
        }
        return symbol + formattedNum
    }
    
    func formattedCurrencyNumber() -> String {
        let double = Double(self) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ThgCEM.shared.groupingSeparator
        formatter.decimalSeparator = ThgCEM.shared.decimalSeparator
        let decimalPrecision = ThgCEM.shared.decimalPrecision
        formatter.maximumFractionDigits = decimalPrecision
        formatter.minimumFractionDigits = decimalPrecision
        guard let formattedNum = formatter.string(from: NSNumber(value: double)) else {
            return ""
        }
        return formattedNum
    }
    
    func formattedNumber() -> String {
        let double = Double(self) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: double)) ?? ""
    }
    
    func doubleFromFormattedNumber() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ThgCEM.shared.groupingSeparator
        formatter.decimalSeparator = ThgCEM.shared.decimalSeparator
        let decimalPrecision = ThgCEM.shared.decimalPrecision
        formatter.maximumFractionDigits = decimalPrecision
        formatter.minimumFractionDigits = decimalPrecision
        guard let num = formatter.number(from: self) else {
            return 0.0
        }
        return num.doubleValue
    }
    
    func numberFromFormattedCurrency(symbol: String = ThgCEM.shared.currencySymbol) -> String {
        let value = self.replacingOccurrences(of: symbol, with: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ThgCEM.shared.groupingSeparator
        formatter.decimalSeparator = ThgCEM.shared.decimalSeparator
        let decimalPrecision = ThgCEM.shared.decimalPrecision
        formatter.maximumFractionDigits = decimalPrecision
        formatter.minimumFractionDigits = decimalPrecision
        guard let num = formatter.number(from: value) else {
            return ""
        }
        return String(format: "%.02f", num.doubleValue)
    }

    func getAttributedPlaceholderWithJapString(_ string: String, color: UIColor = UIColor.AppColor.placeHolder, enFontSize: CGFloat, jpFontSize: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: self, attributes: [.foregroundColor : color, .font : UIFont.avenirLTProMediumFont(ofSize: enFontSize)]))
        attributedString.append(NSAttributedString(string: " \(string)", attributes: [.foregroundColor : color, .font : UIFont.notoJPRegularFont(ofSize: jpFontSize)]))
        return attributedString
    }
    
    func getRequiredAttributedString(color: UIColor = UIColor.AppColor.placeHolder, fontSize: CGFloat = DefaultSmallFontSize) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: self, attributes: [.foregroundColor : color, .font : UIFont.avenirLTProMediumFont(ofSize: fontSize)]))
        attributedString.append(NSAttributedString(string: " *", attributes: [.foregroundColor : UIColor.AppColor.requiredField, .font : UIFont.systemFont(ofSize: fontSize)]))
        return attributedString
    }
    
    func getAttributedStringWith(lineSpacing: CGFloat, color: UIColor, forJapLang: Bool = false, fontSize: CGFloat, alignment: NSTextAlignment = .left, baselineOffset: CGFloat = 0) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        let font = forJapLang ? UIFont.notoJPRegularFont(ofSize: fontSize) : UIFont.avenirLTProMediumFont(ofSize: fontSize)
        let attributedString = NSAttributedString(string: self, attributes: [.foregroundColor : color, .font : font, .paragraphStyle : paragraphStyle, .baselineOffset : baselineOffset])
        return attributedString
    }
    
    func getAttributedJapanesePickerOption() -> NSAttributedString {
        let array = self.components(separatedBy: "^")
        let value: (en: String, jp: String) = (array.first ?? "", array.last ?? "")
        let attributedString = NSMutableAttributedString(attributedString: value.en.getAttributedStringWith(lineSpacing: 4, color: .black, fontSize: 17, alignment: .center))
        guard !value.jp.isEmpty && value.en != value.jp else { return attributedString }
        attributedString.append("\n\(value.jp)".getAttributedStringWith(lineSpacing: 4, color: .black, forJapLang: true, fontSize: 15, alignment: .center))
        return attributedString
    }
    
    func getAttributedJapaneseMultiPickerOption() -> NSAttributedString {
        let array = self.components(separatedBy: "^")
        let value: (en: String, jp: String) = (array.first ?? "", array.last ?? "")
        let attributedString = NSMutableAttributedString(attributedString: value.en.getAttributedStringWith(lineSpacing: 4, color: UIColor.AppColor.textColor, fontSize: 17))
        guard !value.jp.isEmpty && value.en != value.jp else { return attributedString }
        attributedString.append("\n\(value.jp)".getAttributedStringWith(lineSpacing: 4, color: UIColor.AppColor.textColor, forJapLang: true, fontSize: 15))
        return attributedString
    }
    
    func getAttributedJapaneseMultiOption(color: UIColor) -> NSAttributedString {
        let array = self.components(separatedBy: "^")
        let value: (en: String, jp: String) = (array.first ?? "", array.last ?? "")
        let attributedString = NSMutableAttributedString(attributedString: value.en.getAttributedStringWith(lineSpacing: 4, color: color, fontSize: 13, alignment: .center))
        guard !value.jp.isEmpty && value.en != value.jp else { return attributedString }
        attributedString.append(" \(value.jp)".getAttributedStringWith(lineSpacing: 4, color: color, forJapLang: true, fontSize: 11, alignment: .center))
        return attributedString
    }
    
    func highlightedHTML(fontSize size: Int = 17, color: String = UIColor.Hex.placeHolder) -> NSAttributedString? {
        let style = "<style>body{margin:0;padding:0;color: \(color);font-family: 'AvenirLTPro-Medium';font-size: \(size)px;font-weight:normal;vertical-align: top;line-height: 17px}strong{background: #FFE5BB;}</style>"
        guard let data = (style + self.addBodyTag).data(using: .utf8) else { return nil }
        guard let attr = try? (NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)) else { return nil }
        return attr
    }
    
    func highlightString(string: String, fontSize: CGFloat = 17, color: UIColor = UIColor.AppColor.placeHolder) -> NSAttributedString {
        let font = UIFont.avenirLTProMediumFont(ofSize: fontSize)
        var attributes: [NSAttributedString.Key : Any] = [.font : font, .foregroundColor : color]
        let attributedStr = NSMutableAttributedString(string: self, attributes: attributes)
        attributes[.backgroundColor] = UIColor.AppColor.highlightBG
        let range = (self as NSString).range(of: string)
        attributedStr.addAttributes(attributes, range: range)
        return attributedStr
    }
    
    func highlightString(strings: [String], fontSize: CGFloat = 17, color: UIColor = UIColor.AppColor.placeHolder) -> NSAttributedString {
        let font = UIFont.avenirLTProMediumFont(ofSize: fontSize)
        var attributes: [NSAttributedString.Key : Any] = [.font : font, .foregroundColor : color]
        let attributedStr = NSMutableAttributedString(string: self, attributes: attributes)
        attributes[.backgroundColor] = UIColor.AppColor.highlightBG
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedStr.addAttributes(attributes, range: range)
        }
        return attributedStr
    }
    
    func highlightString(fontSize: CGFloat = 17, color: UIColor = UIColor.AppColor.placeHolder) -> NSAttributedString {
        let font = UIFont.avenirLTProMediumFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [.font : font, .foregroundColor : color, .backgroundColor: UIColor.AppColor.highlightBG]
        let attributedStr = NSAttributedString(string: self, attributes: attributes)
        return attributedStr
    }
    
    func getStrongValue() -> String? {
        let pattern : String = "<strong>(.*?)</strong>"
        let regexOptions = NSRegularExpression.Options.caseInsensitive
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
            let option = NSRegularExpression.MatchingOptions(rawValue: UInt(0))
            guard let textCheckingResult = regex.firstMatch(in: self, options: option, range: NSMakeRange(0, self.count)) else {
                return nil
            }
            let matchRange : NSRange = textCheckingResult.range(at: 1)
            let match = (self as NSString).substring(with: matchRange)
            return match
        } catch {
            return nil
        }
    }
    
    func getStrongValues() -> [String] {
        let pattern : String = "<strong>(.*?)</strong>"
        let regexOptions = NSRegularExpression.Options.caseInsensitive
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
            let option = NSRegularExpression.MatchingOptions(rawValue: UInt(0))
            let matches = regex.matches(in: self, options: option, range: NSMakeRange(0, self.count))
            var strings = [String]()
            for match in matches {
                let match = (self as NSString).substring(with: match.range(at: 1))
                strings.append(match)
            }
            return strings
        } catch {
            return []
        }
    }
    
    func getAttributedString(withHeadIndent indent: CGFloat, fontSize: CGFloat = 19, color: UIColor = UIColor.AppColor.textColor) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.headIndent = indent
        let font = UIFont.avenirLTProMediumFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [.paragraphStyle : style, .font : font, .foregroundColor : color]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func multiply(by multiplier: Double) -> String {
        return String((Double(self) ?? 0) * multiplier)
    }
    
    func divide(by divider: Double) -> String {
        return String((Double(self) ?? 0) / divider)
    }
    
    func width(withFontSize size: CGFloat) -> CGFloat {
        return self.size(withAttributes: [.font : UIFont.avenirLTProMediumFont(ofSize: size)]).width
    }
    
    func checkFor(create: Bool, and write: Bool) -> Bool {
        if (self.isEmpty && !create) || (!self.isEmpty && !write) {
            return false
        }
        return true
    }
}

// MARK: - Extension of URL
extension URL {
    static let videoMIMETypeDic = [
        "3gpp": "video/3gpp", "3gp": "video/3gpp", "ts": "video/mp2t", "mp4": "video/mp4",
        "mpeg": "video/mpeg", "mpg": "video/mpeg", "mov": "video/quicktime", "webm": "video/webm",
        "flv": "video/x-flv", "m4v": "video/x-m4v", "mng": "video/x-mng", "asx": "video/x-ms-asf",
        "asf": "video/x-ms-asf", "wmv": "video/x-ms-wmv", "avi": "video/x-msvideo"
    ]
    
    var mimeType: String {
        return URL.videoMIMETypeDic[self.pathExtension.lowercased()] ?? "video/quicktime"
    }
    
    var mimeFileType: String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func removeFile() {
        if FileManager.default.fileExists(atPath: self.path) {
            try? FileManager.default.removeItem(at: self)
        }
    }
}

// MARK: - Extension of Dictionary
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var jsonData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self)
        }catch _ {
            return nil
        }
    }
    
    var isSuccess: Bool {
        let dic = self as? [String:Any] ?? [:]
        return dic[kSuccess] as? Bool ?? false
    }
    
    var nextOffset: Int {
        let dic = self as? [String:Any] ?? [:]
        return dic[kNextOffset] as? Int ?? -1
    }
    
    var record: [String:Any] {
        let dic = self as? [String:Any] ?? [:]
        return dic[kRecord] as? [String:Any] ?? [:]
    }
    
    var records: [[String:Any]] {
        let dic = self as? [String:Any] ?? [:]
        return dic[kRecords] as? [[String:Any]] ?? []
    }
    
    var aclDic: [String:Any]? {
        let dic = self as? [String:Any] ?? [:]
        return dic[k_ACL] as? [String:Any]
    }
    
    var fields: [String:[String:String]]? {
        let dic = self as? [String:Any] ?? [:]
        return dic[kFields] as? [String:[String:String]]
    }
    
    func getStrigValue(for key: String) -> String? {
        let dic = self as? [String:Any] ?? [:]
        if let value = dic[key] as? String {
            return value
        }
        else if let value = dic[key] as? Int {
            return String(value)
        }
        return nil
    }
    
    func getIntValue(for key: String) -> Int? {
        let dic = self as? [String:Any] ?? [:]
        if let value = dic[key] as? String {
            return Int(value)
        }
        else if let value = dic[key] as? Int {
            return value
        }
        return nil
    }
    
    subscript(key1: String, key2: String) -> String {
        let dic = self as? [String:Any] ?? [:]
        if let value = dic[key1] as? String {
            return value
        }
        return dic[key2] as? String ?? ""
    }
    
    subscript(permission: Permission) -> Bool {
        let dic = self as? [String:Any] ?? [:]
        if let value = dic[permission.rawValue] as? String, value == keyNo {
            return false
        }
        return true
    }
    
    subscript(module: Module) -> [String:Any]? {
        let dic = self as? [String:Any] ?? [:]
        return dic[module.rawValue] as? [String:Any]
    }
}

// MARK: - Extension of Data
extension Data {
    var jsonResponse: Any? {
        guard let response = try? JSONSerialization.jsonObject(with: self) else {
            return nil
        }
        return response
    }
    
    var sizeInMB: Double {
        return Double(self.count) / (1000 * 1000)
    }
    
    func storeRequestInDocumentDirectory() {
        let url = FileManager.documentDirectoryURL.appendingPathComponent(Date().timeStampString + ".txt")
        try? self.write(to: url)
    }
}

// MARK: - Extension of Module
extension Module {
    var linkImage: UIImage? {
        switch self {
        case .boutique:
            return UIImage(named: "link_boutique")
        case .prospect:
            return UIImage(named: "link_prospect")
        case .client:
            return UIImage(named: "link_client")
        case .repair:
            return UIImage(named: "link_repair")
        case .enquiry:
            return UIImage(named: "link_enquiry")
        case .interest:
            return UIImage(named: "link_interest")
        case .specialSale:
            return UIImage(named: "link_ss")
        case .productCatalog:
            return UIImage(named: "link_pc")
        case .eventChecklist:
            return UIImage(named: "link_event_checklist")
        case .eventGuest:
            return UIImage(named: "link_event_guest")
        case .accompanyingGuest:
            return UIImage(named: "link_accompanying_guest")
        case .productOwnership:
            return UIImage(named: "link_po")
        case .transaction:
            return UIImage(named: "link_transaction")
        case .document:
            return UIImage(named: "link_document")
        case .note:
            return UIImage(named: "link_note")
        case .call:
            return UIImage(named: "link_call")
        case .meeting:
            return UIImage(named: "link_meeting")
        case .task:
            return UIImage(named: "link_task")
        default:
            return UIImage(named: "link_placeholder") 
        }
    }
    
    var title: String? {
        switch self {
        case .boutique:
            return "Boutique"
        case .prospect:
            return "Prospect"
        case .client:
            return "Related\nClient"
        case .repair:
            return  "Repair"
        case .enquiry:
            return  "Enquiry"
        case .interest:
            return "Interest"
        case .specialSale:
            return "Special Sales"
        case .productCatalog:
            return "Product Catalog"
        case .eventChecklist:
            return "link_event_checklist"
        case .eventGuest:
            return "Event Guest"
        case .accompanyingGuest:
            return  "Accompanying Guest"
        case .productOwnership:
            return "Product Ownership"
        case .transaction:
            return "Transaction"
        case .document:
            return "Document"
        case .note:
            return  "Note"
        case .call:
            return "Call"
        case .meeting:
            return  "Meeting"
        case .task:
            return "Task"
        default:
            return ""
            
        }
    }
    
    func check(_ permission: Permission) -> Bool {
        guard !ThgCEM.shared.isAdmin, let aclData = ThgCEM.shared.aclDic[self] else { return true }
        return aclData[.access] && aclData[permission]
    }
    
    func check(_ permission: Permission, for key: String) -> Bool {
        guard !ThgCEM.shared.isAdmin else { return true }
        guard let aclDic = ThgCEM.shared.aclDic[self], let fields = aclDic.fields,
            let value = fields[key] else {
                return true
        }
        return value[permission]
    }
    
    static func getPermissionForRepairWizard() -> Bool {
        guard Module.client.check(.create) else { return false }
        guard Module.client.check(.list) else { return false }
        guard Module.client.check(.view) else { return false }
        guard Module.client.check(.edit) else { return false }
        guard Module.productOwnership.check(.create) else { return false }
        guard Module.productOwnership.check(.list) else { return false }
        guard Module.productOwnership.check(.view) else { return false }
        guard Module.productOwnership.check(.edit) else { return false }
        guard Module.repair.check(.create) else { return false }
        guard Module.repair.check(.view) else { return false }
        return true
    }
}

// MARK: - Extension of FieldType
extension FieldType {
    
    var operators: [FilterOperator] {
        switch (self) {
        case .text, .phone: return [.equals, .starts]
        case .fixNumber: return [.equals]
        case .number: return [.equalTo, .notEqualTo, .gt, .lt, .gte, .lte]
        case .textContains: return [.equals, .containsText]
        case .boolean: return [.is]
        case .selection, .multi: return [.in, .notIn, .empty, .notEmpty]
        case .containsMulti: return [.contains, .notContains]
        case .date: return [.equals, .before, .after, .yesterday, .today, .tomorrow, .last7Days, .next7Days,
                            .last30Days, .next30Days, .lastMonth, .thisMonth, .nextMonth, .lastYear,
                            .thisYear, .nextYear]
        }
    }
}

// MARK: - Extension of FilterOperator
extension FilterOperator {
    
    var disableField: Bool {
        return [.empty, .notEmpty, .yesterday, .today, .tomorrow, .last7Days, .next7Days, .last30Days,
                .next30Days, .lastMonth, .thisMonth, .nextMonth, .lastYear, .thisYear, .nextYear].contains(self)
    }
    
    func filter(forKey key: String, values: [String]) -> [String: Any] {
        //let keys = key.components(separatedBy: ",")
        //[kOR: keys.map({ [$0: values.first ?? ""] })]
        switch (self) {
        case .equals, .equalTo: return [key: values.first ?? ""]
        case .starts: return [key: [kStarts: values.first ?? ""]]
        case .containsText: return [key: [kStarts: "%\(values.first ?? "")%"]]
        case .notEqualTo: return [key: [kNotEquals: values.first ?? ""]]
        case .is: return [key: values.first == "true"]
        case .in: return [key: [kIn: values]]
        case .notIn: return [key: [kNotIn: values]]
        case .contains: return [key: [kContains: values]]
        case .notContains: return [key: [kNotContains: values]]
        case .empty: return [key: [kEmpty: ""]]
        case .notEmpty: return [key: [kNotEmpty: ""]]
        case .before, .lt: return [key: [kLT: values.first ?? ""]]
        case .after, .gt: return [key: [kGT: values.first ?? ""]]
        case .lte: return [key: [kLTE: values.first ?? ""]]
        case .gte: return [key: [kGTE: values.first ?? ""]]
        case .yesterday: return [key: [kDateRange: kYesterday]]
        case .today: return [key: [kDateRange: kToday]]
        case .tomorrow: return [key: [kDateRange: kTomorrow]]
        case .last7Days: return [key: [kDateRange: kLast7Days]]
        case .next7Days: return [key: [kDateRange: kNext7Days]]
        case .last30Days: return [key: [kDateRange: kLast30Days]]
        case .next30Days: return [key: [kDateRange: kNext30Days]]
        case .lastMonth: return [key: [kDateRange: kLastMonth]]
        case .thisMonth: return [key: [kDateRange: kThisMonth]]
        case .nextMonth: return [key: [kDateRange: kNextMonth]]
        case .lastYear: return [key: [kDateRange: kLastYear]]
        case .thisYear: return [key: [kDateRange: kThisYear]]
        case .nextYear: return [key: [kDateRange: kNextYear]]
        default: return [:]
        }
    }
}

// MARK: - Extension of Array of DropDown elements
extension Array where Element: DropDown {
    var addEmptyIfNeeded: [DropDown] {
        var array = self as [DropDown]
        if array.isEmpty { array.append(.empty) }
        return array
    }
    
    var insertEmpty: [DropDown] {
        var array = self as [DropDown]
        if !array.contains(where:{$0.value.isEmpty}) {
            array.insert(.empty, at: 0)
        }
        return array
    }
    
    subscript(value: String?) -> String? {
        guard let wrappedValue = value else { return nil }
        return self.first(where:{ $0.value == wrappedValue })?.key
    }
    
    subscript(value: String?, type: OptionType) -> String? {
        guard let wrappedValue = value else { return nil }
        guard let option = self.first(where:{ $0.value == wrappedValue }) else {return nil}
        switch type {
        case .key: return option.key
        case .value: return option.value
        case .japValue: return option.japDisplayValue
        }
    }
    
    func setWithJapanese(key: String) {
        let dic = ThgCEM.shared.japOptionsDic[key] as? [String:String] ?? [:]
        self.forEach {
            $0.setJapValue(value: dic[$0.key])
        }
    }
    
    func deselectAll() {
        self.forEach { $0.isSelected = false }
    }
}

// MARK: - Extension of Array of UInt8 elements
extension Array where Element == UInt8 {
    var toString: String {
        return String(bytes: self, encoding: .utf8) ?? ""
    }
}

// MARK: - Extension of Array of String elements
extension Array where Element == String {
    var removeEmpty: [String] {
        return self.filter({ !$0.isEmpty })
    }
    
    func joinRemovingEmpty(separator: String) -> String {
        return self.removeEmpty.joined(separator: separator)
    }
}

// MARK: - Extension of Array of NSLayoutConstraint elements
extension Array where Element: NSLayoutConstraint {
    func activate() {
        forEach {
            if !$0.isActive {
                $0.isActive = true
            }
        }
    }
    
    func deactivate() {
        forEach {
            if $0.isActive {
                $0.isActive = false
            }
        }
    }
}

extension Array where Element == UIColor {
    func make(with size: Int) -> [UIColor] {
        var colors = self
        while colors.count < size {
            colors.append(contentsOf: colors)
        }
        return colors
    }
}


// MARK: - Extension of NSLayoutConstraint
extension NSLayoutConstraint {
    /// A helper function to activate layout constraints.
    static func activate(_ constraints: NSLayoutConstraint? ...) {
        for case let constraint in constraints {
            guard let constraint = constraint else {
                continue
            }
            
            (constraint.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
            constraint.isActive = true
        }
    }
}

// MARK: - Extension of DropDown
extension DropDown {
    
    static var booleanValues: [DropDown] {
        return [DropDown(key: "true", value: "True"), DropDown(key: "false", value: "False")]
    }
    
    static var myBoutiques: [DropDown] {
        let dropDowns = ThgCEM.shared.shopsList.filter({ !$0.value.isEmpty }).map({ DropDown(key: $0.key, value: $0.value) }).sorted(by: {$0.key.localizedStandardCompare($1.key) == .orderedAscending})
        return dropDowns.addEmptyIfNeeded
    }
    
    static var allBoutiques: [DropDown] {
        let dropDowns = ThgCEM.shared.boutiqueList.filter({ !$0.value.isEmpty }).map({ DropDown(key: $0.key, value: $0.value) }).sorted(by: {$0.key.localizedStandardCompare($1.key) == .orderedAscending})
        return dropDowns.addEmptyIfNeeded
    }
    
    static var salutations: [DropDown] {
        return DropDown.dropDowns(forKey: kSalutationDom, dictionary: ThgCEM.shared.salutationList)
    }
    
    static var genders: [DropDown] {
        return DropDown.dropDowns(forKey: kGenderList, dictionary: ThgCEM.shared.genderList)
    }
    
    static var wristSizes: [DropDown] {
        return DropDown.dropDowns(forKey: kWristSizeList, dictionary: ThgCEM.shared.wristSizeList)
    }
    
    static var personaTypes: [DropDown] {
        return DropDown.dropDowns(forKey: kPersonaTypeList, dictionary: ThgCEM.shared.personaTypeList)
    }
    
    static var occupations: [DropDown] {
        return DropDown.dropDowns(forKey: kOccupationList, dictionary: ThgCEM.shared.occupationList)
    }
    
    static var leadSources: [DropDown] {
        return DropDown.dropDowns(forKey: kCustomLeadSource, dictionary: ThgCEM.shared.leadSourceList)
    }
    
    static var prospectStatusList: [DropDown] {
        return DropDown.dropDowns(forKey: kLeadStatusDom, dictionary: ThgCEM.shared.leadStatusList)
    }
    
    static var nationalityList: [DropDown] {
        return DropDown.dropDowns(forKey: kNationalityDom, dictionary: ThgCEM.shared.nationalityList)
    }
    
    static var residentialStatusList: [DropDown] {
        return DropDown.dropDowns(forKey: kResidentialStatusList, dictionary: ThgCEM.shared.resStatusList)
    }
    
    static var countryCodeList: [DropDown] {
        return DropDown.dropDowns(forKey: kPhoneCountryCodeList, dictionary: ThgCEM.shared.countryCodeList)
    }
    
    static var countries: [DropDown] {
        return DropDown.dropDowns(forKey: kCountryList, dictionary: ThgCEM.shared.countryList)
    }
    
    static var preferredLanguages: [DropDown] {
        return DropDown.dropDowns(forKey: kLanguagePreferenceList, dictionary: ThgCEM.shared.preferredLangList)
    }
    
    static var passionsList: [DropDown] {
        return DropDown.dropDowns(forKey: kCustomPassionsList, dictionary: ThgCEM.shared.passionsList)
    }
    
    static var interactionChannels: [DropDown] {
        return DropDown.dropDowns(forKey: kInteractionChannelList, dictionary: ThgCEM.shared.interactionChannelList)
    }
    
    static var enquiryTypes: [DropDown] {
        return DropDown.dropDowns(forKey: kEnquiryTypeList, dictionary: ThgCEM.shared.enquiryTypeList)
    }
    
    static var enquiryStatus: [DropDown] {
        return DropDown.dropDowns(forKey: kEnquiryStatusList, dictionary: ThgCEM.shared.enquiryStatusList)
    }
    
    static var enquiryCountries: [DropDown] {
        return DropDown.dropDowns(forKey: kEnquiryCountryList, dictionary: ThgCEM.shared.enquiryCountryList)
    }
    
    static var ssStatusList: [DropDown] {
        return DropDown.dropDowns(forKey: kRequestStatusDom, dictionary: ThgCEM.shared.requestStatusList)
    }
    
    static var reqTypeList: [DropDown] {
        return DropDown.dropDowns(forKey: kRequestTypeDom, dictionary: ThgCEM.shared.requestTypeList)
    }
    
    static var productStatusList: [DropDown] {
        return DropDown.dropDowns(forKey: kProductTemplateStatusDom, dictionary: ThgCEM.shared.productStatusList)
    }
    
    static var docCategoryIdList: [DropDown] {
        return DropDown.dropDowns(forKey: kDocumentCategoryDom, dictionary: ThgCEM.shared.documentCategoryList)
    }
    
    static var docSubcategoryIdList: [DropDown] {
        return DropDown.dropDowns(forKey: kDocumentSubcategoryDom, dictionary: ThgCEM.shared.documentSubcategoryList)
    }
    
    static var itemTypeList: [DropDown] {
        return DropDown.dropDowns(forKey: kItemTypeList, dictionary: ThgCEM.shared.itemTypeList)
    }
    
    static var caseMaterialList: [DropDown] {
        return DropDown.dropDowns(forKey: kMaterialTypeList, dictionary: ThgCEM.shared.materialTypeList)
    }
    
    static var movementList: [DropDown] {
        return DropDown.dropDowns(forKey: kWatchMovementList, dictionary: ThgCEM.shared.watchMovementList)
    }
    
    static var strapTypeList: [DropDown] {
        return DropDown.dropDowns(forKey: kStrapTypeList, dictionary: ThgCEM.shared.strapTypeList)
    }
    
    static var repairStatusList: [DropDown] {
        return DropDown.dropDowns(forKey: kRepairStatusList, dictionary: ThgCEM.shared.repairStatusList)
    }
    
    static var repairSRTypes: [DropDown] {
        return DropDown.dropDowns(forKey: kServiceReqTypeList, dictionary: ThgCEM.shared.serviceReqTypeList)
    }
    
    static var savAdminStatusList: [DropDown] {
        return DropDown.dropDowns(forKey: kCstmSavAdminStatusList, dictionary: ThgCEM.shared.cstmSavAdminStatusList)
    }
    
    static var ackTypes: [DropDown] {
        return DropDown.dropDowns(forKey: kAcknowledgementTypeList, dictionary: ThgCEM.shared.acknowledgementTypeList)
    }
    
    static var eventTypes: [DropDown] {
        return DropDown.dropDowns(forKey: kTHGEventTypeList, dictionary: ThgCEM.shared.eventTypeList)
    }
    
    static func dropDowns(forKey key: String = "", forKeys keys: [String] = [], dictionary: [String:String], emptyCheck: Bool = true) -> [DropDown] {
        let orders = keys.isEmpty ? ThgCEM.shared.orderKeysDic[key] as? [String] ?? [] : keys
        let dropDowns = orders.compactMap({ DropDown(key: $0, optionalValue: dictionary[$0]) })
        return emptyCheck ? dropDowns.addEmptyIfNeeded : dropDowns
    }
    
    static func companySaluation(with extra: String = "") -> [DropDown] {
        var companySaluations = Set(ThgCEM.shared.companySalutationList)
        if !extra.isEmpty, let key = self.salutations.first(where: { $0.value == extra })?.key {
            companySaluations.insert(key)
        }
        return self.salutations.filter({ companySaluations.contains($0.key) }).addEmptyIfNeeded
    }
}
