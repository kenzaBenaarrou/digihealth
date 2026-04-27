import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated_assets/assets.gen.dart';
import '../../../dashboard/presentation/widgets/border_painter.dart';

// ignore: must_be_immutable
class TeleStartWidget extends ConsumerWidget {
  String? title;
  String? value;
  Widget? icon;
  Color? color;
  String? moyenne;
  TeleStartWidget(
      {super.key, this.title, this.value, this.icon, this.color, this.moyenne});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
          ),
          Assets.images.lifeSignal.image(
            width: double.infinity,
            // height: 150.h,
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color(0xFF0A1F38),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: color?.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.r)),
                          ),
                          child: icon,
                        ),
                      ),
                      12.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value ?? "",
                            style: TextStyle(
                              color: color,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            moyenne ?? "",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: CornerBorderPainter(
                      color: Colors.cyanAccent,
                      strokeWidth: 1,
                      cornerLength: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
