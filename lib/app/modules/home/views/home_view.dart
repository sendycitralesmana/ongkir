import 'package:dropdown_search/dropdown_search.dart';
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
        backgroundColor: Colors.red[900],
      ),
      body: SafeArea(
        child: ListView(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: DropdownSearch<Map<String, dynamic>>(
                popupProps: PopupProps.menu(
                  // showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) => Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "${item['name']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                itemAsString: (item) => "${item['name']}",
                items: [
                  {
                    'code' : 'jne',
                    'name' : 'Jalur Nugraha Ekakurir (JNE)',
                  },
                  {
                    'code' : 'tiki',
                    'name' : 'Titipan Kilat (TIKI)',
                  },
                  {
                    'code' : 'pos',
                    'name' : 'Perusahaan Opsional Surat (POS)',
                  }
                ],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Tipe Kurir",
                    hintText: "Pilih Tipe Kurir",
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    controller.kurir.value = value["code"];
                    controller.showButton();
                  } else {
                    controller.hiddenButton.value = true;
                    controller.kurir.value = "";
                  }
                },
                // selectedItem: "jne",
              ),
            ),
            Obx(() => controller.hiddenButton.isTrue
            ? SizedBox()
            : ElevatedButton(
                onPressed: () => controller.ongkosKirim(), 
                child: Text("Cek Ongkos Kirim"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.red[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
