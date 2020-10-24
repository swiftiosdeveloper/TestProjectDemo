

import Foundation
import UIKit

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
