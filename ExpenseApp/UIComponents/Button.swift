import UIKit

class Button: UIButton {
    init(title: String = "", image: String = "", backgroundColor: UIColor = .clear, tintColor: UIColor = .white, cornerRadius: CGFloat = 0, fontSize: CGFloat = 15.autoSized) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.setImage(UIImage(named: image), for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(tintColor, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

