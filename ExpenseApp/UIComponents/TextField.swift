import UIKit

class TextField: UITextField {
    init(textColor: UIColor = .black, textAlignment: NSTextAlignment = .center, borderWidth: CGFloat = 0, font: UIFont, placeholder: String = "", cornerRadius: CGFloat = 0 ,color: CGColor = UIColor.systemGray4.cgColor) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.layer.borderWidth = borderWidth
        self.font = font
        self.text = text
        self.autocorrectionType = .no
        self.placeholder = placeholder
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = color
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextField {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        self.layer.add(animation, forKey: "shake")
    }
}


