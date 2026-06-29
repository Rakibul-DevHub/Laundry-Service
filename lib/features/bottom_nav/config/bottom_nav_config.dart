import 'package:drop_n_fresh/features/home/rider/screens/home_rider_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/icons.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/widgets/asset_loader.dart';
import '../../bags/screens/my_bags_screen.dart';
import '../../earnings/screens/earnings_rider_screen.dart';
import '../../earnings/screens/earnings_provider_screen.dart';
import '../../home/provider/screens/home_provider_screen.dart';
import '../../home/user/screens/user_home_screen.dart';
import '../../jobs/screens/jobs_screen.dart';
import '../../notification/screens/notifications_screen.dart';
import '../../orders/provider/screens/orders_provider_screen.dart';
import '../../orders/user/screens/orders_user_screen.dart';
import '../../profile/screens/provider/provider_profile_screen.dart';
import '../../profile/screens/rider/rider_profile_screen.dart';
import '../../profile/screens/user/user_profile_screen.dart';
import '../../services/provider/screens/provider_services_screen.dart';
import '../../services/user/screens/user_services_screen.dart';

class CustomBottomNavItem {
  final String label;
  final Widget icon;
  final Widget activeIcon;

  const CustomBottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

List<CustomBottomNavItem> getBottomNavItems(Role role) {
  switch (role) {
    case Role.user:
      return <CustomBottomNavItem>[
        const CustomBottomNavItem(
          label: 'Home',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavUserHome,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavUserHome,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Services',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavUserService,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavUserService,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Orders',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavUserOrders,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavUserOrders,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),

        const CustomBottomNavItem(
          label: 'My Bags',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavUserBags,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavUserBags,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Profile',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavUserUser,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavUserUser,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
      ];
    case Role.rider:
      return <CustomBottomNavItem>[
        const CustomBottomNavItem(
          label: 'Home',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderHome,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderHome,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Jobs',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderJobs,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderJobs,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Earnings',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderEarnings,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderEarnings,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Notifications',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderNotification,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderNotification,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Profile',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderUser,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavRiderUser,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
      ];
    case Role.provider:
      return <CustomBottomNavItem>[
        const CustomBottomNavItem(
          label: 'Home',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderHome,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderHome,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Orders',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderOrders,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderOrders,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Services',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderService,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderService,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Earnings',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderEarnings,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderEarnings,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
        const CustomBottomNavItem(
          label: 'Profile',
          icon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderUser,
            height: 20,
            width: 20,
            color: AppColors.title,
          ),
          activeIcon: AssetLoader(
            assetPath: AppIcons.bottomNavProviderUser,
            height: 20,
            width: 20,
            color: AppColors.primary,
          ),
        ),
      ];
  }
}

List<Widget> getScreensForRole(Role role) {
  switch (role) {
    case Role.user:
      return <Widget>[
        const UserHomeScreen(),
        const UserServicesScreen(),
        const OrdersUserScreen(),
        const MyBagsScreen(),
        const UserProfileScreen(),
      ];
    case Role.rider:
      return <Widget>[
        const HomeRiderScreen(),
        const JobsScreen(),
        const EarningsRiderScreen(),
        const NotificationsScreen(),
        const RiderProfileScreen(),
      ];
    case Role.provider:
      return <Widget>[
        const HomeProviderScreen(),
        const OrdersProviderScreen(),
        const ProviderServicesScreen(),
        const EarningsProviderScreen(),
        const ProviderProfileScreen(),
      ];
  }
}
