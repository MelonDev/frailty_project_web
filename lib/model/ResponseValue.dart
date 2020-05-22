class ResponseValue {

  final String value;

  ResponseValue({this.value});

  ResponseValue.fromJson(Map<String, dynamic> json)
      : value = json['value'];

}