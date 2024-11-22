import UIKit

class HomeViewController: UIViewController {
    
    private let databaseFetching = DatabaseHandling()
    private var financialRecords: [FinancialRecord] = []
    private let welcomeLabel = Label(text: "Welcome to Home",textColor: .customPurple, font: .systemFont(ofSize: 40, weight: .semibold))
    private let incomeView = CardView(backgroundColor: .customGreen, image: "incomeicon", text: "Income")
    private let expenseView = CardView(backgroundColor: .customRed, image: "expenseicon", text: "Expense")
    private let recentTransactionLabel = Label(text: "Recent Transactions", textColor: .customPurple, font: .systemFont(ofSize: 20, weight: .semibold))
    private lazy var transactionsTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndDisplayIncomeAndExpense()
        addTableView()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(incomeView)
        view.addSubview(expenseView)
        
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
            
        ])
    }
    
    private func fetchAndDisplayIncomeAndExpense() {
        let dbFetchingExpense = DatabaseHandling()
        if let expenseRecords = dbFetchingExpense.fetchExpense() {
            let expenseAmounts = expenseRecords.0
            var totalAmount: Int = 0
            
            for amountString in expenseAmounts {
                if let amount = Int(amountString) {
                    totalAmount += amount
                }
            }
            let mytext = String(totalAmount)
            expenseView.amountLabel.text = "$" + mytext
        }
        
        let dbFetchingIncome = DatabaseHandling()
        if let incomeRecords = dbFetchingIncome.fetchIncome() {
            let incomeAmounts = incomeRecords.0
            var totalAmount: Int = 0
            
            for amountString in incomeAmounts {
                if let amount = Int(amountString) {
                    totalAmount += amount
                }
            }
            let mytext = String(totalAmount)
            incomeView.amountLabel.text = "$" + mytext
        }
//               let dbdelete = DatabaseHandling()
//                dbdelete.deleteAllExpense()
//                dbdelete.deleteAllIncome()
    }
    
    private func addTableView() {
        view.addSubview(recentTransactionLabel)
        view.addSubview(transactionsTableView)
        
        NSLayoutConstraint.activate([
            
            recentTransactionLabel.topAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: 10.autoSized),
            recentTransactionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            recentTransactionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            
            transactionsTableView.topAnchor.constraint(equalTo: recentTransactionLabel.bottomAnchor, constant: 10.autoSized),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    private func fetchData() {
        let dbFetching = DatabaseHandling()
        
        var incomeRecords: [FinancialRecord] = []
        if let fetchedIncomeData = dbFetching.fetchIncome() {
            let (amounts, categories, explanations, images, dates) = fetchedIncomeData
            incomeRecords = (0..<amounts.count).map { index in
                IncomeRecord(amount: amounts[index],
                             category: categories[index],
                             explanation: explanations[index],
                             image: images[index],
                             date: dates[index]
                )
            }.map { .income($0) }
        }
        
        var expenseRecords: [FinancialRecord] = []
        if let fetchedExpenseData = dbFetching.fetchExpense() {
            let (amounts, categories, explanations, images, dates) = fetchedExpenseData
            expenseRecords = (0..<amounts.count).map { index in
                ExpenseRecord(amount: amounts[index],
                              category: categories[index],
                              explanation: explanations[index],
                              image: images[index],
                              date: dates[index])
            }.map { .expense($0) }
        }
        let allRecords = incomeRecords + expenseRecords
        let sortedRecords = allRecords.sorted { $0.date > $1.date }
        financialRecords = Array(sortedRecords.prefix(5))
        
        transactionsTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financialRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = financialRecords[indexPath.row]
        
        switch record {
        case .income(let incomeRecord):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
            cell.configure(categoryLabelText: incomeRecord.category,
                           descriptionLabelText: incomeRecord.explanation,
                           amountLabelText: "+ $" + incomeRecord.amount,
                           icon: incomeRecord.image, color: .customGreen, date: incomeRecord.date.formattedString())
            return cell
            
        case .expense(let expenseRecord):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
            cell.configure(categoryLabelText: expenseRecord.category,
                           descriptionLabelText: expenseRecord.explanation,
                           amountLabelText: "- $" + expenseRecord.amount,
                           icon: expenseRecord.image, color: .customRed, date: expenseRecord.date.formattedString())
            return cell
        }
    }
}

