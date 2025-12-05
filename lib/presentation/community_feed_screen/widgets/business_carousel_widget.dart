// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../../core/app_export.dart';
// import './business_recommendation_widget.dart';

// class BusinessCarouselWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> businesses;
//   final Function(Map<String, dynamic>) onViewCoupon;

//   const BusinessCarouselWidget({
//     Key? key,
//     required this.businesses,
//     required this.onViewCoupon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (businesses.isEmpty) return const SizedBox.shrink();

//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 2.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             child: Row(
//               children: [
//                 CustomIconWidget(
//                   iconName: 'local_offer',
//                   color: AppTheme.lightTheme.colorScheme.secondary,
//                   size: 6.w,
//                 ),
//                 SizedBox(width: 2.w),
//                 Text(
//                   'Ofertas da Vizinhança',
//                   style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: AppTheme.lightTheme.colorScheme.secondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 2.h),
//           SizedBox(
//             height: 35.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(horizontal: 4.w),
//               itemCount: businesses.length,
//               itemBuilder: (context, index) {
//                 final business = businesses[index];
//                 return SizedBox(
//                   width: 75.w,
//                   height: 35.h,
//                   child: BusinessRecommendationWidget(
//                     business: business,
//                     onViewCoupon: () => onViewCoupon(business),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './business_recommendation_widget.dart'; // Presumindo que este widget foi atualizado para conter sua altura

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
                  // Mantendo a cor 'secondary' (Laranja/Destaque)
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Ofertas da Vizinhança',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // Mantendo a cor 'secondary' (Laranja/Destaque)
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                
                // RESOLUÇÃO DE OVERFLOW: 
                // Garantimos que o card individual BusinessRecommendationWidget 
                // não ultrapasse a altura definida (35.h)
                return SizedBox(
                  width: 75.w,
                  height: 35.h,
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