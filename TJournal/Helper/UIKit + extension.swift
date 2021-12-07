import UIKit
import Kingfisher

extension UITableViewCell {
    
    static var reuseId: String {
        return String(describing: Self.self)
    }
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
    

    
}

extension UIImageView {
    func loadImage(url: URL) {
        self.kf.setImage(with: url)
    }
}
