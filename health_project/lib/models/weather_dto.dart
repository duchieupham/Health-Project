class WeatherDTO {
  final List<ConsolidatedWeather> consolidatedWeather;
  final String time;
  final String sunRise;
  final String sunSet;
  final String timezoneName;
  final Parent parent;
  final List<Sources> sources;
  final String title;
  final String locationType;
  final int woeid;
  final String lattLong;
  final String timezone;

  const WeatherDTO(
      {required this.consolidatedWeather,
      required this.time,
      required this.sunRise,
      required this.sunSet,
      required this.timezoneName,
      required this.parent,
      required this.sources,
      required this.title,
      required this.locationType,
      required this.woeid,
      required this.lattLong,
      required this.timezone});

  factory WeatherDTO.fromJson(Map<String, dynamic> json) {
    final List<ConsolidatedWeather> _consolidatedWeathers = [];
    json['consolidated_weather'].forEach((v) {
      _consolidatedWeathers.add(new ConsolidatedWeather.fromJson(v));
    });
    final List<Sources> _sources = [];
    json['sources'].forEach((v) {
      _sources.add(Sources.fromJson(v));
    });
    return WeatherDTO(
      consolidatedWeather: _consolidatedWeathers,
      time: json['time'],
      sunRise: json['sun_rise'],
      sunSet: json['sun_set'],
      timezoneName: json['timezone_name'],
      parent: Parent.fromJson(json['parent']),
      sources: _sources,
      title: json['title'],
      locationType: json['location_type'],
      woeid: json['woeid'],
      lattLong: json['latt_long'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consolidated_weather'] =
        this.consolidatedWeather.map((v) => v.toJson()).toList();
    data['time'] = this.time;
    data['sun_rise'] = this.sunRise;
    data['sun_set'] = this.sunSet;
    data['timezone_name'] = this.timezoneName;
    data['parent'] = this.parent.toJson();
    data['sources'] = this.sources.map((v) => v.toJson()).toList();
    data['title'] = this.title;
    data['location_type'] = this.locationType;
    data['woeid'] = this.woeid;
    data['latt_long'] = this.lattLong;
    data['timezone'] = this.timezone;
    return data;
  }
}

class ConsolidatedWeather {
  final int id;
  final String weatherStateName;
  final String weatherStateAbbr;
  final String windDirectionCompass;
  final String created;
  final String applicableDate;
  final double minTemp;
  final double maxTemp;
  final double theTemp;
  final double windSpeed;
  final double windDirection;
  final double airPressure;
  final int humidity;
  final double visibility;
  final int predictability;

  const ConsolidatedWeather({
    required this.id,
    required this.weatherStateName,
    required this.weatherStateAbbr,
    required this.windDirectionCompass,
    required this.created,
    required this.applicableDate,
    required this.minTemp,
    required this.maxTemp,
    required this.theTemp,
    required this.windSpeed,
    required this.windDirection,
    required this.airPressure,
    required this.humidity,
    required this.visibility,
    required this.predictability,
  });

  factory ConsolidatedWeather.fromJson(Map<String, dynamic> json) {
    return ConsolidatedWeather(
      id: json['id'],
      weatherStateName: json['weather_state_name'],
      weatherStateAbbr: json['weather_state_abbr'],
      windDirectionCompass: json['wind_direction_compass'],
      created: json['created'],
      applicableDate: json['applicable_date'],
      minTemp: json['min_temp'],
      maxTemp: json['max_temp'],
      theTemp: json['the_temp'],
      windSpeed: json['wind_speed'],
      windDirection: json['wind_direction'],
      airPressure: json['air_pressure'],
      humidity: json['humidity'],
      visibility: json['visibility'],
      predictability: json['predictability'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weather_state_name'] = this.weatherStateName;
    data['weather_state_abbr'] = this.weatherStateAbbr;
    data['wind_direction_compass'] = this.windDirectionCompass;
    data['created'] = this.created;
    data['applicable_date'] = this.applicableDate;
    data['min_temp'] = this.minTemp;
    data['max_temp'] = this.maxTemp;
    data['the_temp'] = this.theTemp;
    data['wind_speed'] = this.windSpeed;
    data['wind_direction'] = this.windDirection;
    data['air_pressure'] = this.airPressure;
    data['humidity'] = this.humidity;
    data['visibility'] = this.visibility;
    data['predictability'] = this.predictability;
    return data;
  }
}

class Parent {
  final String title;
  final String locationType;
  final int woeid;
  final String lattLong;

  const Parent({
    required this.title,
    required this.locationType,
    required this.woeid,
    required this.lattLong,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      title: json['title'],
      locationType: json['location_type'],
      woeid: json['woeid'],
      lattLong: json['latt_long'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['location_type'] = this.locationType;
    data['woeid'] = this.woeid;
    data['latt_long'] = this.lattLong;
    return data;
  }
}

class Sources {
  final String title;
  final String slug;
  final String url;
  final int crawlRate;

  const Sources({
    required this.title,
    required this.slug,
    required this.url,
    required this.crawlRate,
  });

  factory Sources.fromJson(Map<String, dynamic> json) {
    return Sources(
      title: json['title'],
      slug: json['slug'],
      url: json['url'],
      crawlRate: json['crawl_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['url'] = this.url;
    data['crawl_rate'] = this.crawlRate;
    return data;
  }
}
