//
import SwiftUI
import CoreData
import Firebase

struct meal: Identifiable
{
    var id: Int
    var name: String
    var calories: Int
//    var date: Date
//    var protein: Int
//    var carbs: Int
//    var fat: Int
}

class DataManager: ObservableObject
{
    
    //let container: NSPersistentContainer
    //@Published var savedMealEntities: [MealEntity] = []
    
    @Published var meals: [meal] = []
    init()
    {
        
    //MARK: - CoreData init
//        container = NSPersistentContainer(name: "MealModel")
//        container.loadPersistentStores { desc, error in
//            if let error = error
//            {
//                print("error loading data \(error)")
//            }
//            else
//            {print("succesfully loaded data")}
//        }
        
        //MARK: - Firebase init
        if getUser() != ""
        {
            fetchMeals(uid: getUser())
            loadMeals()
        }

    }
    func clearData()
    {
        model.todaymeals = []
        model.archivedmeals = []
        model.calories = 0
        model.totalFat = 0
        model.totalCarbs = 0
        model.totalProtein = 0
        model.size = 100
    }
    
    //Empty document error
    func fetchMeals(uid: String)
    {
        meals.removeAll()
        let db = Firestore.firestore()
        print("user: \(uid)")
        
        if uid != ""
        {
            let ref = db.collection("userData").document(uid).collection("Meals")
            ref.getDocuments { snapshot, error in
                guard error == nil else{
                    print(error!.localizedDescription)
                    return
                }
                if let snapshot = snapshot
                {
                    for document in snapshot.documents{
                        let data = document.data()
                        print("data \(data)")
                        
                        let name = data["name"] as? String ?? ""
                        let calories = data["calories"] as? Int ?? 0
                        let id = data["id"] as? Int ?? 0
                        
                        let meal = meal(id: id, name: name, calories: calories)
                        self.meals.append(meal)
                        
                        
                    }
                    print("meals fetched")
                    self.loadMeals()
                }
            }
        }
        else
        {
            print("can't access data")
            self.loadMeals()
        }
        
        
    }
    
//MARK: - CoreData FetchMeal
//    func fetchMeals()
//    {
//        let request = NSFetchRequest<MealEntity>(entityName: "MealEntity")
//        do{
//            savedMealEntities = try container.viewContext.fetch(request)
//
//        }
//        catch let error{
//            print("error fetching \(error)")
//        }
//    }
    
    func getUser()->String
    {
        guard let userID = Auth.auth().currentUser?.uid else {
            return "error loading id"
        }
        return userID
    }
    
    func getEmail()->String
    {
        guard let userEmail = Auth.auth().currentUser?.email else
        {
            return "error loading email"
        }
        return userEmail
    }
  
    func addMealtoDB(name: String, calories: Int, protein: Int, carbs: Int, fat: Int, date: Date)
    {
        //Steak managing
//        let lastTimeAdded = UserDefaults.standard.object(forKey: "lastTimeAdded") as? Date
//        let timeSinceLastUsed = calcDaysBetween(start: lastTimeAdded ?? Date(), endDate: Date())
//        let curr_streak = UserDefaults.standard.integer(forKey: "streak")
//
//        if self.meals.isEmpty
//        {
//            UserDefaults.standard.set(1, forKey: "streak")
//            UserDefaults.standard.set(Date(), forKey: "lastTimeAdded")
//            model.streak = 1
//            print("time set, streak set to 1")
//        }
//
//        else
//        {
//            print(meals)
//            if timeSinceLastUsed >= 1 && timeSinceLastUsed < 2
//            {
//                UserDefaults.standard.set(curr_streak+1, forKey: "streak")
//                UserDefaults.standard.set(Date(), forKey:"lastTimeAdded")
//                model.streak = curr_streak+1
//                print("streak increased, new time set")
//            }
//            else if timeSinceLastUsed >= 2
//            {
//                UserDefaults.standard.set(0, forKey: "streak")
//                UserDefaults.standard.set(Date(), forKey:"lastTimeAdded")
//                model.streak = 0
//                print("streak reset, new time set")
//            }
//            else
//            {
//                print("too soon to set streak")
//            }
//        }
        
        
        //Add the meal to userData collection (firebase)
        let db = Firestore.firestore()
        let ref = db.collection("userData").document(getUser()).collection("Meals").document(name)
        ref.setData(["name": name, "calories": calories, "fat": fat, "protein": protein, "carbs": carbs]){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        
        
        //Add the meal to running application
        model.addMeal(cals: Int(calories), protein: Int(protein), carbs: Int(carbs), fat: Int(fat), name: name, status: Color("Yellow"), days: getTimeDays(date: date), fullDate: date)
    }
    
//    func addMealtoContainer(name: String, calories: Int16, protein: Int16, carbs: Int16, fat: Int16, date: Date)
//    {
//        let lastTimeAdded = UserDefaults.standard.object(forKey: "lastTimeAdded") as? Date
//        let timeSinceLastUsed = calcDaysBetween(start: lastTimeAdded ?? Date(), endDate: Date())
//        let curr_streak = UserDefaults.standard.integer(forKey: "streak")
//
//        let newMeal = MealEntity(context: container.viewContext)
//
//        newMeal.name = name
//        newMeal.calories = calories
//        newMeal.protein = protein
//        newMeal.carbs = carbs
//        newMeal.fat = fat
//        newMeal.date = date
//
//        if meals.isEmpty
//        {
//            UserDefaults.standard.set(1, forKey: "streak")
//            UserDefaults.standard.set(Date(), forKey: "lastTimeAdded")
//            model.streak = 1
//            print("time set, streak set to 1")
//        }
//
//        else
//        {
//            print(meals)
//            if timeSinceLastUsed >= 1 && timeSinceLastUsed < 2
//            {
//                UserDefaults.standard.set(curr_streak+1, forKey: "streak")
//                UserDefaults.standard.set(Date(), forKey:"lastTimeAdded")
//                model.streak = curr_streak+1
//                print("streak increased, new time set")
//            }
//            else if timeSinceLastUsed >= 2
//            {
//                UserDefaults.standard.set(0, forKey: "streak")
//                UserDefaults.standard.set(Date(), forKey:"lastTimeAdded")
//                model.streak = 0
//                print("streak reset, new time set")
//            }
//            else
//            {
//                print("too soon to set streak")
//            }
//        }
//
//
//
//        model.addMeal(cals: Int(calories), protein: Int(protein), carbs: Int(carbs), fat: Int(fat), name: name, status: Color("Yellow"), days: getTimeDays(date: date), fullDate: date)
//        //saveData()
//
//
//    }
    

    func loadMeals()
    {
        clearData()
        print(model.todaymeals)
        print("meals: \(meals)")
        for entity in meals
        {
//            if getTimeDays(date: entity.date!) <= 1
//            {
//                model.addMeal(cals: Int(entity.calories), protein: Int(entity.protein), carbs: Int(entity.carbs), fat: Int(entity.carbs), name: entity.name ?? "unnamed meal", status: Color("Red"), days: getTimeDays(date: entity.date!), fullDate: entity.date!)
//            }
//            else
//            {
//                model.addToArchive(cals: Int(entity.calories), protein: Int(entity.protein), carbs: Int(entity.carbs), fat: Int(entity.carbs), name: entity.name ?? "unnamed meal", days: getTimeDays(date: entity.date!), fullDate: entity.date!)
//            }

            model.addMeal(cals: entity.calories, protein: 0, carbs: 0, fat: 0, name: entity.name , status: Color("Red"), days: getTimeDays(date: Date()), fullDate: Date())
            
            //core data add meal
            //model.addMeal(cals: Int(entity.calories), protein: Int(entity.protein), carbs: Int(entity.carbs), fat: Int(entity.fat), name: entity.name ?? "" , status: Color("Red"), days: getTimeDays(date: Date()), fullDate: Date())
        }
        print("meals loaded")
        model.checkSize()
    }
    
    func deleteMealfromDB(meal: String)
    {
        let db = Firestore.firestore()
        let ref = db.collection("userData").document(getUser()).collection("Meals").document(meal)
        ref.delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            }
            else {
              print("Document successfully removed!")
            }
          }
    }
    
