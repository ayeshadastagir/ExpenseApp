import UIKit

class Image: UIImageView {
    init(image: String = "", contentMode: UIView.ContentMode = .scaleAspectFit, cornerRadius: CGFloat = 15, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(named: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

