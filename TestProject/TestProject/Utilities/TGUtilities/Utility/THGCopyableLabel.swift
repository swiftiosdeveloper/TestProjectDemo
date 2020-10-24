

import UIKit

class THGCopyableLabel: UILabel {

    /// Set this property to `true` in order to enable the copy feature. Defaults to `false`.
    @IBInspectable var isCopyingEnabled: Bool = true {
        didSet {
            setupLongPressGesture()
        }
    }
    
    var longPressGesture: UILongPressGestureRecognizer?
    
    var orgTextColor = UIColor.AppColor.textColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfig()
    }
    
    override var canBecomeFirstResponder: Bool {
        return isCopyingEnabled && !self.isEmpty
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard isCopyingEnabled else { return false }
        return action == #selector(copy(_:)) || (action == #selector(makeCall(_:)) && canCall)
    }

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
    func initialConfig() {
        setupLongPressGesture()
    }
    
    func setupLongPressGesture() {
        self.isUserInteractionEnabled = isCopyingEnabled
        if self.isCopyingEnabled {
            self.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(gestureAction))
            self.addGestureRecognizer(self.longPressGesture!)
        }
        else {
            if let gesture = self.longPressGesture {
                self.removeGestureRecognizer(gesture)
            }
        }
    }
    
    func setHighlighting() {
        orgTextColor = self.textColor ?? UIColor.AppColor.textColor
        self.textColor = .red
    }
    
    func removeHighlighting() {
        self.textColor = orgTextColor
    }
    
    @objc func makeCall(_ sender: Any?) {
        
    }
    
    @objc func gestureAction(_ gestureRecognizer: UIGestureRecognizer) {
        guard becomeFirstResponder() else { return }
        let call = UIMenuItem(title: "Call", action: #selector(makeCall))
        UIMenuController.shared.menuItems = [call]
        let menu = UIMenuController.shared
        guard !menu.isMenuVisible else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(menuControllerWillHide), name: UIMenuController.willHideMenuNotification, object: nil)
        setHighlighting()
        menu.setTargetRect(bounds, in: self)
        menu.setMenuVisible(true, animated: true)
        /*if #available(iOS 13.0, *) {
            menu.showMenu(from: self, rect: bounds)
        }
        else {
            // Fallback on earlier versions
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }*/
    }
    
    @objc private func menuControllerWillHide() {
        // Prevent custom menu items from displaying in text view
        removeHighlighting()
        UIMenuController.shared.menuItems = nil
        NotificationCenter.default.removeObserver(self, name: UIMenuController.willHideMenuNotification, object: nil)
    }
}
