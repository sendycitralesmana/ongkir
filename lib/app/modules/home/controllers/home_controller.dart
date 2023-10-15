import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
