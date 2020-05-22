class ResponseIntValue {

  final int value;

  ResponseIntValue({this.value});

  ResponseIntValue.fromJson(Map<String, dynamic> json)
      : value = json['value'];

}