import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ongkir/app/modules/home/courier_model.dart';

class HomeController extends GetxController {
  var hiddenKotaAsal = true.obs;
  var provIdAsal = 0.obs;
  var kotaIdAsal = 0.obs;

  var hiddenKotaTujuan = true.obs;
  var provIdTujuan = 0.obs;
  var kotaIdTujuan = 0.obs;

  var hiddenButton = true.obs;
  var kurir = "".obs;

  double berat = 0.0;
  String satuan = "gram";

  late TextEditingController weightC;

  void showButton() {
    if (kotaIdAsal != 0 && kotaIdTujuan != 0 && berat > 0 && kurir != "") {
      hiddenButton.value = false;
    } else {
      hiddenButton.value = true;
    }
  }

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    String cekSatuan = satuan;
    switch (cekSatuan) {
      case "ton":
        berat = berat * 1000000;
        break;
      case "kwintal":
        berat = berat * 100000;
        break;
      case "ons":
        berat = berat * 100;
        break;
      case "lbs":
        berat = berat * 2204.62;
        break;
      case "pound":
        berat = berat * 2204.62;
        break;
      case "kg":
        berat = berat * 1000;
        break;
      case "hg":
        berat = berat * 100;
        break;
      case "dag":
        berat = berat * 10;
        break;
      case "gram":
        berat = berat;
        break;
      case "dg":
        berat = berat / 10;
        break;
      case "cg":
        berat = berat / 100;
        break;
      case "mg":
        berat = berat / 1000;
        break;
      default:
        berat = berat;
    }
    showButton();
    print("$berat gram");
  }

  void ubahSatuan(String value) {
    berat = double.tryParse(weightC.text) ?? 0.0;

    switch (value) {
      case "ton":
        berat = berat * 1000000;
        break;
      case "kwintal":
        berat = berat * 100000;
        break;
      case "ons":
        berat = berat * 100;
        break;
      case "lbs":
        berat = berat * 2204.62;
        break;
      case "pound":
        berat = berat * 2204.62;
        break;
      case "kg":
        berat = berat * 1000;
        break;
      case "hg":
        berat = berat * 100;
        break;
      case "dag":
        berat = berat * 10;
        break;
      case "gram":
        berat = berat;
        break;
      case "dg":
        berat = berat / 10;
        break;
      case "cg":
        berat = berat / 100;
        break;
      case "mg":
        berat = berat / 1000;
        break;
      default:
        berat = berat;
    }

    satuan = value;
    showButton();
    print("$berat gram");
  }

  void ongkosKirim() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    try {
      final response = await http.post(url, headers: {
        "key": "ff3b7f2ad44df5fbbbebeb43ebd8b1d0",
        'content-type': 'application/x-www-form-urlencoded',
      }, body: {
        'origin': '$kotaIdAsal',
        'destination': '$kotaIdTujuan',
        'weight': '$berat',
        'courier': '$kurir',
      });

      var data = jsonDecode(response.body) as Map<String, dynamic>;
      var results = data["rajaongkir"]["results"] as List<dynamic>;

      var listAllCourier = Courier.fromJsonList(results);
      var courier = listAllCourier[0];
      print(listAllCourier[0]);

      Get.defaultDialog(
          title: courier.name,
          content: Column(
            children: courier.costs
                .map((e) => ListTile(
                      title: Text("${e.service}"),
                      subtitle: Text("Rp ${e.cost[0].value}"),
                      trailing: Text( courier.code == "pos"
                        ? "${e.cost[0].etd}"
                        : "${e.cost[0].etd} HARI"
                      ),
                    ))
                .toList(),
          ));
    } catch (err) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: err.toString(),
      );
    }
  }

  @override
  void onInit() {
    weightC = TextEditingController(text: "$berat");
    super.onInit();
  }

  @override
  void onClose() {
    weightC.dispose();
    super.onClose();
  }
}
