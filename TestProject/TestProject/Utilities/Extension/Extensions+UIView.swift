
import Foundation
import UIKit

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UIView Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    // OUTPUT 2
    func dropShadow(color: UIColor,
                    opacity: Float = 0.5,
                    offSet: CGSize, radius: CGFloat = 1,
                    scale: Bool = true,
                    shadowRedius: CGFloat = 1 ) {
        self.clipsToBounds = true
        //        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = shadowRedius
        self.layer.cornerRadius = radius
    }
    func dropShadowWithMask(color: UIColor,
                            opacity: Float = 0.5,
                            offSet: CGSize,
                            radius: CGFloat = 1,
                            scale: Bool = true,
                            shadowRedius: CGFloat = 1 ) {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = shadowRedius
        self.layer.cornerRadius = radius
    }
    func setCornerRediusOuterStoryView(borderColor: UIColor, borderWidth: CGFloat = 1.0) {
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.frame.size.height/2
    }
    func setConerRediusUIView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
    }
    func setConerRediusUIView(with redius: CGFloat = 10) {
        self.clipsToBounds = true
        self.layer.cornerRadius = redius
    }
    func topViewController(controller: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    func setUIViewBezierPath(cornerRadius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            //Top [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            //Bottom [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            var path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            if UIDevice.current.model.range(of: "iPad") != nil {
                path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: cornerRadius * 2, height: cornerRadius * 2))
            }
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}
