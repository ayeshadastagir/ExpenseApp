import UIKit

class CardView: UIView {
    
    private let cardImage = Image(cornerRadius: 25)
    private let titleLabel = Label(text: "", textColor: .white, font: .systemFont(ofSize: 15))
    let amountLabel = Label(text: "", font: .systemFont(ofSize: 30, weight: .semibold))
    
    init(backgroundColor: UIColor, cornerRadius: CGFloat = 30, image: String, text: String, amtText: String = "$0") {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.cardImage.image = UIImage(named: image)
        self.titleLabel.text = text
        self.amountLabel.text = amtText
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(cardImage)
        self.addSubview(titleLabel)
        self.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            cardImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cardImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.widthRatio),
            cardImage.widthAnchor.constraint(equalToConstant: 70.widthRatio),
            cardImage.heightAnchor.constraint(equalToConstant: 70.autoSized),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 30.widthRatio),
            
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.autoSized),
            amountLabel.leadingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 30.widthRatio),
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.widthRatio),
        ])
    }
}
