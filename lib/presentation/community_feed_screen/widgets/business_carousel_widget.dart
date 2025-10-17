import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './business_recommendation_widget.dart';

class BusinessCarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> businesses;
  final Function(Map<String, dynamic>) onViewCoupon;

  const BusinessCarouselWidget({
    Key? key,
    required this.businesses,
    required this.onViewCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (businesses.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_offer',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Ofertas da Vizinhança',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                return SizedBox( 
                  // width: 90.w,
                  // height: 40.h,

                  child: BusinessRecommendationWidget(
                    business: business,
                    onViewCoupon: () => onViewCoupon(business),
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}