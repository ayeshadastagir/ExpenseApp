import UIKit

class TransactionViewController: UIViewController {
    
    private let financialReportLabel = Label(text: "Financial Report", textColor: .customPurple, font: .systemFont(ofSize: 25, weight: .semibold), textAlignment: .left)
    private var financialRecords: [FinancialRecord] = []
    private var filteredRecords: [FinancialRecord] = []
    private lazy var searchTextField: UITextField = {
        let tf = TextField( textAlignment: .left, font: .systemFont(ofSize: 15), placeholder: "Transaction Details", cornerRadius: 15, color: UIColor.customPurple.cgColor)
        let PaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.height))
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
        tv.layer.cornerRadius = 0
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
        var incomeRecords: [FinancialRecord] = []

        if let incomeRecordsData = dbFetching?.fetchIncome() {
            incomeRecords = incomeRecordsData.map { incomeData in
                let image = UIImage(data: incomeData.image) ?? UIImage(named: "logo")!
                return IncomeRecord(
                    amount: incomeData.amount,
                    category: incomeData.category,
                    explanation: incomeData.explanation,
                    image: image,
                    date: incomeData.date)
            }.map { .income($0) }
        }
        var expenseRecords: [FinancialRecord] = []
        if let expenseRecordsData = dbFetching?.fetchExpense() {
            expenseRecords = expenseRecordsData.map { expenseData in
                let image = UIImage(data: expenseData.image) ?? UIImage(named: "logo")!
                return ExpenseRecord(amount: expenseData.amount,
                                     category: expenseData.category,
                                     explanation: expenseData.explanation,
                                     image: image,
                                     date: expenseData.date)
                
            }.map { .expense($0) }
        }

        let allRecords = incomeRecords + expenseRecords
        let sortedRecords = allRecords.sorted { $0.date > $1.date }
        financialRecords = sortedRecords
        filteredRecords = sortedRecords
        if !financialRecords.isEmpty {
            transactionsTableView.isHidden = false
            searchTextField.alpha = 1
            searchTextField.isEnabled = true
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
        filteredRecords = financialRecords.filter { record in
            switch record {
            case .income(let incomeRecord):
                return incomeRecord.category.lowercased().contains(searchText.lowercased()) ||
                incomeRecord.explanation.lowercased().contains(searchText.lowercased()) ||
                incomeRecord.amount.contains(searchText) ||
                incomeRecord.date.formattedString().lowercased().contains(searchText.lowercased())
            case .expense(let expenseRecord):
                return expenseRecord.category.lowercased().contains(searchText.lowercased()) ||
                expenseRecord.explanation.lowercased().contains(searchText.lowercased()) ||
                expenseRecord.amount.contains(searchText) ||
                expenseRecord.date.formattedString().lowercased().contains(searchText.lowercased())
            }
        }
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
            cell.configure(categoryLabelText: incomeRecord.category,
                           descriptionLabelText: incomeRecord.explanation,
                           amountLabelText: "+ $" + incomeRecord.amount,
                           icon: incomeRecord.image,
                           color: .customGreen,
                           date: incomeRecord.date.formattedString())
            return cell
        case .expense(let expenseRecord):
            cell.configure(categoryLabelText: expenseRecord.category,
                           descriptionLabelText: expenseRecord.explanation,
                           amountLabelText: "- $" + expenseRecord.amount,
                           icon: expenseRecord.image,
                           color: .customRed,
                           date: expenseRecord.date.formattedString())
            return cell
            
        }
    }
}
