import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/province_model.dart';

import '../city_model.dart';
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
          Provinsi(),
          Obx(() => controller.hiddenKota.isTrue 
            ? SizedBox()
            : Kota(provId: controller.provId.value),
          ),
        ],
      ),
    );
  }
}

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    super.key,
  });

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
        onChanged: (prov) {
          if (prov != null) {
            print(prov!.province);
            controller.hiddenKota.value = false;
            controller.provId.value = int.parse(prov.provinceId!);
          } else {
            print("Tidak memilih provinsi apapun");
            controller.hiddenKota.value = true;
            controller.provId.value = 0;
          }
        },
      ),
    );
  }
}

class Kota extends StatelessWidget {
  const Kota({
    super.key,
    required this.provId,
  });

  final int provId;

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
            labelText: "Kota / Kabupaten",
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
            print(cityValue!.cityName);
          } else {
            print("Tidak memilih kota / kabupaten apapun");
          }
        },
      ),
    );
  }
}