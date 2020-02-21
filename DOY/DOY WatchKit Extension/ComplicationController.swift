//
//  ComplicationController.swift
//  DOY WatchKit Extension
//
//  Created by Brad Trantham on 10/18/15.
//  Copyright © 2015 Illegal Dependency. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([CLKComplicationTimeTravelDirections.Forward, CLKComplicationTimeTravelDirections.Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        if complication.family == .ModularSmall {
            let date = NSDate() // now
            let cal = NSCalendar.currentCalendar()
            let day = cal.ordinalityOfUnit(.Day, inUnit: .Year, forDate: date)
            
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "\(day)")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
            handler(timelineEntry)
        }
        else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        let cal = NSCalendar.currentCalendar()
        let day = cal.ordinalityOfUnit(.Day, inUnit: .Year, forDate: date)
        
        let template = CLKComplicationTemplateModularSmallSimpleText()
        template.textProvider = CLKSimpleTextProvider(text: "\(day)")
        
        let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
        handler([timelineEntry])
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        //handler(nil);
        // Update hourly
        handler(NSDate(timeIntervalSinceNow: 60*60))
    }
    
    func requestedUpdateDidBegin() {
        
        //Not shown: decide if you actually need to update your complication.
        //If you do, execute the following code:
        
        let server=CLKComplicationServer.sharedInstance()
        
        for comp in (server.activeComplications)! {
            server.reloadTimelineForComplication(comp)
        }
    }
    
    
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate? = nil
        switch complication.family {
        case .ModularSmall:
            let modularTemplate = CLKComplicationTemplateModularSmallSimpleText()
            modularTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            template = modularTemplate
        case .ModularLarge:
            template = nil
        case .UtilitarianSmall:
            template = nil
        case .UtilitarianLarge:
            template = nil
        case .CircularSmall:
            template = nil
        }
        handler(template)
    }
    
}
