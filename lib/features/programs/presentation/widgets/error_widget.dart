import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../provider/consultation_provider.dart';

class ErrorWidget extends ConsumerWidget {
  final String? errorMessage;
  const ErrorWidget({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 64.sp),
            16.verticalSpace,
            Text(
              'Erreur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.verticalSpace,
            Text(
              errorMessage ?? 'Une erreur est survenue',
              style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                ref.read(consultationProvider.notifier).fetchConsultationData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: const Color(0xFF051024),
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
