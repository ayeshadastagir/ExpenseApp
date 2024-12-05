
import UIKit

class IncomeUpdateViewController: UIViewController {
    private let recordId: UUID
    private var existingIncomeData: IncomeData?
    private let incomeType: [IncomeCategory] = [
        IncomeCategory(icon: "salary", label: "Salary"),
        IncomeCategory(icon: "freelance", label: "Freelance"),
        IncomeCategory(icon: "other", label: "Others"),
    ]
    private let incomeLabelView: View = {
        let v = View(backgroundColor: .customPurple, cornerRadius: 25.autoSized)
        v.layer.borderWidth = 2.autoSized
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()
    private let incomeLabel = Label(text: "Income", textColor: .white, font: .systemFont(ofSize: 25.autoSized, weight: .bold))
    private let howMuchLabel = Label(text: "How much?", textColor: .white.withAlphaComponent(0.5), font: .systemFont(ofSize: 20.autoSized, weight: .semibold))
    private lazy var enterAmountTF: TextField = {
        let tf = TextField(textColor: .white, font: .systemFont(ofSize: 50.autoSized, weight: .bold), placeholder: "Enter Amount")
        tf.layer.borderWidth = 0
        tf.isEnabled = true
        tf.textAlignment = .left
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    private let incomeDetailView = View(cornerRadius: 30.autoSized)
    private lazy var selectCategoryView: CategoryView = {
        let view = CategoryView()
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1.autoSized
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectIncome(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    private let tableBackgroundView: View = {
        let view = View(backgroundColor: .white)
        view.isHidden = true
        return view
    }()
    private lazy var tableView: UITableView = {
        var tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.clipsToBounds = true
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        return tv
    }()
    private lazy var explainationTF: TextField = {
        let tf = TextField(font: .systemFont(ofSize: 15.autoSized), placeholder: "Description", cornerRadius: 25.autoSized)
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    private lazy var updateButton: Button = {
        let btn = Button(title: "UPDATE", backgroundColor: .customGreen, cornerRadius: 25.autoSized)
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(dataUpdated), for: .touchUpInside)
        return btn
    }()
    private var categoryViewHeight: NSLayoutConstraint!
    private var tableBackgroundViewTop: NSLayoutConstraint!
    private var tableViewTop: NSLayoutConstraint!
    private var initialAmount: String?

    init(recordId: UUID) {
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
        fetchExistingRecord()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGreen
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(incomeLabelView)
        view.addSubview(incomeLabel)
        view.addSubview(howMuchLabel)
        view.addSubview(enterAmountTF)
        view.addSubview(incomeDetailView)
        incomeDetailView.addSubview(selectCategoryView)
        selectCategoryView.addSubview(tableBackgroundView)
        tableBackgroundView.addSubview(tableView)
        incomeDetailView.addSubview(explainationTF)
        incomeDetailView.addSubview(updateButton)
        
        NSLayoutConstraint.activate([
            incomeLabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.autoSized),
            incomeLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            incomeLabelView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            incomeLabelView.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            
            incomeLabel.centerXAnchor.constraint(equalTo: incomeLabelView.centerXAnchor),
            incomeLabel.centerYAnchor.constraint(equalTo: incomeLabelView.centerYAnchor),
            
            howMuchLabel.topAnchor.constraint(equalTo: incomeLabel.bottomAnchor, constant: 50.autoSized),
            howMuchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            howMuchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            howMuchLabel.heightAnchor.constraint(equalToConstant: 25.autoSized),
            
            enterAmountTF.topAnchor.constraint(equalTo: howMuchLabel.bottomAnchor, constant: 20.autoSized),
            enterAmountTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            enterAmountTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            enterAmountTF.heightAnchor.constraint(equalToConstant: 70.autoSized),
            
            incomeDetailView.topAnchor.constraint(equalTo: enterAmountTF.bottomAnchor, constant: 100.autoSized),
            incomeDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            incomeDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            incomeDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30.autoSized),
            
            selectCategoryView.topAnchor.constraint(equalTo: incomeDetailView.topAnchor, constant: 40.autoSized),
            selectCategoryView.leadingAnchor.constraint(equalTo: incomeDetailView.leadingAnchor, constant: 25.widthRatio),
            selectCategoryView.trailingAnchor.constraint(equalTo: incomeDetailView.trailingAnchor, constant: -25.widthRatio),
            
            tableBackgroundView.leadingAnchor.constraint(equalTo: selectCategoryView.leadingAnchor),
            tableBackgroundView.trailingAnchor.constraint(equalTo: selectCategoryView.trailingAnchor),
            tableBackgroundView.bottomAnchor.constraint(equalTo: selectCategoryView.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: tableBackgroundView.leadingAnchor, constant: 10.widthRatio),
            tableView.trailingAnchor.constraint(equalTo: tableBackgroundView.trailingAnchor, constant: -10.widthRatio),
            tableView.bottomAnchor.constraint(equalTo: tableBackgroundView.bottomAnchor, constant: -10.autoSized),
            
            explainationTF.topAnchor.constraint(equalTo: selectCategoryView.bottomAnchor, constant: 15.autoSized),
            explainationTF.leadingAnchor.constraint(equalTo: incomeDetailView.leadingAnchor, constant: 25.widthRatio),
            explainationTF.trailingAnchor.constraint(equalTo: incomeDetailView.trailingAnchor, constant: -25.widthRatio),
            explainationTF.heightAnchor.constraint(equalToConstant: 60.autoSized),
            
            updateButton.heightAnchor.constraint(equalToConstant: 60.autoSized),
            updateButton.leadingAnchor.constraint(equalTo: incomeDetailView.leadingAnchor, constant: 25.widthRatio),
            updateButton.trailingAnchor.constraint(equalTo: incomeDetailView.trailingAnchor, constant: -25.widthRatio),
            updateButton.bottomAnchor.constraint(equalTo: incomeDetailView.bottomAnchor, constant: -150.autoSized),
        ])
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 60.autoSized)
        categoryViewHeight.isActive = true
        tableBackgroundViewTop = tableBackgroundView.topAnchor.constraint(equalTo: selectCategoryView.logo.bottomAnchor, constant: 5.autoSized)
        tableViewTop = tableView.topAnchor.constraint(equalTo: tableBackgroundView.topAnchor, constant: 10.autoSized)
    }
    
    private func fetchExistingRecord() {
        let dbHandler = DatabaseHandling()
        existingIncomeData = dbHandler?.fetchSpecificIncome(id: recordId)
        DispatchQueue.main.async {
            self.populateFields()
        }
    }
    
    private func populateFields() {
        guard let incomeData = existingIncomeData else { return }
        enterAmountTF.text = incomeData.amount
        explainationTF.text = incomeData.explanation
        selectCategoryView.didUpdateCategory(
            name: incomeData.category,
            img:  UIImage(data: incomeData.image)
        )
        initialAmount = incomeData.amount
        validateFields()
    }
    
    private func resetUI() {
        categoryViewHeight.isActive = false
        tableViewTop.isActive = false
        tableBackgroundViewTop.isActive = false
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 60.autoSized)
        categoryViewHeight.isActive = true
        selectCategoryView.selectedCategoryLabel.textColor = .black
        updateButton.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func validateFields() {
        let isAmountFilled = !(enterAmountTF.text?.isEmpty ?? true)
        let isCategorySelected = selectCategoryView.selectedCategoryLabel.text != "Category"
        let isDescriptionFilled = !(explainationTF.text?.isEmpty ?? true)
        
        if isAmountFilled && isCategorySelected && isDescriptionFilled  {
            updateButton.isEnabled = true
            updateButton.alpha = 1.0
        } else {
            updateButton.isEnabled = false
            updateButton.alpha = 0.5
        }
        let text = enterAmountTF.text?.toCurrencyFormat
        enterAmountTF.text = text
    }
    
    @objc private func dataUpdated() {
        let dataHandler = DatabaseHandling()
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        let homeScreen = CustomTabBarController()
        homeScreen.modalTransitionStyle = .crossDissolve
        homeScreen.modalPresentationStyle = .fullScreen
        
        let updatedIncome = IncomeData(
            amount: enterAmountTF.text?.justifyNumber ?? "",
            category: selectCategoryView.selectedCategoryLabel.text ?? "",
            explanation: explainationTF.text ?? "",
            image: selectedImage,
            date: existingIncomeData?.date ?? Date(),
            id: recordId )
        if dataHandler?.updateIncome(id: recordId, updatedIncomeData: updatedIncome, oldValue: initialAmount ?? "") == true {
            self.present(homeScreen, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Update Failed",
                message: "Unable to update income record. Expense exceeds income",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.present(homeScreen, animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func selectIncome(_ sender: UITapGestureRecognizer? = nil) {
        categoryViewHeight.isActive = false
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 250.autoSized)
        categoryViewHeight.isActive = true
        
        tableBackgroundView.isHidden = false
        tableBackgroundViewTop.isActive = true
        tableViewTop.isActive = true
        updateButton.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        validateFields()
    }
}

extension IncomeUpdateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell
        let card = incomeType[indexPath.row]
        cell.configure(
            text: card.label,
            icon: UIImage(named: card.icon))
        cell.selectCategoryType = { [weak self] selectedLabelText, img in
            self?.selectCategoryView.didUpdateCategory(
                name: selectedLabelText ?? "",
                img: img)
            self?.resetUI()
        }
        return cell
    }
}
