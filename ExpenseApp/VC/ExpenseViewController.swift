import UIKit

class ExpenseViewController: UIViewController {
    private let expenseType: [ExpenseCategory] = [
        ExpenseCategory(icon: "bill", label: "Bills"),
        ExpenseCategory(icon: "food", label: "Food"),
        ExpenseCategory(icon: "grocery", label: "Grocery"),
        ExpenseCategory(icon: "shop", label: "Shopping"),
        ExpenseCategory(icon: "transport", label: "Transportation"),
        ExpenseCategory(icon: "subs", label: "Subscriptions"),
        ExpenseCategory(icon: "edu", label: "Education"),
        ExpenseCategory(icon: "invest", label: "Investment"),
        ExpenseCategory(icon: "other", label: "Others"),
    ]
    private let expenseLabelView: View = {
        let v = View(backgroundColor: .customPurple, cornerRadius: 25.autoSized)
        v.layer.borderWidth = 2.autoSized
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()
    private let expenseLabel = Label(text: "Expense", textColor: .white, font: .systemFont(ofSize: 25, weight: .bold))
    private let howMuchLabel = Label(text: "How much?", textColor: .white.withAlphaComponent(0.5), font: .systemFont(ofSize: 20.autoSized, weight: .semibold))
    private lazy var enterAmountTF: TextField = {
        let tf = TextField(textColor: .white, font: .systemFont(ofSize: 50.autoSized, weight: .bold), placeholder: "Enter Amount")
        tf.layer.borderWidth = 0
        tf.isEnabled = true
        tf.textAlignment = .left
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(validateAndDatafetching), for: .editingChanged)
        return tf
    }()
    private let expenseDetailView = View(cornerRadius: 30.autoSized)
    private lazy var selectCategoryView: CategoryView = {
        let view = CategoryView()
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1.autoSized
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectExpense(_:)))
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
        tv.showsVerticalScrollIndicator = false
        tv.clipsToBounds = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        return tv
    }()
    private lazy var explainationTF: TextField = {
        let tf = TextField(font: .systemFont(ofSize: 15.autoSized), placeholder: "Description", cornerRadius: 25.autoSized)
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    private lazy var addButton: Button = {
        let btn = Button(title: "ADD", backgroundColor: .customRed, cornerRadius: 25.autoSized)
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(dataSaved), for: .touchUpInside)
        return btn
    }()
    var categoryViewHeight: NSLayoutConstraint!
    var tableBackgroundViewTop: NSLayoutConstraint!
    var tableViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customRed
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(expenseLabelView)
        view.addSubview(expenseLabel)
        view.addSubview(howMuchLabel)
        view.addSubview(enterAmountTF)
        view.addSubview(expenseDetailView)
        expenseDetailView.addSubview(selectCategoryView)
        selectCategoryView.addSubview(tableBackgroundView)
        tableBackgroundView.addSubview(tableView)
        expenseDetailView.addSubview(explainationTF)
        expenseDetailView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            expenseLabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.autoSized),
            expenseLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expenseLabelView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            expenseLabelView.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            
            expenseLabel.centerXAnchor.constraint(equalTo: expenseLabelView.centerXAnchor),
            expenseLabel.centerYAnchor.constraint(equalTo: expenseLabelView.centerYAnchor),
            
            howMuchLabel.topAnchor.constraint(equalTo: expenseLabel.bottomAnchor, constant: 50.autoSized),
            howMuchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            howMuchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            howMuchLabel.heightAnchor.constraint(equalToConstant: 25.autoSized),
            
            enterAmountTF.topAnchor.constraint(equalTo: howMuchLabel.bottomAnchor, constant: 20.autoSized),
            enterAmountTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            enterAmountTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            enterAmountTF.heightAnchor.constraint(equalToConstant: 70.autoSized),
            
            expenseDetailView.topAnchor.constraint(equalTo: enterAmountTF.bottomAnchor, constant: 100.autoSized),
            expenseDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            
            selectCategoryView.topAnchor.constraint(equalTo: expenseDetailView.topAnchor, constant: 40.autoSized),
            selectCategoryView.leadingAnchor.constraint(equalTo: expenseDetailView.leadingAnchor, constant: 25.widthRatio),
            selectCategoryView.trailingAnchor.constraint(equalTo: expenseDetailView.trailingAnchor, constant: -25.widthRatio),
            
            tableBackgroundView.leadingAnchor.constraint(equalTo: selectCategoryView.leadingAnchor),
            tableBackgroundView.trailingAnchor.constraint(equalTo: selectCategoryView.trailingAnchor),
            tableBackgroundView.bottomAnchor.constraint(equalTo: selectCategoryView.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: tableBackgroundView.leadingAnchor, constant: 10.widthRatio),
            tableView.trailingAnchor.constraint(equalTo: tableBackgroundView.trailingAnchor, constant: -10.widthRatio),
            tableView.bottomAnchor.constraint(equalTo: tableBackgroundView.bottomAnchor, constant: -10.autoSized),
            
            explainationTF.topAnchor.constraint(equalTo: selectCategoryView.bottomAnchor, constant: 15.autoSized),
            explainationTF.leadingAnchor.constraint(equalTo: expenseDetailView.leadingAnchor, constant: 25.widthRatio),
            explainationTF.trailingAnchor.constraint(equalTo: expenseDetailView.trailingAnchor, constant: -25.widthRatio),
            explainationTF.heightAnchor.constraint(equalToConstant: 60.autoSized),
            
            addButton.heightAnchor.constraint(equalToConstant: 60.autoSized),
            addButton.leadingAnchor.constraint(equalTo: expenseDetailView.leadingAnchor, constant: 25.widthRatio),
            addButton.trailingAnchor.constraint(equalTo: expenseDetailView.trailingAnchor, constant: -25.widthRatio),
            addButton.bottomAnchor.constraint(equalTo: expenseDetailView.bottomAnchor, constant: -150.autoSized),
            
        ])
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 60.autoSized)
        categoryViewHeight.isActive = true
        tableBackgroundViewTop = tableBackgroundView.topAnchor.constraint(equalTo: selectCategoryView.logo.bottomAnchor, constant: 5.autoSized)
        tableViewTop = tableView.topAnchor.constraint(equalTo: tableBackgroundView.topAnchor, constant: 10.autoSized)
    }
    
    private func resetUI() {
        categoryViewHeight.isActive = false
        tableViewTop.isActive = false
        tableBackgroundViewTop.isActive = false
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 60.autoSized)
        categoryViewHeight.isActive = true
        selectCategoryView.selectedCategoryLabel.textColor = .black
        addButton.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setDefaultValue() {
        enterAmountTF.text = ""
        explainationTF.text = ""
        selectCategoryView.selectedCategoryLabel.text = "Category"
        selectCategoryView.logo.image = UIImage(named: "category")
        selectCategoryView.selectedCategoryLabel.textColor = .systemGray3
    }
    
    @objc func selectExpense(_ sender: UITapGestureRecognizer? = nil) {
        categoryViewHeight.isActive = false
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 250.autoSized)
        categoryViewHeight.isActive = true
        
        tableBackgroundView.isHidden = false
        tableBackgroundViewTop.isActive = true
        tableViewTop.isActive = true
        addButton.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        validateFields()
    }
    
    
    @objc private func validateFields() {
        let isAmountAdded = !(enterAmountTF.text?.isEmpty ?? true)
        let isCategorySelected = selectCategoryView.selectedCategoryLabel.text != "Category"
        let isDescriptionFilled = !(explainationTF.text?.isEmpty ?? true)
        if isAmountAdded && isCategorySelected && isDescriptionFilled {
            addButton.isEnabled = true
            addButton.alpha = 1.0
        } else {
            addButton.isEnabled = false
            addButton.alpha = 0.5
        }
    }
    
    @objc private func validateAndDatafetching() {
        let dbFetching = DatabaseHandling()
        let totalIncome = dbFetching?.totalIncome() ?? 0
        let totalExpense = dbFetching?.totalExpense() ?? 0
        let balance = totalIncome - totalExpense
        let amt = Int(enterAmountTF.text ?? "0" )
        if amt ?? 0 > balance {
            enterAmountTF.shake()
        }
        validateFields()
    }

    @objc private func dataSaved() {
        let dataHandler = DatabaseHandling()
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        let expense = ExpenseData(
            amount: enterAmountTF.text!,
            category: selectCategoryView.selectedCategoryLabel.text!,
            explanation: explainationTF.text!,
            image: selectedImage,
            date: Date(),
            id: UUID()
        )
        if dataHandler?.saveExpense(expenseData: expense) == true {
            setDefaultValue()
            let homeScreen = CustomTabBarController()
            homeScreen.modalTransitionStyle = .crossDissolve
            homeScreen.modalPresentationStyle = .fullScreen
            self.present(homeScreen, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Cannot Add Expense",
                message: "No Income or Expense amount exceeds wallet.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            setDefaultValue()
        }
    }
}

extension ExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell
        let card = expenseType[indexPath.row]
        cell.configure(
            text: card.label,
            icon: UIImage(named: card.icon))
        cell.selectCategoryType = { [weak self] selectedLabelText, img in
            self?.selectCategoryView.didUpdateCategory(
                name: selectedLabelText ?? "",
                img: img!)
            self?.resetUI()
        }
        return cell
    }
}
