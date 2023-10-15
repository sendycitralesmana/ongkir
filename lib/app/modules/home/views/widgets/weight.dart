import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/controllers/home_controller.dart';

class WeightItem extends GetView<HomeController> {
  const WeightItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.weightC,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              labelText: "Berat Barang",
              hintText: "Berat Barang",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => controller.ubahBerat(value!),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 150,
          child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: [
              "ton",
              "kwintal",
              "ons",
              "lbs",
              "pound",
              "kg",
              "hg",
              "dag",
              "gram",
              "dg",
              "cg",
              "mg",
            ],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Satuan",
                hintText: "Pilih Satuan",
              ),
            ),
            onChanged: (value) => controller.ubahSatuan(value!),
            selectedItem: "gram",
          ),
        ),
      ],
    );
  }
}
