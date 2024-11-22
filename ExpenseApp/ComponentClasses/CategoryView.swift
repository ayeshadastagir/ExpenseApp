import UIKit

class CategoryView: UIView {
    
    let selectedCategoryLabel = Label(text: "Category",textColor: .systemGray4, font: .systemFont(ofSize: 15))
    let logo = Image(image: "category", cornerRadius: 15)
    private let dropdownImage = Image(image: "dropDown")
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.cornerRadius = 25
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(selectedCategoryLabel)
        self.addSubview(logo)
        self.addSubview(dropdownImage)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.autoSized),
            logo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.widthRatio),
            logo.heightAnchor.constraint(equalToConstant: 40.autoSized),
            logo.widthAnchor.constraint(equalToConstant: 40.widthRatio),
            
            selectedCategoryLabel.topAnchor.constraint(equalTo: logo.topAnchor, constant: 10.autoSized),
            selectedCategoryLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 80.widthRatio),
            selectedCategoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dropdownImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.autoSized),
            dropdownImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.widthRatio),
            dropdownImage.heightAnchor.constraint(equalToConstant: 20.autoSized),
            dropdownImage.widthAnchor.constraint(equalToConstant: 20.widthRatio),
        ])
    }
    
    func didUpdateCategory(name: String, img: UIImage) {
        selectedCategoryLabel.text = name
        logo.image = img 
    }
}



