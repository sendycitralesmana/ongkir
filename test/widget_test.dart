import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ongkir/app/data/models/user_model.dart';

void main() async {

  // initial
  // final data = (jsonDecode(response.body) as Map<String, dynamic>)['data']
  //     as Map<String, dynamic>;

  // print(data['first_name'] + "" + data['last_name']);

  // post
  Uri url = Uri.parse("https://reqres.in/api/users");
  final response =
      await http.post(url, body: {"name": "morpheus", "job": "leader"});
  print(response.body);

  // get
  // Uri url = Uri.parse("https://reqres.in/api/users/2");
  // final response = await http.get(url);

  // get
  // final user =
  //     UserModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  // final data = user.data;
  // final support = user.support;
  // print("${data.firstName} ${data.lastName}");



  // 
  // final myJson = userModelToJson(user);
  // print(myJson);
}
