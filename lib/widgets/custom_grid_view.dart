import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomGridView extends StatelessWidget {
  final int length;
  final Widget Function(BuildContext, int) itemBuilder;
  final int crossAxisCount;
  final ScrollPhysics? scrollPhysics;

  const CustomGridView({
    Key? key,
    required this.length,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.scrollPhysics,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: scrollPhysics,
      crossAxisCount: crossAxisCount ?? 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: length,
      itemBuilder: itemBuilder,
    );
  }
}
