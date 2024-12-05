import UIKit

class TransactionViewController: UIViewController {
    
    private let financialReportLabel = Label(text: "Financial Report", textColor: .customPurple, font: .systemFont(ofSize: 25.autoSized, weight: .semibold), textAlignment: .left)
    private var financialRecords: [FinancialRecord] = []
    private var filteredRecords: [FinancialRecord] = []
    private lazy var searchTextField: TextField = {
        let tf = TextField( textAlignment: .left, font: .systemFont(ofSize: 15.autoSized), placeholder: "Transaction Details", cornerRadius: 15.autoSized, color: UIColor.customPurple.cgColor)
        let PaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20.autoSized, height: tf.frame.height))
        tf.leftView = PaddingView
        tf.leftViewMode = .always
        tf.rightView = PaddingView
        tf.rightViewMode = .always
        tf.isEnabled = false
        tf.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return tf
    }()
    private lazy var transactionsTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.clipsToBounds = true
        tv.isHidden = true
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(financialReportLabel)
        view.addSubview(searchTextField)
        view.addSubview(transactionsTableView)
        
        NSLayoutConstraint.activate([
            financialReportLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.autoSized),
            financialReportLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            financialReportLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            
            searchTextField.topAnchor.constraint(equalTo: financialReportLabel.bottomAnchor, constant: 10.autoSized),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            searchTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            
            transactionsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20.autoSized),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func fetchData() {
        let dbFetching = DatabaseHandling()
        let sortedRecords = dbFetching?.fetchAllFinancialRecords() ?? []
        financialRecords = sortedRecords
        filteredRecords = sortedRecords
        if !financialRecords.isEmpty {
            transactionsTableView.isHidden = false
            searchTextField.alpha = 1
            searchTextField.isEnabled = true
            transactionsTableView.reloadData()
        } else {
            transactionsTableView.isHidden = true
            searchTextField.alpha = 0.5
            searchTextField.isEnabled = false
        }
        transactionsTableView.reloadData()
    }
    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            filteredRecords = financialRecords
            transactionsTableView.reloadData()
            return
        }
        filteredRecords = financialRecords.filter {
            let recordText: String
            switch $0 {
            case .income(let incomeRecord):
                recordText = "\(incomeRecord.category) \(incomeRecord.explanation) \(incomeRecord.amount) \(incomeRecord.date.formattedString() + "$+")"
            case .expense(let expenseRecord):
                recordText = "\(expenseRecord.category) \(expenseRecord.explanation) \(expenseRecord.amount) \(expenseRecord.date.formattedString() + "-$")"
            }
            return recordText.lowercased().contains(searchText.lowercased())
        }
        transactionsTableView.reloadData()
    }


    
    private func deleteRecord(id: UUID, oldValue: String, type: String) {
        let dbHandling = DatabaseHandling()
        if type == "Income" {
            let result = dbHandling?.deleteRecord(type: Income.self, id: id, oldValue: oldValue)
            if result == false {
                let alertController = UIAlertController(
                    title: "Deletion Failed",
                    message: "Expense exceeds total Income, cannot delete this Income Record",
                    preferredStyle: .actionSheet
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
            }
        }
        if type == "Expense" {
            let result = dbHandling?.deleteRecord(type: Expense.self, id: id, oldValue: oldValue)
            if result == true {
                print("Selected Expense record deleted successfully")
            }
        }
        fetchData()
    }
    
    private func selectType(id: UUID, type: String) {
        let alertController = UIAlertController(
            title: "Update Record",
            message: "Choose the type of record you want to update",
            preferredStyle: .actionSheet
        )
        
        if type == "Income" {
            let incomeAction = UIAlertAction(title: "Update Income", style: .default) { [weak self] _ in
                let incomeUpdateVC = IncomeUpdateViewController(recordId: id)
                incomeUpdateVC.modalTransitionStyle = .crossDissolve
                incomeUpdateVC.modalPresentationStyle = .fullScreen
                self?.present(incomeUpdateVC, animated: true, completion: nil)
            }
            alertController.addAction(incomeAction)
        }
        
        if type == "Expense" {
            let expenseAction = UIAlertAction(title: "Update Expense", style: .default) { [weak self] _ in
                let expenseUpdateVC = ExpenseUpdateViewController(recordId: id)
                expenseUpdateVC.modalTransitionStyle = .crossDissolve
                expenseUpdateVC.modalPresentationStyle = .fullScreen
                self?.present(expenseUpdateVC, animated: true, completion: nil)
            }
            alertController.addAction(expenseAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        fetchData()
        transactionsTableView.reloadData()
    }
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        let record = filteredRecords[indexPath.row]
        switch record {
        case .income(let incomeRecord):
            if let iconImage = UIImage(data: incomeRecord.image) {
                cell.configure(
                    categoryLabelText: incomeRecord.category,
                    descriptionLabelText: incomeRecord.explanation,
                    amountLabelText: "+" + incomeRecord.amount.toCurrencyFormat,
                    icon: iconImage,
                    color: .customGreen,
                    date: incomeRecord.date.formattedString()
                )
                cell.deleteClosure = { [weak self] in
                    self?.deleteRecord(id: incomeRecord.id, oldValue: incomeRecord.amount, type: Income.entityName)
                }
                cell.updateClosure = { [weak self] in
                    self?.selectType(id: incomeRecord.id, type: Income.entityName)
                }
            } else {
                print("Failed to convert Data to UIImage")
            }
            return cell
        case .expense(let expenseRecord):
            if let iconImage = UIImage(data: expenseRecord.image) {
                cell.configure(
                    categoryLabelText: expenseRecord.category,
                    descriptionLabelText: expenseRecord.explanation,
                    amountLabelText: "-" + expenseRecord.amount.toCurrencyFormat,
                    icon: iconImage,
                    color: .customRed,
                    date: expenseRecord.date.formattedString()
                )
                cell.deleteClosure = { [weak self] in
                    self?.deleteRecord(id: expenseRecord.id, oldValue: expenseRecord.amount, type: Expense.entityName)
                }
                cell.updateClosure = { [weak self] in
                    self?.selectType(id: expenseRecord.id, type: Expense.entityName)
                }
            } else {
                print("Failed to convert Data to UIImage")
            }
            return cell
        }
    }
}
