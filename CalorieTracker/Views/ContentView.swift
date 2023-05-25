//
//  ContentView.swift
//  CalorieTracker
//
//  Created by Andrew Chang on 3/28/23.
//

import SwiftUI
import CoreData
import Firebase


struct ContentView: View
{
    //@StateObject var dataManager = DataManager()
    
    @State var email = ""
    @State var password = ""
    @State var userIsLoggedIn:Bool = UserDefaults.standard.bool(forKey: "loggedin")
    @StateObject var dataManager = DataManager()
    @State private var selectedTab: Tab = .house
    @State var errorMessage = ""
    @State var onBoarding:Bool = false
    
    @State var selection: String = "house"
    init()
    {
        UITabBar.appearance().isHidden = true
    }
    var body: some View
    {
        if userIsLoggedIn && !onBoarding
        {
//            ListView()
//                .environmentObject(dataManager)
            ZStack{
                VStack{
                    TabView(selection: $selectedTab)
                    {
                        homePage(viewModel: dataManager)
                            .tag(Tab.house)
                        ProfileView(dataManager: dataManager, userIsLoggedIn: $userIsLoggedIn)
                            .tag(Tab.person)
                        SocialView()
                            .tag(Tab.trophy)
                    }
                }
                NavBar(selectedTab: $selectedTab)
                    .offset(y:350)
            }
        }
        else if onBoarding
        {
            //OnBoardingView()
        }
        else
        {
            login
        }
    }
    
    var login: some View
    {
        ZStack
        {
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing: 20)
            {
                TextField("", text: $email, prompt: Text("Email").foregroundColor(.white))
                    .font(.system(size: 20.0, design: .rounded))
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white))
                    .font(.system(size: 20.0, design: .rounded))
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Text(errorMessage)
                    .foregroundColor(.white)
                    .font(.system(size: 20.0, design: .rounded))
                
                Button
                {
                    register()
                    //onBoarding = true
                } label:
                {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing)))
                    
                    
                }
                .padding(.top)
                .offset(y:0)
                
                Button
                {
                    loginUser()
                } label:
                {
                    Text("Already have an account? Login")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(.top)
                .offset(y:10)
                
            }
        }
    }
    func loginUser()
    {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if error != nil
            {
                errorMessage = error!.localizedDescription
                print(error!.localizedDescription)
                
            }
            else
            {
                errorMessage = ""
                email = ""
                password = ""
                userIsLoggedIn = true
                UserDefaults.standard.set(true, forKey: "loggedin")
                selectedTab = Tab.house
                
                //get the user id of new login
                let uid = dataManager.getUser()
                print(uid)
                //get data
                dataManager.fetchMeals(uid: uid)
                dataManager.loadMeals()
            }
        }
        
        
    }
    
//MARK: - Bring to onboarding page
    func register()
    {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if error != nil
            {
                errorMessage = error!.localizedDescription
                print(error!.localizedDescription)
            }
            else
            {
                errorMessage = ""
                email = ""
                password = ""
                userIsLoggedIn = true
                UserDefaults.standard.set(true, forKey: "loggedin")
                //Bring to onboarding page
            }
        }
    }
    

}


struct homePage: View
{
    @ObservedObject var viewModel: DataManager
    
    @State var yoffset: CGFloat = 0
    @State var ydragOffset: CGFloat = 0
    
    
    
    @State var selectedTab: Tab = .house
    
    @FocusState private var nameInFocus: Bool
    
    
    
    @State var calstext: String = ""
    @State var proteintext: String = ""
    @State var carbstext: String = ""
    @State var fattext: String = ""
    @State var nametext: String = ""
    
    @State var isFocused1: Bool = false
    @State var isFocused2: Bool = false
    @State var isFocused3: Bool = false
    @State var isFocused4: Bool = false
    @State var isFocused5: Bool = false
    
    
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .foregroundColor(Color("Background"))
                .ignoresSafeArea()
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(Color("Card Color").opacity(1))
                        .frame(width: 500, height: 120)
                        .ignoresSafeArea()
                        .offset(y:0)
                    
