

import UIKit

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UIImageView Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension  UIImageView {
    func setImageFromURLInGuideCategoryList(url: URL) {
        //        self.image = UIImage.init(named: "")
        //        DispatchQueue.main.async {
        //            self.af_setImage(withURL: url)
        //        }
        let placeHolderImage = UIImage(named: "")
        self.sd_setImage(with: url,
                         placeholderImage: placeHolderImage ,
                         options: kImageOptions,
                         completed: { _, _, _, _ in
        })
    }
    func setImageFromURLInCategoryList(url: URL) {
        //        self.image = UIImage.init(named: "ic_ListViewPlaceHolder")
        //        DispatchQueue.main.async {
        //            self.af_setImage(withURL: url)
        //        }
        let placeHolderImage = UIImage(named: "ic_ListViewPlaceHolder")
        self.sd_setImage(with: url,
                         placeholderImage: placeHolderImage,
                         options: kImageOptions,
                         completed: { image, _, _, _ in
            if image == nil {
                //                url.reamoveImageFromCache()
                self.image = UIImage.init(named: "ic_ListViewPlaceHolder")
            }
        })
    }
    func setImageFromURLInCategoryDetails(url: URL) {
        //        self.image = UIImage.init(named: "ic_ListDetailsPlaceHolder")
        //        DispatchQueue.main.async {
        //            self.af_setImage(withURL: url)
        //        }
        let placeHolderImage = UIImage(named: "ic_ListDetailsPlaceHolder")
        self.sd_setImage(with: url,
                         placeholderImage: placeHolderImage,
                         options: kImageOptions,
                         completed: { image, _, _, _ in
            if image == nil {
                //                url.reamoveImageFromCache()
                self.image = UIImage.init(named: "ic_ListDetailsPlaceHolder")
            }
        })
    }
    func setImageFromURLInCategoryListWithRenderingMode(url: URL) {
        //         self.af_setImage(withURL: url)
        let placeHolderImage = UIImage(named: "")
        self.sd_setImage(with: url,
                         placeholderImage: placeHolderImage,
                         options: kImageOptions,
                         completed: { _, _, _, _ in
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = colorTabTint
        })
    }
    func setImageDataFromURL(data: Data) {
        self.image = UIImage.init(data: data)
    }
}
