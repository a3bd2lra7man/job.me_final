import 'package:flutter/material.dart';

class CardLoader extends StatelessWidget {
  final double height;

  const CardLoader({Key? key, this.height = 88}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SizedBox(
        height: height,
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
