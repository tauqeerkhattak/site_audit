import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomGridView extends StatelessWidget {
  final int length;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, int) itemBuilder;
  final int crossAxisCount;
  final ScrollPhysics? scrollPhysics;

  const CustomGridView({
    Key? key,
    required this.length,
    required this.itemBuilder,
    this.padding,
    this.crossAxisCount = 2,
    this.scrollPhysics,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: padding,
      shrinkWrap: true,
      physics: scrollPhysics,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: length,
      itemBuilder: itemBuilder,
    );
  }
}
