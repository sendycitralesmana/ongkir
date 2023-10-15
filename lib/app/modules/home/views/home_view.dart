import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/views/widgets/city.dart';
import 'package:ongkir/app/modules/home/views/widgets/province.dart';
import 'package:ongkir/app/modules/home/views/widgets/weight.dart';

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
          Provinsi(tipe: "asal"),
          Obx(
            () => controller.hiddenKotaAsal.isTrue
                ? SizedBox()
                : Kota(provId: controller.provIdAsal.value, tipe: "asal"),
          ),
          Provinsi(tipe: "tujuan"),
          Obx(
            () => controller.hiddenKotaTujuan.isTrue
                ? SizedBox()
                : Kota(provId: controller.provIdTujuan.value, tipe: "tujuan"),
          ),
          WeightItem(),
        ],
      ),
    );
  }
}
