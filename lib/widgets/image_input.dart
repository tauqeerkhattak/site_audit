import 'dart:io';

import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';

class ImageInput extends StatelessWidget {
  final Function() onTap;
  final String? imagePath, label, hint;
  final double? horizontal, vertical;
  const ImageInput({
    Key? key,
    required this.imagePath,
    required this.onTap,
    this.label,
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
              Text(
                label!,
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
              child: imagePath != ''
                  ? Image.file(
                      File(
                        imagePath!,
                      ),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 28,
                        ),
                        UiUtils.spaceVrt10,
                        UiUtils.spaceVrt10,
                        Text(
                          'Upload a picture',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
