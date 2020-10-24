

import UIKit

class MediaBroswerHandler: NSObject {
    var medias = [Media]()
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

extension MediaBroswerHandler: MediaBrowserDelegate {
    
    func thumbnail(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        return medias[index]
    }
    
    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        return medias[index]
    }
    
    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
        return medias.count
    }
    
    func didDisplayMedia(at index: Int, in mediaBrowser: MediaBrowser) {
        
    }
    
    func mediaBrowserDidFinishModalPresentation(mediaBrowser: MediaBrowser) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
        mediaBrowser.dismiss(animated: true)
    }
}
