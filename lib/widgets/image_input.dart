import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';

class ImageInput extends StatelessWidget {
  final Function() onTap;
  final String? imagePath, label, hint;
  final double? horizontal, vertical;
  final bool isMandatory;
  final String? mandatoryText;
  const ImageInput({
    Key? key,
    required this.imagePath,
    required this.onTap,
    required this.isMandatory,
    this.label,
    this.mandatoryText,
    this.hint,
    this.horizontal,
    this.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0.0,
          vertical: vertical ?? 0.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Row(
                mainAxisAlignment: mandatoryText != null
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$label',
                    style: const TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isMandatory)
                    Text(
                      mandatoryText ?? '* Required',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            if (label != null) UiUtils.spaceVrt10,
            Container(
              height: SizeConfig.screenHeight * 0.22,
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              child: getImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImage() {
    if (imagePath != null && imagePath != '') {
      if (imagePath!.contains('base64')) {
        final data = imagePath?.split(',').last;
        return Image.memory(
          base64Decode(data!),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        );
      } else {
        return Image.file(
          File(
            imagePath!,
          ),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        );
      }
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 28,
          ),
          UiUtils.spaceVrt10,
          UiUtils.spaceVrt10,
          Text(
            hint ?? 'Upload a picture',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }
}
