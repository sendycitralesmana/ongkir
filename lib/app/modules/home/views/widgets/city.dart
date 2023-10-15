import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../city_model.dart';
import '../../controllers/home_controller.dart';

class Kota extends GetView<HomeController> {
  const Kota({
    super.key,
    required this.provId,
    required this.tipe,
  });

  final int provId;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownSearch<City>(
        popupProps: PopupProps.menu(
          // item builder -> menampilkan nama provinsi ketika dropdown di klik
          itemBuilder: (context, item, isSelected) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "${item.type} ${item.cityName}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          },
          showSearchBox: true,
        ),
        itemAsString: (item) => "${item.type} ${item.cityName}",   // menampilkan nama province ketika dipilih
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: tipe == "asal" ? "Kota / Kabupaten Asal" : "Kota / Kabupaten Tujuan",
            hintText: "Cari Kota / Kabupaten"
          ),
        ),
        asyncItems: (String filter) async {
          Uri url =
              Uri.parse("https://api.rajaongkir.com/starter/city?province=$provId");
    
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
    
            var listAllCity =
                data["rajaongkir"]["results"] as List<dynamic>;
    
            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (err) {
            print(err);
            return List<City>.empty();
          }
        },
        onChanged: (cityValue) {
          if (cityValue != null) {
            print(cityValue!.province);
            if (tipe == "asal") {
              controller.kotaIdAsal.value = int.parse(cityValue.cityId!);
            } else {
              controller.kotaIdTujuan.value = int.parse(cityValue.cityId!);
            }
            controller.showButton();
          } else {
            print("Tidak memilih provinsi apapun");
            if (tipe == "asal") {
              print("Tidak memilih kota / kabupaten apapun");
              controller.kotaIdAsal.value = 0;
            } else {
              print("Tidak memilih kota / kabupaten apapun");
              controller.kotaIdTujuan.value = 0;
            }
          }
        },
      ),
    );
  }
}