//MARK: - Delete Meal CoreData
//    func deleteMealfromContainer()
//    {
//        let entity = savedMealEntities[model.selectedMeal]
//        container.viewContext.delete(entity)
//        print("meal deleted")
//        saveData()
//    }
    
//    func saveData()
//    {
//        do
//        {
//            try container.viewContext.save()
//            fetchMeals()
//            print("data saved")
//        }
//        catch let error
//        {
//            print("error saving \(error)")
//        }
//
//    }
    
    
    static func createTracker() -> Tracker
    {
        Tracker(size: 100, calories: 0, goalStatus: Color("Red"), goal: 3200, program: 1, todaymeals: [], archivedmeals: [])
    }
    
    
    @Published private var model: Tracker = createTracker()
    
    var Ongry: Tracker
    {
        return model
    }
    
    
    
    //MARK: - Intent(s)
    
    func reset()
    {
        model.reset()
    }

    

    //
    func updateTodayMeals()
    {
        let meals = model.todaymeals.reversed()
        for meal in meals
        {
            let today = getDate(date: Date())
            let mealDate = getDate(date: meal.fullDate)
            
            if mealDate != today
            {
                model.addToArchive(cals: meal.calories, protein: meal.protein, carbs: meal.carbs, fat: meal.fat, name: meal.name, days: meal.days, fullDate: meal.fullDate)
                deleteMeal(index: meal.id)
            }
            else
            {
                
            }
        }
        //saveData()
    }
    
    func checkSize()
    {
        model.checkSize()
    }
    
    func toggleGoalView()
    {
        if model.goalView
        {
            model.closeGoalView()
        }
        else
        {
            model.openGoalView()
        }
    }
    
    func toggleAddFoodView()
    {
        if model.addFood
        {
            model.closeAddFoodView()
        }
        else
        {
            model.openAddFoodView()
        }
    }
    func toggleTodayMeals()
    {
        if model.todayMeals
        {
            model.closeTodayMeals()
        }
        else
        {
            model.openTodayMeals()
        }
    }
    
    func toggleDetailedView()
    {
        if model.detailedView
        {
            model.closeDetailedView()
        }
        else
        {
            model.openDetailedView()
        }
    }
    
    func closeDetailedView()
    {
        if model.detailedView
        {
            model.closeDetailedViewBall()
        }
        
    }
    
    func setSelectedMeal(id: Int)
    {
        model.setSelectedMeal(id: id)
    }
    
    func deleteMeal(index: Int)
    {
        model.deleteMeal(index: index)
    }
    
    
    func toggleJustDeleted()
    {
        model.toggleJustDeleted()
    }
    
    func toggleWeightTracker()
    {
        model.toggleWeightTracker()
    }
    
    
    func notJustDeleted()
    {
        model.notJustDeleted()
    }
    
    
    func getProteinProgress()->Float
    {
        return Float(model.totalProtein)/Float(model.proteinGoal)
    }
    
    
    
    func incrementStreak()
    {
        let newStreak = model.streak + 1
        UserDefaults.standard.set(newStreak, forKey: "streak")
    }
    
    func getStreak()
    {
        
    }
}


