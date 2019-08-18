//
//  ContentView.swift
//  SHAOnDevice
//
//  Created by Alexander Cyon on 2019-08-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
