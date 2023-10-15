import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ongkir/app/data/models/user_model.dart';

void main() async {

  Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
  final response = await http.get(
    url,
    headers: {
      "key" : "ff3b7f2ad44df5fbbbebeb43ebd8b1d0",
    },
  );

  var data = jsonDecode(response.body) as Map<String, dynamic>;

  print(response.body);
}
