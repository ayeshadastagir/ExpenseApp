import UIKit

class TransactionViewController: UIViewController {
    
    private let financialReportLabel = Label(text: "Financial Report", textColor: .customPurple, font: .systemFont(ofSize: 25.autoSized, weight: .semibold), textAlignment: .left)
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
    private let viewModel: TransactionViewModel
    
    init(viewModel: TransactionViewModel = TransactionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViews()
        viewModel.fetchData()
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
    
    private func bindViews() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.transactionsTableView.isHidden = self.viewModel.filteredRecords.isEmpty
            self.transactionsTableView.reloadData()
            self.searchTextField.alpha = self.viewModel.filteredRecords.isEmpty ? 0.5 : 1.0
            self.searchTextField.isEnabled = !self.viewModel.filteredRecords.isEmpty
        }
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
        viewModel.fetchData()
        transactionsTableView.reloadData()
    }
    
    private func errorAlert() {
        let alertController = UIAlertController(
            title: "Deletion Failed",
            message: "Expense exceeds total Income, cannot delete this Income Record",
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text else { return }
        viewModel.filterRecords(by: searchText)
        transactionsTableView.reloadData()
    }
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        let record = viewModel.filteredRecords[indexPath.row]
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
                    let res = self?.viewModel.databaseHandler?.deleteRecord(type: Income.self, id: incomeRecord.id, oldValue: incomeRecord.amount)
                    self?.viewModel.fetchData()
                    if res == false {
                        self?.errorAlert()
                    }
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
                    _ = self?.viewModel.databaseHandler?.deleteRecord(type: Expense.self, id: expenseRecord.id, oldValue: expenseRecord.amount)
                    self?.viewModel.fetchData()
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
