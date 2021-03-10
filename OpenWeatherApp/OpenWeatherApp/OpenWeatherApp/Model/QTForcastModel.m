#import "QTForcastModel.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface QTForcastModel (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTCity (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTCoord (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTList (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTClouds (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTMainClass (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTRain (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTSys (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTWeather (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTWind (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

// These enum-like reference types are needed so that enum
// values can be contained by NSArray and NSDictionary.

@implementation QTPod
+ (NSDictionary<NSString *, QTPod *> *)values
{
    static NSDictionary<NSString *, QTPod *> *values;
    return values = values ? values : @{
        @"d": [[QTPod alloc] initWithValue:@"d"],
        @"n": [[QTPod alloc] initWithValue:@"n"],
    };
}

+ (QTPod *)d { return QTPod.values[@"d"]; }
+ (QTPod *)n { return QTPod.values[@"n"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTPod.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation QTMainEnum
+ (NSDictionary<NSString *, QTMainEnum *> *)values
{
    static NSDictionary<NSString *, QTMainEnum *> *values;
    return values = values ? values : @{
        @"Clear": [[QTMainEnum alloc] initWithValue:@"Clear"],
        @"Clouds": [[QTMainEnum alloc] initWithValue:@"Clouds"],
        @"Rain": [[QTMainEnum alloc] initWithValue:@"Rain"],
    };
}

+ (QTMainEnum *)clear { return QTMainEnum.values[@"Clear"]; }
+ (QTMainEnum *)clouds { return QTMainEnum.values[@"Clouds"]; }
+ (QTMainEnum *)rain { return QTMainEnum.values[@"Rain"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTMainEnum.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation QTDescription
+ (NSDictionary<NSString *, QTDescription *> *)values
{
    static NSDictionary<NSString *, QTDescription *> *values;
    return values = values ? values : @{
        @"broken clouds": [[QTDescription alloc] initWithValue:@"broken clouds"],
        @"clear sky": [[QTDescription alloc] initWithValue:@"clear sky"],
        @"few clouds": [[QTDescription alloc] initWithValue:@"few clouds"],
        @"light rain": [[QTDescription alloc] initWithValue:@"light rain"],
        @"overcast clouds": [[QTDescription alloc] initWithValue:@"overcast clouds"],
        @"scattered clouds": [[QTDescription alloc] initWithValue:@"scattered clouds"],
    };
}

+ (QTDescription *)brokenClouds { return QTDescription.values[@"broken clouds"]; }
+ (QTDescription *)clearSky { return QTDescription.values[@"clear sky"]; }
+ (QTDescription *)fewClouds { return QTDescription.values[@"few clouds"]; }
+ (QTDescription *)lightRain { return QTDescription.values[@"light rain"]; }
+ (QTDescription *)overcastClouds { return QTDescription.values[@"overcast clouds"]; }
+ (QTDescription *)scatteredClouds { return QTDescription.values[@"scattered clouds"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTDescription.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

QTForcastModel *_Nullable QTForcastModelFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [QTForcastModel fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

QTForcastModel *_Nullable QTForcastModelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return QTForcastModelFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable QTForcastModelToData(QTForcastModel *forcastModel, NSError **error)
{
    @try {
        id json = [forcastModel JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable QTForcastModelToJSON(QTForcastModel *forcastModel, NSStringEncoding encoding, NSError **error)
{
    NSData *data = QTForcastModelToData(forcastModel, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation QTForcastModel
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"cod": @"cod",
        @"message": @"message",
        @"cnt": @"cnt",
        @"list": @"list",
        @"city": @"city",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return QTForcastModelFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTForcastModelFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTForcastModel alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _list = map(_list, λ(id x, [QTList fromJSONDictionary:x]));
        _city = [QTCity fromJSONDictionary:(id)_city];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTForcastModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTForcastModel.properties.allValues] mutableCopy];

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"list": map(_list, λ(id x, [x JSONDictionary])),
        @"city": [_city JSONDictionary],
    }];

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return QTForcastModelToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTForcastModelToJSON(self, encoding, error);
}
@end

@implementation QTCity
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"name": @"name",
        @"coord": @"coord",
        @"country": @"country",
        @"population": @"population",
        @"timezone": @"timezone",
        @"sunrise": @"sunrise",
        @"sunset": @"sunset",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTCity alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _coord = [QTCoord fromJSONDictionary:(id)_coord];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTCity.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTCity.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in QTCity.properties) {
        id propertyName = QTCity.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"coord": [_coord JSONDictionary],
    }];

    return dict;
}
@end

@implementation QTCoord
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"lat": @"lat",
        @"lon": @"lon",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTCoord alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTCoord.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:QTCoord.properties.allValues];
}
@end

@implementation QTList
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"dt": @"dt",
        @"main": @"main",
        @"weather": @"weather",
        @"clouds": @"clouds",
        @"wind": @"wind",
        @"sys": @"sys",
        @"dt_txt": @"dtTxt",
        @"rain": @"rain",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTList alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _main = [QTMainClass fromJSONDictionary:(id)_main];
        _weather = map(_weather, λ(id x, [QTWeather fromJSONDictionary:x]));
        _clouds = [QTClouds fromJSONDictionary:(id)_clouds];
        _wind = [QTWind fromJSONDictionary:(id)_wind];
        _sys = [QTSys fromJSONDictionary:(id)_sys];
        _rain = [QTRain fromJSONDictionary:(id)_rain];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTList.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTList.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in QTList.properties) {
        id propertyName = QTList.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"main": [_main JSONDictionary],
        @"weather": map(_weather, λ(id x, [x JSONDictionary])),
        @"clouds": [_clouds JSONDictionary],
        @"wind": [_wind JSONDictionary],
        @"sys": [_sys JSONDictionary],
        @"rain": NSNullify([_rain JSONDictionary]),
    }];

    return dict;
}
@end

@implementation QTClouds
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"all": @"all",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTClouds alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTClouds.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:QTClouds.properties.allValues];
}
@end

@implementation QTMainClass
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"temp": @"temp",
        @"feels_like": @"feelsLike",
        @"temp_min": @"tempMin",
        @"temp_max": @"tempMax",
        @"pressure": @"pressure",
        @"sea_level": @"seaLevel",
        @"grnd_level": @"grndLevel",
        @"humidity": @"humidity",
        @"temp_kf": @"tempKf",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTMainClass alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTMainClass.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTMainClass.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in QTMainClass.properties) {
        id propertyName = QTMainClass.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}
@end

@implementation QTRain
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"3h": @"the3H",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTRain alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTRain.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTRain.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in QTRain.properties) {
        id propertyName = QTRain.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}
@end

@implementation QTSys
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"pod": @"pod",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTSys alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _pod = [QTPod withValue:(id)_pod];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTSys.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTSys.properties.allValues] mutableCopy];

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"pod": [_pod value],
    }];

    return dict;
}
@end

@implementation QTWeather
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"main": @"main",
        @"description": @"theDescription",
        @"icon": @"icon",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTWeather alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _main = [QTMainEnum withValue:(id)_main];
        _theDescription = [QTDescription withValue:(id)_theDescription];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTWeather.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTWeather.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in QTWeather.properties) {
        id propertyName = QTWeather.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"main": [_main value],
        @"description": [_theDescription value],
    }];

    return dict;
}
@end

@implementation QTWind
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"speed": @"speed",
        @"deg": @"deg",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTWind alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTWind.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:QTWind.properties.allValues];
}
@end

NS_ASSUME_NONNULL_END
