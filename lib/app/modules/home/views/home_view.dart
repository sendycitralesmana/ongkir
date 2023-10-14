import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/province_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongkos Kirim Indonesia'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
              // item builder -> menampilkan nama provinsi ketika dropdown di klik
              itemBuilder: (context, item, isSelected) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "${item.province}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              },
              showSearchBox: true,
            ),
            itemAsString: (item) => item.province!,   // menampilkan nama province ketika dipilih
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi",
                hintText: "Cari Provinsi"
              ),
            ),
            asyncItems: (String filter) async {
              Uri url =
                  Uri.parse("https://api.rajaongkir.com/starter/province");

              try {
                final response = await http.get(
                  url,
                  headers: {
                    "key": "ff3b7f2ad44df5fbbbebeb43ebd8b1d0",
                  },
                );

                var data = jsonDecode(response.body) as Map<String, dynamic>;

                var statusCode = data["rajaongkir"]["status"]["code"];

                if (statusCode != 200) {
                  throw data["rajaongkir"]["status"]["description"];
                }

                var listAllProvince =
                    data["rajaongkir"]["results"] as List<dynamic>;

                var models = Province.fromJsonList(listAllProvince);
                return models;
              } catch (err) {
                print(err);
                return List<Province>.empty();
              }
            },
            onChanged: (Province? data) {
              print(data);
            },
          ),
        ],
      ),
    );
  }
}
