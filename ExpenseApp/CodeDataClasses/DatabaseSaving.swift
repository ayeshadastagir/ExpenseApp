import UIKit
import CoreData

class DatabaseHandling {
    
    let app: AppDelegate
    let context: NSManagedObjectContext
    
    init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        self.app = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func saveIncome(incomeData: IncomeData) {
        let getIncome = NSEntityDescription.insertNewObject(forEntityName: Income.entityName, into: context) as? Income
        getIncome?.amount = incomeData.amount
        getIncome?.category = incomeData.category
        getIncome?.explaination = incomeData.explanation
        getIncome?.img = incomeData.image
        getIncome?.date = incomeData.date
        getIncome?.id = incomeData.id
        do {
            try context.save()
            print("Income Data has been saved")
        } catch {
            print("Income data cannot be saved")
        }
    }
    
    func totalIncome() -> Int {
        let incomeList = fetchIncome() ?? []
        var totalIncome: Int = 0
        incomeList.forEach {
            totalIncome += Int($0.amount) ?? 0
        }
        return totalIncome
    }
    
    func saveExpense(expenseData: ExpenseData) -> Bool {
        let totalIncome = totalIncome()
        let totalExpense = totalExpense()
        let totalProposedExpenses = totalExpense + (Int(expenseData.amount) ?? 0)
        guard totalProposedExpenses <= totalIncome else {
            print("Cannot add expense: Expenses exceed total income")
            return false
        }
        let getExpense = NSEntityDescription.insertNewObject(forEntityName: Expense.entityName, into: context) as? Expense
        getExpense?.amount = expenseData.amount
        getExpense?.category = expenseData.category
        getExpense?.explaination = expenseData.explanation
        getExpense?.img = expenseData.image
        getExpense?.date = expenseData.date
        getExpense?.id = expenseData.id
        do {
            try context.save()
            print("Expense Data has been saved")
            return true
        } catch {
            print("Expense Data cannot be saved")
            return false
        }
    }
    
