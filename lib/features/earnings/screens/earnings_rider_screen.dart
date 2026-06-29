import 'package:drop_n_fresh/features/earnings/notifier/stripe_connect_rider_notifier.dart';
import 'package:drop_n_fresh/features/earnings/widgets/earnings_list_section_rider.dart';
import 'package:drop_n_fresh/features/earnings/widgets/earnings_list_top_section_rider.dart';
import 'package:drop_n_fresh/features/earnings/widgets/withdraw_sheet.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_refresh_indicator.dart';
import '../providers/earnings_providers.dart';
import '../state/earnings_rider_state.dart';
import '../widgets/earnings_summary_section_rider.dart';
import '../widgets/shimmer/earnings_list_shimmer.dart';
import '../widgets/shimmer/summary_shimmer.dart';

class EarningsRiderScreen extends ConsumerWidget {
  const EarningsRiderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? error = ref.watch(
      riderEarningsProvider.select((EarningsRiderState state) => state.error),
    );
    final bool isLoading = ref.watch(
      riderEarningsProvider.select(
        (EarningsRiderState state) => state.isLoading,
      ),
    );

    final StripeConnectState stripeState = ref.watch(
      stripeConnectRiderProvider,
    );

    if (error != null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: "Earnings",
          showBackBtn: false,
          titleAlignment: TitleAlignment.left,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(error),
              ElevatedButton(
                onPressed: () =>
                    ref.read(riderEarningsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Earnings",
        showBackBtn: false,
        titleAlignment: TitleAlignment.left,
        actions: <Widget>[
          //  Three-line menu icon
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.menu_rounded, // Three-line hamburger menu
              color: AppColors.title,
              size: 24,
            ),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.white,
            elevation: 8,
            onSelected: (String value) {
              final num? max = ref.read(
                riderEarningsProvider.select(
                  (EarningsRiderState state) => state.summary?.availableBalance,
                ),
              );
              switch (value) {
                case 'withdraw':
                  if (max != null) {
                    CustomBottomSheet.show<WithdrawSheet>(
                      context: context,
                      child: WithdrawSheet(
                        availableBalance: max,
                        onWithdraw: (num amount) {
                          ref
                              .read(riderEarningsProvider.notifier)
                              .withdrawRequest(amount);
                        },
                      ),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              _buildMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Withdraw',
                value: 'withdraw',
                color: AppColors.primary,
                subtitle: 'Transfer to your account',
              ),
            ],
          ),
          const SizedBox(width: AppSizes.screenHorizontal),
        ],
      ),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => ref.read(riderEarningsProvider.notifier).refresh(),
        child: isLoading
            ? ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontal,
                  vertical: AppSizes.screenVertical,
                ),
                children: const <Widget>[
                  SummaryShimmer(),
                  SizedBox(height: AppSizes.spaceBetweenItems),
                  EarningsListShimmer(),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontal,
                  vertical: AppSizes.screenVertical,
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    const SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: AppSizes.spaceBetweenItems),
                          EarningsSummarySectionRider(),
                          SizedBox(height: AppSizes.spaceBetweenItems),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: _buildStripeConnectButton(ref, stripeState),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: AppSizes.spaceBetweenItems,
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: EarningsListTopSectionRider(),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: AppSizes.spaceBetweenItems,
                      ),
                    ),

                    const EarningsListSection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStripeConnectButton(WidgetRef ref, StripeConnectState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (state.isConnected)
          AppElevatedButton(
            label: "Account",
            icon: const Icon(
              Icons.account_balance,
              size: 18,
              color: AppColors.white,
            ),
            isLoading: state.isLoading,
            onPressed: () => ref
                .read(
                  stripeConnectRiderProvider.notifier,
                )
                .getOnboardingUrl(),
          ),
        const SizedBox(
          height: AppSizes.md,
        ),

        GestureDetector(
          onTap: () {
            if (!state.isConnected) {
              ref
                  .read(
                    stripeConnectRiderProvider.notifier,
                  )
                  .getOnboardingUrl();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: state.isConnected
                  ? AppColors.green.withValues(alpha: 0.12)
                  : AppColors.grey50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: state.isConnected
                    ? AppColors.green.withValues(alpha: 0.3)
                    : AppColors.grey50,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    state.isConnected
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    key: ValueKey<bool>(state.isConnected),
                    color: state.isConnected
                        ? AppColors.green
                        : AppColors.title,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    state.isLoading
                        ? "Loading..."
                        : state.isConnected
                        ? 'Connected'
                        : 'Connect for payments',
                    style: TextStyle(
                      color: state.isConnected
                          ? AppColors.green
                          : AppColors.title,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuEntry<String> _buildMenuItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    String? subtitle,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: subtitle != null ? 64 : 56,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.body.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
