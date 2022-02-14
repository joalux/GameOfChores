//
//  SettingsVuew.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-13.
//

import SwiftUI
import ShortcutFoundation

struct SettingsVuew: View {
    var body: some View {
        Text(String.getDateString(date: Date(), format: .weekday))
    }
}

struct SettingsVuew_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVuew()
    }
}
