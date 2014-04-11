//
//  GTFSCommon.m
//  iSEPTA
//
//  Created by septa on 1/2/2014
//  Copyright (c) 2013 SEPTA. All rights reserved.
//

#import "GTFSCommon.h"

@interface GTFSCommon ()

@end

@implementation GTFSCommon
{
    
}


+(NSString*) filePath
{
#if FUNCTION_NAMES_ON
    NSLog(@"GTFSCommon: filePath");
#endif
    
//    return [[NSBundle mainBundle] pathForResource:@"SEPTA" ofType:@"sqlite"];
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [NSString stringWithFormat:@"%@/SEPTA.sqlite", [paths objectAtIndex:0] ];
    
    bool b = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    
    if ( !b )  // If the file does not exist
    {
        dbPath = [[NSBundle mainBundle] pathForResource:@"SEPTA" ofType:@"sqlite"];
//        dbPath = nil;
        
        // Or uncompress the zip file to get SEPTA.sqlite
    }
    
    return dbPath;
    
}


+(NSArray*) getServiceIDFor:(GTFSRouteType) route  withOffset:(GTFSCalendarOffset) offset
{
    
#if FUNCTION_NAMES_ON
    NSLog(@"GTFSCommon: getServiceIDFor:%d", route);
#endif
    
    //    NSLog(@"filePath: %@", [self filePath]);
    FMDatabase *database = [FMDatabase databaseWithPath: [GTFSCommon filePath] ];
    
    if ( ![database open] )
    {
        [database close];
        return 0;
    }
    
    
    
    // What is the current day of the week.
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date] ];
    int weekday = [comps weekday];  // Sunday is 1, Mon (2), Tue (3), Wed (4), Thur (5), Fri (6) and Sat (7)
    

    int dayOfWeek = 0;  // Sun: 64, Mon: 32, Tue: 16, Wed: 8, Thu: 4, Fri: 2, Sat: 1
    
    
    switch (offset) {
        case kGTFSCalendarOffsetToday:
            dayOfWeek = pow(2,(7-weekday) );
            break;
            
        case kGTFSCalendarOffsetSat:
            dayOfWeek = pow(2,0); // 000 0001 (SuMoTu WeThFrSa), Saturday
            break;
            
        case kGTFSCalendarOffsetSun:
            dayOfWeek = pow(2,6); // 100 0000 (SuMoTu WeThFrSa), Sunday
            break;
            
        case kGTFSCalendarOffsetWeekday:
            dayOfWeek = pow(2,5); // 010 0000 (SuMoTu WeThFrSa), Monday
            break;
            
        case kGTFSCalendarOffsetTomorrow:

            dayOfWeek = pow(2,(7-weekday) );  // Get the current day
            
            if ( dayOfWeek & 1 )  // If day of the week is Sat (1), move it to Sunday
                dayOfWeek = 64;
            else
                dayOfWeek = dayOfWeek >> 1;  // If not Sat, shift right by 1 (or divide by 2^1)
            
            break;
            
        case kGTFSCalendarOffsetYesterday:
            
            dayOfWeek = pow(2,(7-weekday) );
            if ( dayOfWeek & 64 )
                dayOfWeek = 1;
            else
                dayOfWeek = dayOfWeek << 1;
            
            break;
            
        default:
            break;
    }
    
    //    int dayOfWeek = pow(2,(7-weekday) );
    
    
    
    NSString *queryStr = [NSString stringWithFormat:@"SELECT service_id, days FROM calendarDB WHERE (days & %d)", dayOfWeek];
    
    if ( route == kGTFSRouteTypeRail )
        queryStr = [queryStr stringByReplacingOccurrencesOfString:@"DB" withString:@"_rail"];
    else
        queryStr = [queryStr stringByReplacingOccurrencesOfString:@"DB" withString:@"_bus"];
    
    FMResultSet *results = [database executeQuery: queryStr];
    if ( [database hadError] )  // Check for errors
    {
        
        int errorCode = [database lastErrorCode];
        NSString *errorMsg = [database lastErrorMessage];
        
        NSLog(@"IVC - query failure, code: %d, %@", errorCode, errorMsg);
        NSLog(@"IVC - query str: %@", queryStr);
        
        return 0;  // If an error occurred, there's nothing else to do but exit
        
    } // if ( [database hadError] )
    
    
    NSInteger service_id = 0;
    
    NSMutableArray *serviceArr = [[NSMutableArray alloc] init];
    
    while ( [results next] )
    {
        service_id = [results intForColumn:@"service_id"];
        [serviceArr addObject: [NSNumber numberWithInt:service_id] ];
    }
    
//    return (NSInteger)service_id;
    
    [database close];

    return serviceArr;
    
}


+(NSString *) nextHoliday
{
    // Returns the date of the next holiday, or how many days until?
}



+(NSInteger) isHoliday:(GTFSRouteType) routeType withOffset:(GTFSCalendarOffset) offset
{
    
#if FUNCTION_NAMES_ON
    NSLog(@"GTFSCommon: isHoliday");
#endif
    

 
//    NSDate *today = [[NSDate alloc] init];
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
//    [offsetComponents setDay:1];
//    [offsetComponents setHour:1];
//    [offsetComponents setMinute:30];
//    // Calculate when, according to Tom Lehrer, World War III will end
//    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents
//                                                        toDate:today options:0];
 
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];  // Format is YYYYMMDD, e.g. 20131029
    NSString *now = [dateFormatter stringFromDate: [NSDate date]];
    //    now = @"20131128";
    
    NSLog(@"filePath: %@", [GTFSCommon filePath]);
    FMDatabase *database = [FMDatabase databaseWithPath: [self filePath] ];
    
    if ( ![database open] )
    {
        [database close];
        return 0;
    }
    
    NSString *queryStr = [NSString stringWithFormat:@"SELECT service_id, date FROM holidayDB WHERE date=%@", now];
    
    if ( routeType == kGTFSRouteTypeRail )
        queryStr = [queryStr stringByReplacingOccurrencesOfString:@"DB" withString:@"_rail"];
        else
            queryStr = [queryStr stringByReplacingOccurrencesOfString:@"DB" withString:@"_bus"];
            
            FMResultSet *results = [database executeQuery: queryStr];
            if ( [database hadError] )  // Check for errors
            {
                
                int errorCode = [database lastErrorCode];
                NSString *errorMsg = [database lastErrorMessage];
                
                NSLog(@"IVC - query failure, code: %d, %@", errorCode, errorMsg);
                NSLog(@"IVC - query str: %@", queryStr);
                
                return 0;  // If an error occurred, there's nothing else to do but exit
                
            } // if ( [database hadError] )
    
    
    NSInteger service_id = 0;
    while ( [results next] )
    {
        service_id = [results intForColumn:@"service_id"];
    }
    
    [database close];
    
    return service_id;
    
    
    
}


@end
