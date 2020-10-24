

import Foundation
import UIKit

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UITableView Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension UITableView {
    func register(nibName: String, withIdentifier identifier: String = "") {
        let cellIdentifier = identifier.isEmpty ? nibName : identifier
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    public func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    func scrollToTop() {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    func scroll(scrollTo: ScrollsTo, animated: Bool) {
        DispatchQueue.main.async {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch scrollTo {
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
            case .bottom:
                if numberOfRows > 0 {
                    //                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    //                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    enum ScrollsTo {
        case top, bottom
    }
    func setCornerRediusTableView(cornerRedius: CGFloat = 5.0) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRedius
    }
    func reloadWithoutAnimation() {
        //        UIView.animate(withDuration: 0, animations: {
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            let lastScrollOffset = self.contentOffset
            self.beginUpdates()
            self.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            self.endUpdates()
            self.layer.removeAllAnimations()
            self.setContentOffset(lastScrollOffset, animated: false)
            UIView.setAnimationsEnabled(true)
        }
        //        }, completion:{ _ in
        //            completion()
        //        })
    }
    func reloadWithoutAnimation(indexPath: IndexPath, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            DispatchQueue.main.async {
                let numberOfRows = self.numberOfRows(inSection: indexPath.section)
                if indexPath.row < numberOfRows {
                    UIView.setAnimationsEnabled(false)
                    self.layer.removeAllAnimations()
                    let lastScrollOffset = self.contentOffset
                    self.beginUpdates()
                    self.reloadRows(at: [indexPath], with: .none)
                    self.endUpdates()
                    self.setContentOffset(lastScrollOffset, animated: false)
                    UIView.setAnimationsEnabled(true)
                }
            }
        }, completion: { _ in
            completion()
        })
    }
    func reloadWithoutAnimationAttractionList(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            //DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            let lastScrollOffset = self.contentOffset
            self.beginUpdates()
            self.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            //self.reloadData()
            self.endUpdates()
            self.layer.removeAllAnimations()
            self.setContentOffset(lastScrollOffset, animated: false)
            UIView.setAnimationsEnabled(true)
            //}
        }, completion: { _ in
            completion()
        })
    }
}
