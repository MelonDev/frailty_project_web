class Province {
  final int PROVINCE_ID;
  final String PROVINCE_CODE;
  final String PROVINCE_NAME;
  final int GEO_ID;

  Province(
      {this.PROVINCE_ID,
      this.PROVINCE_CODE,
      this.PROVINCE_NAME,
      this.GEO_ID});

  Province.fromJson(Map<String, dynamic> json)
      : PROVINCE_ID = json['PROVINCE_ID'],
        PROVINCE_CODE = json['PROVINCE_CODE'],
        PROVINCE_NAME = json['PROVINCE_NAME'],
        GEO_ID = json['GEO_ID'];
}