                    ZStack()
                    {
                        HStack()
                        {
                            Spacer()
                            ZStack
                            {
                                if viewModel.Ongry.program == 1
                                {
                                    Text("🪨Bulk")
                                        .bold()
                                        .foregroundColor(Color("text color"))
                                        .font(.system(size: 20, design: .rounded))
                                }
                                else
                                {
                                    Text("🪶Cut")
                                        .bold()
                                        .foregroundColor(Color("text color"))
                                        .font(.system(size: 20, design: .rounded))
                                }
                            }
                            Spacer()
                            ZStack
                            {
                                Text("🔥\(viewModel.Ongry.streak)")
                                    .bold()
                                    .foregroundColor(Color("text color"))
                                    .font(.system(size: 20, design: .rounded))

                            }
                            Spacer()
                            ZStack
                            {
                                if(!viewModel.Ongry.weightTracker)
                                {
                                    Text("🎯\(viewModel.Ongry.goalWeight)")
                                        .bold()
                                        .onTapGesture
                                    {
                                        viewModel.toggleWeightTracker()
                                    }
                                    .foregroundColor(Color("text color"))
                                    .font(.system(size: 20, design: .rounded))
                                }
                                
                                else
                                {
                                    Text("🎯\(viewModel.Ongry.goalWeight)")
                                        .bold()
                                        .onTapGesture
                                    {
                                        viewModel.toggleWeightTracker()
                                    }
                                    .foregroundColor(Color("text color"))
                                    .font(.system(size: 30, design: .rounded))
                                }

                            }
                            Spacer()
                        }
                        .offset(y:-20)
                        
//                        HStack()
//                        {
//                            if(!viewModel.Ongry.weightTracker)
//                            {
//                                Rectangle()
//                                    .cornerRadius(20)
//                                    .frame(width: 100, height: 2)
//                                    .offset(y:10)
//                            }
//                            if(viewModel.Ongry.weightTracker)
//                            {
//                                Rectangle()
//                                    .cornerRadius(20)
//                                    .frame(width: 100, height: 2)
//                                    .offset(y:10)
//                            }
//
//                        }
                    }
                }
                Spacer()
                
            }
            

            
            if viewModel.Ongry.ballView
            {
                BallView(tracker: viewModel.Ongry)
                    .onTapGesture
                {
                    
                    viewModel.toggleGoalView()
                }
                .offset(y: yoffset)
                .offset(y: ydragOffset)
                .gesture(
                    DragGesture()
                        .onChanged()
                    {
                        value in ydragOffset = value.translation.height
                    }
                        .onEnded()
                    {
                        value in
                        
                        if ydragOffset > 50
                        {
                            viewModel.updateTodayMeals()
                            viewModel.toggleTodayMeals()
                        }
                        
                        else if ydragOffset < -50
                        {
                            viewModel.toggleAddFoodView()
                        }
                        
                        ydragOffset = 0
                        
                    })
            }
            
            
            else if viewModel.Ongry.goalView
            {
                ZStack
                {
                    GoalView(tracker: viewModel.Ongry, proteinProgress: viewModel.getProteinProgress())
                        .onTapGesture
                    {
                        viewModel.toggleGoalView()
                    }
                }
            }
            
            //MARK: - Add Meal Menu
            if viewModel.Ongry.addFood
            {
                ZStack
                {
                    AddMealView(viewModel: viewModel)
                        .offset(y: yoffset)
                        .offset(y: ydragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged()
                            {
                                value in ydragOffset = value.translation.height
                            }
                                .onEnded()
                            {
                                value in
                                
                                if ydragOffset > 50
                                {
                                    viewModel.toggleAddFoodView()
                                    viewModel.checkSize()
                                }
                                
                                else if ydragOffset < -50
                                {
                                    viewModel.toggleAddFoodView()
                                    viewModel.checkSize()
                                }
                                
                                ydragOffset = 0
                                
                            })
                    
                }
                
            }
            
            else if viewModel.Ongry.todayMeals
            {
                ZStack
                {
                    //to solve drag issue, make another view that is draggable
                    //and adjust todaymealsview with it
                    TDMealDragWindow(viewModel: viewModel)
                        .offset(y: yoffset)
                        .offset(y: ydragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged()
                            {
                                value in ydragOffset = value.translation.height
                            }
                                .onEnded()
                            {
                                value in
                                
                                if ydragOffset > 50
                                {
                                    viewModel.toggleTodayMeals()
                                    viewModel.checkSize()
                                }
                                
                                else if ydragOffset < -50
                                {
                                    viewModel.toggleTodayMeals()
                                    viewModel.checkSize()
                                }
                                
                                ydragOffset = 0
                                
                            })
                    TodayMealsView(viewModel: viewModel)
                        .offset(y: yoffset)
                        .offset(y: ydragOffset)
                }
            }
            
            else if viewModel.Ongry.weightTracker
            {
                WeightTracker(dataManager: viewModel)
            }
            
            //MARK: - Open Detailed View for meal
            else if viewModel.Ongry.detailedView
            {
                ZStack
                {
                    DetailedView(viewModel: viewModel)
                        .offset(y: yoffset)
                        .offset(y: ydragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged()
                            {
                                value in ydragOffset = value.translation.height
                            }
                                .onEnded()
                            {
                                value in
                                
                                if ydragOffset > 50
                                {
                                    viewModel.closeDetailedView()
                                    viewModel.checkSize()
                                }
                                
                                else if ydragOffset < -50
                                {
                                    viewModel.closeDetailedView()
                                    viewModel.checkSize()
                                }
                                
                                ydragOffset = 0
                                
                            })
                }
            }
            
            
        }
    }
}
struct WeightTracker: View
{
    @StateObject var dataManager: DataManager
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .cornerRadius(20)
                .foregroundColor(Color("Card Color"))
                .frame(width: 350, height: 550)
                .offset(y:0)
            Button
            {
//                if caloriesInput != ""
//                {
//                    mealcals = caloriesInput
//                    mealprotein = proteinInput
//                    mealcarbs = carbsInput
//                    mealfat = fatInput
//                    mealname = nameInput
//
//
//
//                    //MARK: - DataModel Input Meal
//                    guard !mealname.isEmpty else {return}
//                    viewModel.addMealtoDB(name: String(mealname) , calories: Int(mealcals) ?? 0, protein: Int(mealprotein) ?? 0,carbs: Int(mealcarbs) ?? 0,fat: Int(mealfat) ?? 0, date: Date())
//                    caloriesInput = ""
//                    proteinInput = ""
//                    carbsInput = ""
//                    fatInput = ""
//                    nameInput = ""
//                    viewModel.checkSize()
//                }
                dataManager.toggleWeightTracker()
            }
        label:
            {
                Text("Log Weight")
                    .font(.system(size:25, weight: .bold))
                    .foregroundColor(.white)
                    .padding(30)
                    .offset(y: -15)
                    .frame(width: 200, height: 40)
                    .background(Color("Green").cornerRadius(10).offset(y: -15))
            }
            .padding(.top, 100)
        }
            
    }
}
//MARK: - Profile View
struct ProfileView: View
{
    @StateObject var dataManager: DataManager
    @Binding var userIsLoggedIn: Bool
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .foregroundColor(Color("Background"))
                .ignoresSafeArea()
            VStack
            {
                Text("Profile")
                    .bold()
                    .font(.system(size: 50))
                    .padding(.top, 30)
                HStack
                {
                    Text("Email: \(dataManager.getEmail())")
                }
                Spacer()
                VStack
                {
                    Text("Currently still working on: ")
                }
                Button
                {
                    logoutUser()
                } label: {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing)))
                }
                Spacer()

                
            }
        }
    }
    func logoutUser()
    {
        do
        {
            try Auth.auth().signOut()

            print("user signed out")
            
            userIsLoggedIn = false
            UserDefaults.standard.set(false, forKey: "loggedin")
            
        }
        catch
        {
            print("error logging user out")
        }
    }
}

