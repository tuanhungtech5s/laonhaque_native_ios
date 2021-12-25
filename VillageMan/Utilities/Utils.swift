//
//  Date+Ext.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import Foundation

extension String {
    var removeWordCharacters: String {
        String(self.filter({ "0"..."9" ~= $0 }))
    }
}
