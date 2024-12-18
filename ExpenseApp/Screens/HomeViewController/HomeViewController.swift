import UIKit

enum FinancialRecord {
    case income(IncomeData)
    case expense(ExpenseData)
}

class HomeViewController: UIViewController {

    private let welcomeLabel = Label(text: "Welcome to Home", textColor: .customPurple, font: .systemFont(ofSize: 40.autoSized, weight: .semibold))
    private let incomeView = CardView(backgroundColor: .customGreen, image: "incomeicon", text: "Income")
    private let expenseView = CardView(backgroundColor: .customRed, image: "expenseicon", text: "Expense")
    private let walletView = CardView(backgroundColor: .customBlue, image: "wallet", text: "Wallet")
    private let recentTransactionLabel = Label(text: "Recent Transactions", textColor: .customPurple, font: .systemFont(ofSize: 20.autoSized, weight: .semibold), hidden: true)
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
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        viewModel.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
        transactionsTableView.reloadData()
    }

    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(incomeView)
        view.addSubview(expenseView)
        view.addSubview(walletView)
        view.addSubview(recentTransactionLabel)
        view.addSubview(transactionsTableView)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.autoSized),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            incomeView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20.autoSized),
            incomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            incomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            incomeView.heightAnchor.constraint(equalToConstant: 100.autoSized),

            expenseView.topAnchor.constraint(equalTo: incomeView.bottomAnchor, constant: 10.autoSized),
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            expenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            expenseView.heightAnchor.constraint(equalToConstant: 100.autoSized),

            walletView.topAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: 10.autoSized),
            walletView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            walletView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            walletView.heightAnchor.constraint(equalToConstant: 100.autoSized),

            recentTransactionLabel.topAnchor.constraint(equalTo: walletView.bottomAnchor, constant: 10.autoSized),
            recentTransactionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            recentTransactionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),

            transactionsTableView.topAnchor.constraint(equalTo: recentTransactionLabel.bottomAnchor, constant: 10.autoSized),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
                self?.updateUI()
        }
    }

    private func updateUI() {
        incomeView.amountLabel.text = String(viewModel.totalIncome).toCurrencyFormat
        expenseView.amountLabel.text = String(viewModel.totalExpense).toCurrencyFormat
        walletView.amountLabel.text = String(viewModel.balance).toCurrencyFormat

        recentTransactionLabel.isHidden = viewModel.financialRecords.isEmpty
        transactionsTableView.isHidden = viewModel.financialRecords.isEmpty
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
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.financialRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        let record = viewModel.financialRecords[indexPath.row]
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


