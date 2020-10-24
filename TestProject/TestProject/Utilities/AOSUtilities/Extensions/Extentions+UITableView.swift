

import Foundation
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
