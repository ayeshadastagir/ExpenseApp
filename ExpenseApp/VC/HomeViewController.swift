import UIKit

class HomeViewController: UIViewController {
    
    private var financialRecords: [FinancialRecord] = []
    private let welcomeLabel = Label(text: "Welcome to Home",textColor: .customPurple, font: .systemFont(ofSize: 40, weight: .semibold))
    private let incomeView = CardView(backgroundColor: .customGreen, image: "incomeicon", text: "Income")
    private let expenseView = CardView(backgroundColor: .customRed, image: "expenseicon", text: "Expense")
    private let recentTransactionLabel = Label(text: "Recent Transactions", textColor: .customPurple, font: .systemFont(ofSize: 20, weight: .semibold), hidden: true)
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
        updateIncomeExpenseAmount()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(incomeView)
        view.addSubview(expenseView)
        view.addSubview(recentTransactionLabel)
        view.addSubview(transactionsTableView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            incomeView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20.autoSized),
            incomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            incomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            incomeView.heightAnchor.constraint(equalToConstant: 120.autoSized),
            
            expenseView.topAnchor.constraint(equalTo: incomeView.bottomAnchor, constant: 10.autoSized),
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            expenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            expenseView.heightAnchor.constraint(equalToConstant: 120.autoSized),
            
            recentTransactionLabel.topAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: 10.autoSized),
            recentTransactionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            recentTransactionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            
            transactionsTableView.topAnchor.constraint(equalTo: recentTransactionLabel.bottomAnchor, constant: 10.autoSized),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func updateIncomeExpenseAmount() {
        let dbFetchingExpense = DatabaseHandling()

        if let expenseRecords = dbFetchingExpense.fetchExpense() {
            var totalAmount: Int = 0

            for expense in expenseRecords {
                if let amount = Int(expense.amount) {
                    totalAmount += amount
                }
            }
            expenseView.amountLabel.text = "$" + String(totalAmount)
        } else {
            print("No income records found.")
        }
 
        let dbFetchingIncome = DatabaseHandling()
        if let incomeRecords = dbFetchingIncome.fetchIncome() {
            var totalAmount: Int = 0

            for income in incomeRecords {
                if let amount = Int(income.amount) {
                    totalAmount += amount
                }
            }
            incomeView.amountLabel.text = "$" + String(totalAmount)
        } else {
            print("No income records found.")
        }
    }
    
    private func fetchData() {
        let dbFetching = DatabaseHandling()
        var incomeRecords: [FinancialRecord] = []
        var expenseRecords: [FinancialRecord] = []

        if let incomeRecordsData = dbFetching.fetchIncome() {
            incomeRecords = incomeRecordsData.map { incomeData in
                let image = UIImage(data: incomeData.image) ?? UIImage(named: "logo")!
                return IncomeRecord(
                    amount: incomeData.amount,
                    category: incomeData.category,
                    explanation: incomeData.explanation,
                    image: image,
                    date: incomeData.date
                )
            }.map { .income($0) }
        }
        
        if let fetchedExpenseData = dbFetching.fetchExpense() {
            expenseRecords = fetchedExpenseData.map { expenseData in
                let image = UIImage(data: expenseData.image) ?? UIImage(named: "logo")!
                return ExpenseRecord(
                    amount: expenseData.amount,
                    category: expenseData.category,
                    explanation: expenseData.explanation,
                    image: image,
                    date: expenseData.date
                )
            }.map { .expense($0) }
        }

        let allRecords = incomeRecords + expenseRecords
        let sortedRecords = allRecords.sorted { $0.date > $1.date }
        financialRecords = Array(sortedRecords.prefix(5))
        
        if !financialRecords.isEmpty {
            recentTransactionLabel.isHidden = false
            transactionsTableView.isHidden = false
            transactionsTableView.reloadData()
        } else {
            recentTransactionLabel.isHidden = true
            transactionsTableView.isHidden = true
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financialRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        let record = financialRecords[indexPath.row]
        switch record {
        case .income(let incomeRecord):
            cell.configure(categoryLabelText: incomeRecord.category,
                           descriptionLabelText: incomeRecord.explanation,
                           amountLabelText: "+ $" + incomeRecord.amount,
                           icon: incomeRecord.image, color: .customGreen, date: incomeRecord.date.formattedString())
            return cell
        case .expense(let expenseRecord):
            cell.configure(categoryLabelText: expenseRecord.category,
                           descriptionLabelText: expenseRecord.explanation,
                           amountLabelText: "- $" + expenseRecord.amount,
                           icon: expenseRecord.image, color: .customRed, date: expenseRecord.date.formattedString())
            return cell
        }
    }
}

