import 'package:flutter/material.dart';
import 'package:site_audit/widgets/image_input.dart';

import '../../models/form_model.dart';

class ViewFormScreen extends StatefulWidget {
  final List<dynamic>? list;
  ViewFormScreen({
    Key? key,
    this.list,
  }) : super(key: key);

  @override
  State<ViewFormScreen> createState() => _ViewFormScreenState();
}

class _ViewFormScreenState extends State<ViewFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: widget.list?.length ?? 0,
      itemBuilder: (context, index) {
        final data = widget.list?[index];
        final item = Items.fromJson(data);
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              buildRow("Field ID", item.id.toString() ?? "NA"),
              const SizedBox(
                height: 10,
              ),
              buildRow("Input Type", item.inputType ?? "NA"),
              const SizedBox(
                height: 10,
              ),
              if (item.inputType != 'PHOTO')
                buildRow("Answer", item.answer ?? "NA"),
              if (item.answer != null &&
                  item.inputType == 'PHOTO' &&
                  item.answer != '')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Answer"),
                    ImageInput(
                      imagePath: item.answer!,
                      onTap: () {},
                      isMandatory: false,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ));
  }

  Row buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}
