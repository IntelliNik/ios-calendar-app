//
//  SearchEventView.swift
//  swift-calendar-app
//
//  Created by Schulte, Niklas on 01.01.22.
//

import SwiftUI

struct SearchEventView: View {    
    @State private var query = ""
    
    @State var saveSucessful = true
    @State var showAddEventSheet = false

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .forward)])
    private var events: FetchedResults<Event>
           
    var body: some View {
        NavigationView {
            if query.isEmpty{
                Text("Searching for events...")
                    .listStyle(.plain)
                    .navigationTitle("Search Events")
            } else {
                ZStack{
                    NavigationView {
                        List {
                            ForEach((0..<events.count), id: \.self) { index in
                                if (index < events.count) {
                                    NavigationLink(
                                        destination: ShowEventView(event: events[index]).navigationBarBackButtonHidden(true)
                                    ) {
                                        Text("Name: \(events[index].name ?? "") in Calendar: \(events[index].calendar?.name ?? "No Calendar")")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if self.query != "" {
                Button(action: {
                    self.query = ""
                })
                {
                    Image(systemName: "multiply.circle")
                    .foregroundColor(Color.gray)
                }
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search events")
        .onChange(of: query) { newValue in
            events.nsPredicate = searchPredicate(query: newValue)
         }
        
    }
        
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty { return nil }
        return NSPredicate(format: "name BEGINSWITH %@", query)
    }
}


struct SearchEventView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEventView()
    }
}
