import UIKit

class TableViewCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class TransactionTableViewCell: TableViewCell {

    private let contentBackgroundView = View(backgroundColor: .systemGray6, cornerRadius: 20)
    private let categoryIcon = Image()
    private let categoryLabel = Label(text: "",textColor: .black, font: .systemFont(ofSize: 15, weight: .semibold))
    private let descriptionLabel = Label(text: "",textColor: .systemGray, font: .systemFont(ofSize: 15))
    private let amountLabel = Label(text: "", font: .systemFont(ofSize: 15, weight: .semibold))
    private let dateTimeLabel = Label(text: "", textColor: .systemGray, font:.systemFont(ofSize: 13))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(categoryLabel)
        contentBackgroundView.addSubview(categoryIcon)
        contentBackgroundView.addSubview(descriptionLabel)
        contentBackgroundView.addSubview(amountLabel)
        contentBackgroundView.addSubview(dateTimeLabel)
        
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            contentBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.autoSized),
            
            categoryIcon.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor),
            categoryIcon.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20.widthRatio),
            categoryIcon.heightAnchor.constraint(equalToConstant: 60.autoSized),
            categoryIcon.widthAnchor.constraint(equalToConstant: 60.widthRatio),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryIcon.topAnchor, constant: 5.autoSized),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 10.widthRatio),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10.autoSized),
            descriptionLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 10.widthRatio),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -20.autoSized),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 80.widthRatio),
            
            amountLabel.topAnchor.constraint(equalTo: categoryIcon.topAnchor, constant: 5.autoSized),
            amountLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -30.widthRatio),
            
            dateTimeLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 12.autoSized),
            dateTimeLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -30.widthRatio),
        ])
    }
    
    func configure(categoryLabelText: String, descriptionLabelText: String, amountLabelText: String, icon: UIImage?, color: UIColor, date: String) {
        categoryLabel.text = categoryLabelText
        descriptionLabel.text = descriptionLabelText
        amountLabel.text = amountLabelText
        amountLabel.textColor = color
        categoryIcon.image = icon
        dateTimeLabel.text = date
    }
}
