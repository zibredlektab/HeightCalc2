import 'package:flutter/material.dart';
import 'package:heightcalc/solution_model.dart';

class Solution extends StatelessWidget {
  const Solution({
    super.key,
    required this.model,
    required this.list,
  });

  final SolutionModel model;
  final String list;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(list),
    );
  }


}