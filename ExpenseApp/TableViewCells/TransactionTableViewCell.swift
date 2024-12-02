import UIKit

class TableViewCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class TransactionTableViewCell: TableViewCell {

    private let contentBackgroundView = View(backgroundColor: .systemGray6, cornerRadius: 20.autoSized)
    private let categoryIcon = Image()
    private let categoryLabel = Label(text: "",textColor: .black, font: .systemFont(ofSize: 15.autoSized, weight: .semibold))
    private let descriptionLabel = Label(text: "",textColor: .systemGray, font: .systemFont(ofSize: 15.autoSized))
    private let amountLabel = Label(text: "", font: .systemFont(ofSize: 15.autoSized, weight: .semibold))
    private let dateTimeLabel = Label(text: "", textColor: .systemGray, font:.systemFont(ofSize: 13.autoSized))
    private lazy var editButton: Button = {
        let btn = Button(image: "edit", cornerRadius: 5.autoSized)
        btn.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var deleteButton: Button = {
        let btn = Button(image: "delete", cornerRadius: 5.autoSized)
        btn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return btn
    }()
    var deleteClosure: (() -> Void)?
    var updateClosure: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.isUserInteractionEnabled = false
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
        contentBackgroundView.addSubview(editButton)
        contentBackgroundView.addSubview(deleteButton)
        
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
            
            editButton.topAnchor.constraint(equalTo: categoryIcon.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -30.widthRatio),
            editButton.heightAnchor.constraint(equalToConstant: 25.autoSized),
            editButton.widthAnchor.constraint(equalToConstant: 25.widthRatio),

            deleteButton.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -30.widthRatio),
            deleteButton.heightAnchor.constraint(equalToConstant: 25.autoSized),
            deleteButton.widthAnchor.constraint(equalToConstant: 25.widthRatio),
            deleteButton.bottomAnchor.constraint(equalTo: categoryIcon.bottomAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: categoryIcon.topAnchor, constant: 5.autoSized),
            amountLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5.widthRatio),
            
            dateTimeLabel.topAnchor.constraint(equalTo: deleteButton.topAnchor, constant: 5.autoSized),
            dateTimeLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5.widthRatio),
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
    
    @objc private func deleteTapped() {
        deleteClosure?()
    }
    
    @objc private func updateTapped() {
        updateClosure?()
    }
}
