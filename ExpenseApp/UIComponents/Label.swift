import UIKit

class Label: UILabel {
    init(text: String, backgroundColor: UIColor = .clear, textColor: UIColor = .white, font: UIFont, numberOfLines: Int = 0, textAlignment : NSTextAlignment = .left, cornerRadius: CGFloat = 0, hidden: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.layer.cornerRadius = cornerRadius
        self.isHidden = hidden
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

