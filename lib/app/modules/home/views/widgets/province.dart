import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/province_model.dart';

import '../../controllers/home_controller.dart';


class Provinsi extends GetView<HomeController> {
  const Provinsi({
    super.key,
    required this.tipe,
  });

  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownSearch<Province>(
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
            border: OutlineInputBorder(),
            labelText: tipe == "asal" 
              ? "Provinsi Asal"
              : "Provinsi Tujuan",
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
        onChanged: (prov) {
          if (prov != null) {
            print(prov!.province);
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.provIdAsal.value = int.parse(prov.provinceId!);
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.provIdTujuan.value = int.parse(prov.provinceId!);
            }
          } else {
            print("Tidak memilih provinsi apapun");
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = true;
              controller.provIdAsal.value = 0;
            } else {
              controller.hiddenKotaTujuan.value = true;
              controller.provIdTujuan.value = 0;
            }
          }
          controller.showButton();
        },
      ),
    );
  }
}