//
//  DayCarouselView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-17.
//

import SwiftUI

struct DayCarouselView: View {
    
    @State var dayTabs = [
        DayTab(day: "Monday"),
        DayTab(day: "Tuesday"),
        DayTab(day: "Wednesday"),
        DayTab(day: "Thursday"),
        DayTab(day: "Friday"),
        DayTab(day: "Saturday"),
        DayTab(day: "Sunday")
    ]
    
    @State var tabs: [Tab] = [
        Tab(title: "day 1"),
        Tab(title: "day 2"),
        Tab(title: "day 3"),
        Tab(title: "day 4")
    ]
    
    @Binding var currentIndex: Int
    
    @State var tempIdex = 0
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        TabView(selection: $tempIdex) {
            ForEach(tabs) { tab in
                VStack(spacing: 18) {
                    
                    Spacer()
                    
                    Text(tab.title)
                        .font(.title.bold())
                    Text("CHORES")
                        .padding()
                        .font(.title2.bold())
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .cornerRadius(20)
                .padding(.horizontal, 40)
                .overlay(
                    GeometryReader{ proxy in
                        Color.clear
                            .preference(key: OffsetKey.self, value: proxy.frame(in: .global).minX )
                    }
                )
                .onPreferenceChange(OffsetKey.self, perform: { offset in
                    self.offset = offset
                })
                .tag(getIndex(tab: tab))
                
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            .padding(.top, 20)
            .onChange(of: tempIdex) { newValue in
                
                if tempIdex == 0 && offset == 0{
                    tempIdex = tabs.count - 2
                }
                if tempIdex == tabs.count - 1 && offset == 0{
                    tempIdex = 1
                }
            }
            .onAppear {
                guard var first = tabs.first else {
                    return
                }
                guard var last = tabs.last else {
                    return
                }
                
                first.id = UUID().uuidString
                last.id = UUID().uuidString
                
                tabs.append(first)
                tabs.insert(last, at: 0)
                
                tempIdex = 1
            }
    }
    
    func getIndex(tab: Tab) -> Int {
        let index = tabs.firstIndex { currentTab in
            return currentTab.id == tab.id
        } ?? 0
        return index
    }
}

struct DayTab: Identifiable, Hashable {
    var id = UUID().uuidString
    var day: String
}

struct Tab: Identifiable, Hashable {
    var id = UUID().uuidString
    var title: String
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