    func fetchIncome() -> [IncomeData]? {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomeData = try context.fetch(fetchRequest)
            print("Income Data has been fetched")
            let incomeList = incomeData.map {
                IncomeData(
                    amount: $0.amount ?? "",
                    category: $0.category ?? "",
                    explanation: $0.explaination ?? "",
                    image: $0.img! ,
                    date: $0.date ?? Date(),
                    id: $0.id ?? UUID())
            }
            return incomeList
        } catch {
            print("income data cannot be changed")
            return nil
        }
    }
    
    func fetchExpense() -> [ExpenseData]? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            let expenseData = try context.fetch(fetchRequest)
            print("expense Data has been fetched")
            let expenseList = expenseData.map {
                ExpenseData(
                    amount: $0.amount ?? "",
                    category: $0.category ?? "",
                    explanation: $0.explaination ?? "",
                    image: $0.img! ,
                    date: $0.date ?? Date(),
                    id: $0.id ?? UUID())
            }
            return expenseList
        } catch {
            print("expense data cannot be fetched")
            return nil
        }
    }
    
    func deleteRecord<T: NSManagedObject>(type: T.Type, id: UUID, oldValue: String?) -> Bool  {
        if type == Income.self {
            let totalIncome = totalIncome()
            let totalExpense = totalExpense()
            if let value = Int(oldValue ?? "0"), totalExpense > totalIncome - value {
                print("Expense exceeds total Income, cannot delete this record")
                return false
            }
        }
        let fetchRequest: NSFetchRequest<T> = type.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                try context.save()
                print("Record deleted successfully")
            } else {
                print("No record found with the given ID")
            }
        } catch {
            print("Error deleting record")
        }
        return true
    }
    
    func fetchSpecificIncome(id: UUID) -> IncomeData? {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomeData = try context.fetch(fetchRequest)
            if let income = incomeData.first {
                let incomeDataModel = IncomeData(
                    amount: income.amount ?? "",
                    category: income.category ?? "",
                    explanation: income.explaination ?? "",
                    image: income.img ?? Data(),
                    date: income.date ?? Date(),
                    id: income.id ?? UUID() )
                return incomeDataModel
            } else {
                print("No income found for the given ID")
                return nil
            }
        } catch {
            print("Failed to fetch income data")
            return nil
        }
    }
    
    func fetchSpecificExpense(id: UUID) -> ExpenseData? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            let expenseData = try context.fetch(fetchRequest)
            if let expense = expenseData.first {
                let expenseModel = ExpenseData(
                    amount: expense.amount ?? "",
                    category: expense.category ?? "",
                    explanation: expense.explaination ?? "",
                    image: expense.img ?? Data(),
                    date: expense.date ?? Date(),
                    id: expense.id ?? UUID() )
                return expenseModel
            } else {
                print("No expense found for the given ID")
                return nil
            }
        } catch {
            print("Failed to fetch expense data")
            return nil
        }
    }
    
    func totalExpense() -> Int {
        let expenseList = fetchExpense() ?? []
        var totalExpense: Int = 0
        expenseList.forEach {
            totalExpense += Int($0.amount) ?? 0
        }
        return totalExpense
    }
    
    func updateIncome(id: UUID, updatedIncomeData: IncomeData, oldValue: String) -> Bool {
        let totalExpense = totalExpense()
        let totalIncome = totalIncome()
        let totalProposedIncome = totalIncome + (Int(updatedIncomeData.amount) ?? 0) - (Int(oldValue) ?? 0)
        
        guard totalProposedIncome >= totalExpense else {
            print("Cannot update Income Expenses exceed total income")
            return false
        }
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let incomeData = try context.fetch(fetchRequest)
            
            if let income = incomeData.first {
                income.amount = updatedIncomeData.amount
                income.category = updatedIncomeData.category
                income.explaination = updatedIncomeData.explanation
                income.img = updatedIncomeData.image
                income.date = updatedIncomeData.date
                income.id = updatedIncomeData.id
                try context.save()
                print("Income data updated successfully")
                return true
            } else {
                print("No income found with the given ID")
                return false
            }
        } catch {
            print("Failed to update income data")
            return false
        }
    }
    
    func updateExpense(id: UUID, updatedExpenseData: ExpenseData, oldAmount :String) -> Bool {
        let totalIncome = totalIncome()
        let totalExpense = totalExpense()
        
        let totalProposedExpenses = totalExpense + (Int(updatedExpenseData.amount) ?? 0) - (Int(oldAmount) ?? 0)
        
        guard totalProposedExpenses <= totalIncome else {
            print("Cannot add expense: Expenses exceed total income")
            return false
        }
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenseData = try context.fetch(fetchRequest)
            
            if let expense = expenseData.first {
                
                expense.amount = updatedExpenseData.amount
                expense.category = updatedExpenseData.category
                expense.explaination = updatedExpenseData.explanation
                expense.img = updatedExpenseData.image
                expense.date = updatedExpenseData.date
                expense.id = updatedExpenseData.id
                try context.save()
                print("Income data updated successfully")
                return true
            } else {
                print("No income found with the given ID")
                return false
            }
        } catch {
            print("Failed to update income data")
            return false
        }
    }
    
    func fetchAllFinancialRecords() -> [FinancialRecord] {
        guard let incomeRecordsData = fetchIncome(),
              let expenseRecordsData = fetchExpense() else {
            return []
        }
        let incomeRecords: [FinancialRecord] = incomeRecordsData.map {
            .income(IncomeData(
                amount: $0.amount,
                category: $0.category,
                explanation: $0.explanation,
                image: $0.image,
                date: $0.date,
                id: $0.id
            ))
        }
        let expenseRecords: [FinancialRecord] = expenseRecordsData.map {
            .expense(ExpenseData(
                amount: $0.amount,
                category: $0.category,
                explanation: $0.explanation,
                image: $0.image,
                date: $0.date,
                id: $0.id
            ))
        }
        return (incomeRecords + expenseRecords).sorted { $0.date > $1.date }
    }
}
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //func deleteIncome(amount: String, category: String, explanation: String, date: Date) {
        //    guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //    let context = app.persistentContainer.viewContext
        //    let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        //    do {
        //        let results = try context.fetch(fetchRequest)
        //        for record in results {
        //            context.delete(record)
        //        }
        //        try context.save()
        //        print("Income record deleted successfully")
        //    } catch {
        //        print("Error deleting income record")
        //    }
        //}
        //
        //func deleteExpense(amount: String, category: String, explanation: String, date: Date) {
        //    guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //    let context = app.persistentContainer.viewContext
        //    let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        //    do {
        //        let results = try context.fetch(fetchRequest)
        //        for record in results {
        //            context.delete(record)
        //        }
        //        try context.save()
        //        print("Income record deleted successfully")
        //    } catch {
        //        print("Error deleting expense record")
        //    }
        //}
        //func deleteAllIncome() {
        //       guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //       let context = app.persistentContainer.viewContext
        //       let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Income.fetchRequest()
        //       let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        //
        //       do {
        //           try context.execute(deleteRequest)
        //           try context.save()
        //           print("All Income Data has been deleted")
        //       } catch {
        //           print("Error occurred during deleting all Income Data")
        //       }
        //   }
        
        //   func deleteAllExpense() {
        //       guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //       let context = app.persistentContainer.viewContext
        //       let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Expense.fetchRequest()
        //       let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        //
        //       do {
        //           try context.execute(deleteRequest)
        //           try context.save()
        //           print("All Expense Data has been deleted")
        //       } catch {
        //           print("Error occurred during deleting all Expense Data")
        //       }
        //   }
        //func fetchIncome() -> [IncomeData]? {
        //    guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        //    let context = app.persistentContainer.viewContext
        //    let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        //
        //    do {
        //        let incomeData = try context.fetch(fetchRequest)
        //        print("Income Data has been fetched")
        //
        //        let incomeList = incomeData.map { income -> IncomeData in
        //            IncomeData(
        //                amount: income.amount ?? "",
        //                category: income.category ?? "",
        //                explanation: income.explaination ?? "",
        //                image: UIImage(data: income.img!) ?? UIImage(named: "logo")!, // Provide a default image if `img` is nil
        //                date: income.date ?? Date()
        //            )
        //        }
        //
        //        return incomeList
        //    } catch {
        //        print("Error occurred during fetching Income Data: \(error.localizedDescription)")
        //        return nil
        //    }
        //}