//MARK: - Social View
struct SocialView: View
{
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .foregroundColor(Color("Background"))
                .ignoresSafeArea()
            Text("Feature under construction")
        }
    }
}

//MARK: - Goal View
struct GoalView: View
{
    var tracker: Tracker
    var proteinProgress: Float
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 30 )
                .frame(width: 280, height: 280)
                .foregroundColor(tracker.goalStatus)
            
            VStack()
            {
                if tracker.calories >= tracker.goal
                {
                    Text("Goal Completed")
                        .font(.system(size:40))
                        .bold()
                        .foregroundColor(.white)
                        .offset(y: -10)
                }
                else
                {
                    Text("\(tracker.goal-tracker.calories) cals left")
                        .font(.system(size:40))
                        .bold()
                        .foregroundColor(.white)
                        .offset(y: -10)
                    
                }
                
                //Macro Text
                VStack
                {
                    Text("Protein:  \(tracker.totalProtein)g")
                        .font(.system(size:30))
                        .foregroundColor(.white)
                        .bold()
                    Text("Carbs:  \(tracker.totalCarbs)g")
                        .font(.system(size:30))
                        .foregroundColor(.white)
                        .bold()
                    Text("Fat:  \(tracker.totalFat)g")
                        .font(.system(size:30))
                        .foregroundColor(.white)
                        .bold()
                }
                //                HStack
                //                {
                //                    Spacer()
                //                    CircleProgressBar(progress: proteinProgress)
                //                        .frame(width: 50)
                //                        .offset(x:20)
                //                    Spacer()
                //                    CircleProgressBar(progress: proteinProgress)
                //                        .frame(width: 50)
                //                    Spacer()
                //                    CircleProgressBar(progress: proteinProgress)
                //                        .frame(width: 50)
                //                        .offset(x:-20)
                //                    Spacer()
                //                }
            }
        }
    }
}


