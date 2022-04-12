class LocalSite {
  final String? operator;
  final String? region;
  final String? subRegion;
  final String? cluster;
  final String? siteID;
  final String? siteName;
  final String? siteKeeperName;
  final String? siteKeeperPhone;
  final String? siteType;
  final String? survey;
  final String? longitude;
  final String? latitude;
  final String? weather;
  final String? temperature;
  final String? imagePath;

  LocalSite({
    this.operator,
    this.region,
    this.subRegion,
    this.cluster,
    this.siteID,
    this.siteName,
    this.siteKeeperName,
    this.siteKeeperPhone,
    this.siteType,
    this.survey,
    this.longitude,
    this.latitude,
    this.weather,
    this.temperature,
    this.imagePath,
  });

  factory LocalSite.fromJson(Map<String, String> json) => LocalSite(
        operator: json['operator'],
        region: json['region'],
        subRegion: json['subRegion'],
        cluster: json['cluster'],
        siteID: json['siteID'],
        siteName: json['siteName'],
        siteKeeperName: json['siteKeeperName'],
        siteKeeperPhone: json['siteKeeperPhone'],
        siteType: json['siteType'],
        survey: json['survey'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        weather: json['weather'],
        temperature: json['temperature'],
        imagePath: json['image'],
      );

  Map<String, String> toJson() => {
        'operator': operator!,
        'region': region!,
        'subRegion': subRegion!,
        'cluster': cluster!,
        'siteID': siteID!,
        'siteName': siteName!,
        'siteKeeperName': siteKeeperName!,
        'siteKeeperPhone': siteKeeperPhone!,
        'siteType': siteType!,
        'survey': survey!,
        'latitude': latitude!,
        'longitude': longitude!,
        'weather': weather!,
        'temperature': temperature!,
        'imagePath': imagePath!,
      };
}
