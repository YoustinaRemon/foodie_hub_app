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
    // width: 41.w,
    // height: 41.h,
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(12.r),
    //   border: BoxBorder.all(color: AppColors.borderColor),
    //   // color: AppColors.,
    // ),
    // child: Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 5.0.w),
    //   child:
    // ),
    // );
  }
}
