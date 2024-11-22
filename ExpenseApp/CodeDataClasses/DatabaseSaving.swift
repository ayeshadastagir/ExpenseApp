import UIKit
import CoreData

class DatabaseHandling {
    
    func saveIncome(incomeData: IncomeData) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = app.persistentContainer.viewContext
        let getIncome = NSEntityDescription.insertNewObject(forEntityName: "Income", into: context) as? Income
        getIncome?.amount = incomeData.amount
        getIncome?.category = incomeData.category
        getIncome?.explaination = incomeData.explanation
        getIncome?.img = incomeData.image
        getIncome?.date = incomeData.date
        do {
            try context.save()
            print("Income Data has been saved")
        } catch {
            print("Error occurred while saving income")
        }
    }
    
    func saveExpense(expenseData: ExpenseData) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = app.persistentContainer.viewContext
        let getExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense
        
        getExpense?.amount = expenseData.amount
        getExpense?.category = expenseData.category
        getExpense?.explaination = expenseData.explanation
        getExpense?.img = expenseData.image
        getExpense?.date = expenseData.date
        
        do {
            try context.save()
            print("Expense Data has been saved")
        } catch {
            print("Error occurred: \(error.localizedDescription)")
        }
    }
    
    func fetchIncome() -> [IncomeData]? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = app.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let incomeData = try context.fetch(fetchRequest)
            print("Income Data has been fetched")
            
            let incomeList = incomeData.map { income -> IncomeData in
                IncomeData(
                    amount: income.amount ?? "",
                    category: income.category ?? "",
                    explanation: income.explaination ?? "",
                    image: income.img! ,
                    date: income.date ?? Date()
                )
            }
            return incomeList
        } catch {
            print("Error occurred during fetching Income Data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchExpense() -> [ExpenseData]? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = app.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenseData = try context.fetch(fetchRequest)
            print("Income Data has been fetched")
            
            let expenseList = expenseData.map { income -> ExpenseData in
                ExpenseData(
                    amount: income.amount ?? "",
                    category: income.category ?? "",
                    explanation: income.explaination ?? "",
                    image: income.img! ,
                    date: income.date ?? Date()
                )
            }
            return expenseList
        } catch {
            print("Error occurred during fetching Income Data: \(error.localizedDescription)")
            return nil
        }
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
