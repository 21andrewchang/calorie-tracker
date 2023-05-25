//
//  DetailedView.swift
//  Ongry
//
//  Created by Andrew Chang on 4/1/23.
//

import SwiftUI

struct DetailedView: View
{
    @State var justDeleted = false
    @StateObject var viewModel: DataManager
    @State var isPresentingConfirm = false
    var body: some View
    {
        let tracker = viewModel.Ongry
            ZStack
            {
 
                            
                Rectangle()
                    .mask(RoundedRectangle(cornerRadius: 30,style: .continuous))
                    .foregroundColor(Color("Card Color"))
                    .frame(width: 360, height: 600)
                    .offset(y:0)
                
                if !viewModel.Ongry.justDeleted
                {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color("Card Color"))
                    .frame(width: 360, height: 600)
                    .onTapGesture {
                        viewModel.toggleDetailedView()
                    }
                VStack{
                    Text("Meal \(viewModel.Ongry.todaymeals[viewModel.Ongry.selectedMeal].id+1)")
                        .padding(.top, 50)
                        .font(.system(size:50))
                        .bold()
                        .foregroundColor(Color("text color"))
                        .offset(y:50)
                    Spacer()
                }

                VStack
                    {
                        Text("\(viewModel.Ongry.todaymeals[viewModel.Ongry.selectedMeal].name) id: \(viewModel.Ongry.todaymeals[viewModel.Ongry.selectedMeal].id)" )
                            .font(.system(size:45))
                            .bold()
                            .foregroundColor(Color("text color"))
                        
                        Text("Calories : \(viewModel.Ongry.todaymeals[viewModel.Ongry.selectedMeal].calories)")
                            .font(.system(size:30))
                            .bold()
                            .foregroundColor(Color("text color"))
                        
                        Text("Protein : \(viewModel.Ongry.todaymeals[viewModel.Ongry.selectedMeal].protein)")
                            .font(.system(size:30))
                            .bold()
                            .foregroundColor(Color("text color"))
                        
                        Text("Carbs : \(viewModel.Ongry.todaymeals[tracker.selectedMeal].carbs)")
                            .font(.system(size:30))
                            .bold()
                            .foregroundColor(Color("text color"))
                        
                        Text("Fat : \(tracker.todaymeals[tracker.selectedMeal].fat)")
                            .font(.system(size:30))
                            .bold()
                            .foregroundColor(Color("text color"))
                        if tracker.todaymeals[tracker.selectedMeal].days > 1
                        {
                            Text("This meal was created \(tracker.todaymeals[tracker.selectedMeal].days) days ago")
                                .font(.system(size: 20))
                                .foregroundColor(Color("text color"))
                                .offset(y: 20)
                        }
                        else
                        {
                            Text("This meal was created today: \(tracker.todaymeals[tracker.selectedMeal].days)")
                                .font(.system(size: 20))
                                .foregroundColor(Color("text color"))
                                .offset(y: 20)
                        }
                        
                        Button
                        {
                            isPresentingConfirm = true
                            
                        }
                    label:
                        {
                            Text("Delete")
                                .font(.system(size:30, weight: .bold))
                                .foregroundColor(.white)
                                .padding(30)
                                .offset(y:-15)
                                .frame(width: 250, height: 60)
                                .background(Color("Red").cornerRadius(10).offset(y: -15))
                        }
                        .offset(y:90)
                        .confirmationDialog("Are you sure?",
                                            isPresented: $isPresentingConfirm) {
                            Button("Delete item?", role: .destructive)
                            {
                                viewModel.toggleJustDeleted()
                                viewModel.toggleDetailedView()
                                //viewModel.deleteMealfromContainer()
                                viewModel.deleteMealfromDB(meal: viewModel.Ongry.todaymeals[viewModel.Ongry.selectedMeal].name)
                                viewModel.deleteMeal(index: viewModel.Ongry.selectedMeal)
                                viewModel.checkSize()
                                print(viewModel.Ongry.selectedMeal)
                                
                                
                            }
                        }
                    message: {
                                Text("You cannot undo this action")
                              }
                        
                        }
                        
                    }
                    

                    



                
                }
                Image(systemName: "chevron.compact.up")
                    .resizable()
                    .foregroundColor(Color("text color"))
                    .offset(y:280)
                    .frame(width: 50, height: 10)
        }
    }


struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(viewModel: DataManager())
    }
}
