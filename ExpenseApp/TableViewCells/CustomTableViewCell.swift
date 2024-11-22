import UIKit

class CustomTableViewCell: TableViewCell {
  
    private let contentBackgroundView = View(backgroundColor: .customPurple.withAlphaComponent(0.1), cornerRadius: 20)
    private let categoryIcon = Image()
    private let categoryLabel = Label(text: "",textColor: .customPurple, font: .systemFont(ofSize: 15))
    var selectCategoryType: ((String?, UIImage?) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.getIncomeType(_:)))
        contentBackgroundView.addGestureRecognizer(tap)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(categoryLabel)
        contentBackgroundView.addSubview(categoryIcon)
        
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            contentBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.autoSized),
            
            categoryIcon.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor),
            categoryIcon.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 30.widthRatio),
            categoryIcon.heightAnchor.constraint(equalToConstant: 40.autoSized),
            categoryIcon.widthAnchor.constraint(equalToConstant: 40.widthRatio),
            
            categoryLabel.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 20.autoSized),
            categoryLabel.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -20.autoSized),
            categoryLabel.centerXAnchor.constraint(equalTo: contentBackgroundView.centerXAnchor),
        ])
    }
    
    func configure(text: String, icon: UIImage?) {
        categoryLabel.text = text
        categoryIcon.image = icon
    }
    
    @objc func getIncomeType(_ sender: UITapGestureRecognizer) {
        selectCategoryType?(categoryLabel.text, categoryIcon.image )
    }
}


