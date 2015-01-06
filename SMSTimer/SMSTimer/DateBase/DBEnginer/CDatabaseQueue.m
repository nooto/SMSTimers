//
//  CDatabasePool.m
//  CDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "CDatabaseQueue.h"
#import "CDatabase.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 CDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */
 
@implementation CDatabaseQueue

@synthesize path = _path;

+ (id)databaseQueueWithPath:(NSString*)aPath {
    
    CDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    CDBAutorelease(q);
    
    return q;
}

- (id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [CDatabase databaseWithPath:aPath];
        CDBRetain(_db);
        
        if (![_db open]) {
            NSLog(@"Could not create database queue for path %@", aPath);
            CDBRelease(self);
            return 0x00;
        }
        
        _path = CDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"CDB.%@", self] UTF8String], NULL);
    }
    
    return self;
}

- (void)dealloc {
    
    CDBRelease(_db);
    CDBRelease(_path);
    
    if (_queue) {
//        dispatch_release(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    CDBRetain(self);
    dispatch_sync(_queue, ^() { 
        [_db close];
        CDBRelease(_db);
        _db = 0x00;
    });
    CDBRelease(self);
}

- (CDatabase*)database {
    if (!_db) {
        _db = CDBReturnRetained([CDatabase databaseWithPath:_path]);
        
        if (![_db open]) {
            NSLog(@"CDatabaseQueue could not reopen database for path %@", _path);
            CDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    
    return _db;
}

- (void)inDatabase:(void (^)(CDatabase *db))block {
    CDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        CDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [CDatabaseQueue inDatabase:]");
        }
    });
    
    CDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(CDatabase *db, BOOL *rollback))block {
    CDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    CDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(CDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(CDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(CDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    CDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            else {
                [[self database] releaseSavePointWithName:name error:&err];
            }
            
        }
    });
    CDBRelease(self);
    return err;
}
#endif

@end
