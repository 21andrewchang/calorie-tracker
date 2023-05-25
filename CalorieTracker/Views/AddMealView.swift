//
//  AddMealView.swift
//  Ongry
//
//  Created by Andrew Chang on 4/1/23.
//

import SwiftUI

struct AddMealView: View
{
    @StateObject var viewModel: DataManager
    @State var isFocused1: Bool = false
    @State var isFocused2: Bool = false
    @State var isFocused3: Bool = false
    @State var isFocused4: Bool = false
    @State var isFocused5: Bool = false
    
    @State var caloriesInput: String = ""
    @State var mealcals: String = "0"
    
    @State var proteinInput: String = ""
    @State var mealprotein: String = "0"
    
    @State var carbsInput: String = ""
    @State var mealcarbs: String = "0"
    
    @State var fatInput: String = ""
    @State var mealfat: String = "0"
    
    @State var nameInput: String = ""
    @State var mealname: String = "unnamed meal"
    @FocusState private var nameInFocus: Bool
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 30 )
                .foregroundColor(Color("Card Color"))
                .cornerRadius(30)
                .frame(width: 360, height: 500)
                .offset(y: 25)
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("Card Color").opacity(0))
                    .frame(width: 300, height: 320)
                    .offset(y: -17)

            VStack
                {
                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .foregroundColor(Color("Arrow").opacity(0.5))
                        .offset(y:28)
                        .frame(width: 50, height: 10)
                    
                    TextField("Calories", text: $caloriesInput, onEditingChanged: { (changed) in isFocused1 = changed})
                        .focused($nameInFocus)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                self.nameInFocus = true
                            }
                        }
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("text color"))
                        .font(.system(size: 20.0, design: .rounded))
                        .padding(30)
                        .frame(width: 300, height: 50)
                        .background(isFocused1 ? Color.gray.opacity(0.2) : Color.gray.opacity(0))
                        .cornerRadius(10)
                        .offset(y:40)


                    TextField("Protein", text: $proteinInput, onEditingChanged: { (changed) in isFocused2 = changed})
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("text color"))
                        .font(.system(size: 20.0, design: .rounded))
                        .padding(30)
                        .frame(width: 300, height: 50)
                        .background(isFocused2 ? Color.gray.opacity(0.2) : Color.gray.opacity(0))
                        .cornerRadius(10)
                        .offset(y:40)

                    TextField("Carbs", text: $carbsInput, onEditingChanged: { (changed) in isFocused3 = changed})
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("text color"))
                        .font(.system(size: 20.0, design: .rounded))
                        .padding(30)
                        .frame(width: 300, height: 50)
                        .background(isFocused3 ? Color.gray.opacity(0.2) : Color.gray.opacity(0))
                        .cornerRadius(10)
                        .offset(y:40)

                    TextField("Fat", text: $fatInput, onEditingChanged: { (changed) in isFocused4 = changed})
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("text color"))
                        .font(.system(size: 20.0, design: .rounded))
                        .padding(30)
                        .frame(width: 300, height: 50)
                        .background(isFocused4 ? Color.gray.opacity(0.2) : Color.gray.opacity(0))
                        .cornerRadius(10)
                        .offset(y:40)


                    HStack
                    {

                        TextField("Name", text: $nameInput, onEditingChanged: { (changed) in isFocused5 = changed})
                            
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("text color"))
                            .font(.system(size: 20.0, design: .rounded))
                            .padding(30)
                            .frame(width: 300, height: 50)
                            .background(isFocused5 ? Color.gray.opacity(0.2) : Color.gray.opacity(0))
                            .cornerRadius(10)
                            .offset(y: 40)
                    }
                    Button
                    {
                        if caloriesInput != ""
                        {
                            mealcals = caloriesInput
                            mealprotein = proteinInput
                            mealcarbs = carbsInput
                            mealfat = fatInput
                            mealname = nameInput
                            
                            
                            
                            //MARK: - DataModel Input Meal
                            guard !mealname.isEmpty else {return}
                            viewModel.addMealtoDB(name: String(mealname) , calories: Int(mealcals) ?? 0, protein: Int(mealprotein) ?? 0,carbs: Int(mealcarbs) ?? 0,fat: Int(mealfat) ?? 0, date: Date())
                            caloriesInput = ""
                            proteinInput = ""
                            carbsInput = ""
                            fatInput = ""
                            nameInput = ""
                            viewModel.checkSize()
                        }
                    }
                label:
                    {
                        Text("Add Meal")
                            .font(.system(size:25, weight: .bold))
                            .foregroundColor(.white)
                            .padding(30)
                            .offset(y: -15)
                            .frame(width: 180, height: 60)
                            .background(Color("Green").cornerRadius(10).offset(y: -15))
                    }
                    .padding(.top, 100)
                }
            }//vstack
        }

    }
}


struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(viewModel: DataManager())
    }
}
