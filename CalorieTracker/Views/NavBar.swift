//
//  NavBar.swift
//  Ongry
//
//  Created by Andrew Chang on 3/29/23.
//

import SwiftUI

enum Tab: String, Hashable, CaseIterable{
    case person
    case house
    case trophy
}
                
struct NavBar: View {
    @Binding var selectedTab: Tab
    
    private var fillImage: String{
        selectedTab.rawValue + ".fill"
    }
    var body: some View
    {
        VStack{
            HStack{
                ForEach(Tab.allCases, id:\.rawValue)
                {
                    tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                        .foregroundColor(selectedTab == tab ? .gray : .gray)
                        .font(.system(size: 22))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.2))
                            {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial.opacity(0.4))
            .cornerRadius(30)
            .padding()
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(selectedTab: .constant(.house))
    }
}
