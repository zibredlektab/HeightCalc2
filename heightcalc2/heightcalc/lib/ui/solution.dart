import 'package:flutter/material.dart';
import 'package:heightcalc/solution_model.dart';

class Solution extends StatelessWidget {
  const Solution({
    super.key,
    required this.model,
  });

  final SolutionModel model;

  @override
  Widget build(BuildContext context) {
    print("building solution widget");
    return Card(
      child: ListTile(
        title: Text(model.getList()),
      ),
    );
  }


}