struct TDMealDragWindow: View
{
    @ObservedObject var viewModel:DataManager
    var body: some View
    {
        Rectangle()
            .mask(RoundedRectangle(cornerRadius: 30,style: .continuous))
            .foregroundColor(Color("Card Color"))
            .frame(width: 360, height: 600)
            .offset(y:0)
    }
}

//MARK: - Today's Meals View
struct TodayMealsView: View
{
    @ObservedObject var viewModel:DataManager
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .mask(RoundedRectangle(cornerRadius: 30,style: .continuous))
                .foregroundColor(Color("Card Color"))
                .frame(width: 360, height: 540)
                .offset(y:-25)
            
            VStack()
            {
                Text("Today's Meals")
                    .padding(.top, 50)
                    .font(.system(size:45))
                    .bold()
                    .foregroundColor(Color("text color"))
                    .offset(y:50)
                
                
                Spacer()
                
                //MARK: - Meal bubbles
                //                            Button
                //                            {
                //                                viewModel.toggleDetailedView()
                //                                viewModel.setSelectedMeal(index: meal.id)
                //                            }
                //                        label:
                //                            {
                //                                Text("Meal \(meal.id+1): \(meal.name)")
                //                                    .font(.system(size:30))
                //                                    .bold()
                //                                    .foregroundColor(.white)
                //                                    .background(meal.status.cornerRadius(20).frame(width: 300, height: 100))
                //                                    .frame(width: 300, height: 100)
                //                            }
                ScrollView
                {
                    
                    ForEach(viewModel.Ongry.todaymeals)
                    {
                        meal in
                        
                        MealView(id: meal.id, name: meal.name, status: meal.status)
                            .onTapGesture
                        {
                            viewModel.notJustDeleted()
                            viewModel.setSelectedMeal(id: meal.id)
                            viewModel.toggleDetailedView()
                            
                        }
                        
                        
                    }
                    .onDelete(perform: {indexSet in})
                    
                }
                .background(Color("Card Color"))
                .foregroundColor(Color("Card Color"))
                .cornerRadius(20)
                .frame(width: 300, height: 420)
                .offset(y:-40)
                Image(systemName: "chevron.compact.up")
                    .resizable()
                    .foregroundColor(Color("text color"))
                    .offset(y:10)
                    .frame(width: 50, height: 10)
                Spacer()
                
                
            }
            
            
            
        }
    }
}


struct MealView: View
{
    var id: Int
    var name: String
    var status: Color
    
    var body: some View
    {
        Text("Meal \(id+1): \(name)")
            .font(.system(size:30))
            .bold()
            .foregroundColor(.white)
            .background(status.cornerRadius(20).frame(width: 300, height: 100))
            .frame(width: 300, height: 100)
    }
}
//MARK: - DetailedView

//MARK: - Ball View
struct BallView: View
{
    var tracker: Tracker
    var body: some View
    {
        VStack
        {
            ZStack
            {
                Circle()
                    .foregroundColor(tracker.goalStatus)
                    .frame(width: tracker.size, height: tracker.size)
                    
                
                Text("\(tracker.calories)")
                    .font(.system(size:tracker.size/4, weight: .bold, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
            }
        }
        
        
    }
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContentView().preferredColorScheme($0)
        }
    }
}
