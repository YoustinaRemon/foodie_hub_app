import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios),
    );

    // Container(
    // width: 41,
    // height: 41,
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(12),
    //   border: BoxBorder.all(color: AppColors.borderColor),
    //   // color: AppColors.,
    // ),
    // child: Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
    //   child:
    // ),
    // );
  }
}
