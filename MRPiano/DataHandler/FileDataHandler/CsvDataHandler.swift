//
//  CsvDataHandler.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import Foundation
import TabularData

struct CsvDataHandler {
    private var filePath: String
    private var dataFrame: DataFrame = DataFrame()
    
    init(filepath:String) {
        self.filePath = filepath
        readCsv()
        addEndTimeColumn()
        printDataFrameContents()
    }
    
    mutating func readCsv() {
        guard let path = Bundle.main.url(forResource: filePath, withExtension: "csv") else {
            print("csvファイルがないよ")
            return
        }
        
        do {
            dataFrame = try DataFrame(contentsOfCSVFile: path, columns: ["ID", "Onset Time", "Duration", "MIDI Note Number","Note Name"])
        } catch {
            print("エラー: \(error)")
            return
        }
    }
    
    mutating func addEndTimeColumn() {
        let onsetTimeColumn = dataFrame["Onset Time",Double.self]
        let durationColumn = dataFrame["Duration",Double.self]
        let endTimeColumn = onsetTimeColumn + durationColumn
        dataFrame.append(column: Column(name: "End Time", contents: endTimeColumn))
    }
    
    func printDataFrameContents() {
        print(dataFrame)
    }
    
    func getDataFrame() -> DataFrame {
        return self.dataFrame
    }
    
    func lastNoteTime() -> Double {
        let endTimeColumn = dataFrame["End Time",Double.self]
        return endTimeColumn.max()!
    }
}

