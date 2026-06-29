import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/services/user/models/order_confirmation_model.dart';
import 'package:drop_n_fresh/features/services/user/models/order_request_models.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_booking_models.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_model.dart';
import 'package:drop_n_fresh/features/services/user/state/user_service_booking_state.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Step4Checkout extends StatefulWidget {
  final UserServiceBookingState state;
  final UserServiceModel service;
  final Future<OrderConfirmationResponse?> Function(PlaceOrderRequest request)
  onGetPriceSummary;
  // ignore: inference_failure_on_function_return_type
  final Function(String orderId) onProceedToCheckout;
  final VoidCallback onPrevious;
  final bool isSubmitting;

  const Step4Checkout({
    super.key,
    required this.state,
    required this.service,
    required this.onGetPriceSummary,
    required this.onProceedToCheckout,
    required this.onPrevious,
    required this.isSubmitting,
  });

  @override
  State<Step4Checkout> createState() => _Step4CheckoutState();
}

class _Step4CheckoutState extends State<Step4Checkout> {
  bool _isLoadingSummary = false;
  bool _isLoadingCheckout = false;
  String? _selectedDriverType;
  OrderConfirmationResponse? _priceSummary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_priceSummary == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.body, width: .4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Select Delivery Method',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Choose how you want your order delivered',
                    style: AppTextStyles.paragraph0.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                  // Driver Type Options
                  RadioListTile<String>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: 'HIRE_CARRIER',
                    // ignore: deprecated_member_use
                    groupValue: _selectedDriverType,
                    // ignore: deprecated_member_use
                    onChanged: (String? value) {
                      setState(() {
                        _selectedDriverType = value;
                      });
                    },
                    activeColor: AppColors.primary,
                    title: Text(
                      'Hire Carrier',
                      style: AppTextStyles.heading5,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: 'SELF',
                    // ignore: deprecated_member_use
                    groupValue: _selectedDriverType,
                    // ignore: deprecated_member_use
                    onChanged: (String? value) {
                      setState(() {
                        _selectedDriverType = value;
                      });
                    },
                    activeColor: AppColors.primary,
                    title: Text(
                      'Self',
                      style: AppTextStyles.heading5,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.body.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pricing will be calculated based on your selection and delivery distance',
                            style: AppTextStyles.paragraph1.copyWith(
                              color: AppColors.body,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (_isLoadingSummary) ...<Widget>[
            const SizedBox(height: AppSizes.lg),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Calculating your order summary...',
                    style: AppTextStyles.paragraph2.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (_priceSummary != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.body.withValues(alpha: .2)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Price Breakdown',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: AppSizes.md),
                  _buildPriceRow(
                    'Items Total',
                    '\$${_priceSummary!.data.pricing.itemsTotal / 100}',
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  if (_priceSummary!.data.pricing.platformFee > 0) ...<Widget>[
                    _buildPriceRow(
                      'Platform Fee',
                      '\$${_priceSummary!.data.pricing.platformFee / 100}',
                    ),
                  ],
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  if (_priceSummary!.data.pricing.pickupFee > 0) ...<Widget>[
                    _buildPriceRow(
                      'Pickup Fee',
                      '\$${_priceSummary!.data.pricing.pickupFee / 100}',
                    ),
                  ],
                  if (_priceSummary!.data.pricing.deliveryFee > 0) ...<Widget>[
                    _buildPriceRow(
                      'Delivery Fee',
                      '\$${_priceSummary!.data.pricing.deliveryFee / 100}',
                    ),
                  ],
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  _buildPriceRow(
                    'Total',
                    '\$${_priceSummary!.data.pricing.total / 100}',
                    isBold: true,
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Order Details Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.body.withValues(alpha: .2)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Order Details',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.sm),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildDetailRow(
                        'Service',
                        widget.service.serviceCategory.name,
                      ),
                      _buildDetailRow(
                        'Items',
                        '${widget.state.totalItems} pcs across ${widget.state.products.where((BookingProductItem p) => p.quantity > 0).length} types',
                      ),
                      if (widget.state.selectedBagIds.isNotEmpty)
                        _buildDetailRow(
                          'Bags',
                          '${widget.state.selectedBagIds.length} selected',
                        ),
                      if (widget.state.schedule != null)
                        _buildDetailRow(
                          'Scheduled Pickup',
                          '${DateFormat('MMM d, yyyy').format(widget.state.schedule!.date)} • ${widget.state.schedule!.timeSlot}',
                        ),
                      if (widget.state.specialInstructions.isNotEmpty)
                        _buildDetailRow(
                          'Special Instructions',
                          widget.state.specialInstructions,
                        ),
                      _buildDetailRow(
                        'Delivery Method',
                        _formatDriverType(_selectedDriverType ?? ''),
                      ),
                      _buildDetailRow(
                        'Delivery Instruction',
                        _formatInstruction(_getSelectedInstruction()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSizes.lg),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    if (_priceSummary == null) {
      return Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onPrevious,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Previous'),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  _selectedDriverType != null &&
                      !_isLoadingSummary &&
                      !widget.isSubmitting
                  ? _fetchPriceSummary
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoadingSummary || widget.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text(
                      'Get Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _priceSummary = null;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Edit'),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoadingCheckout = true;
              });
              await widget.onProceedToCheckout(_priceSummary!.data.id);
              setState(() {
                _isLoadingCheckout = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoadingCheckout
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchPriceSummary() async {
    if (_selectedDriverType == null) {
      Toast.showWarning('Please select a delivery method');
      return;
    }

    setState(() {
      _isLoadingSummary = true;
    });

    try {
      final List<OrderLineRequest> orderLines = widget.state.products
          .where((BookingProductItem p) => p.quantity > 0)
          .map(
            (BookingProductItem p) => OrderLineRequest(
              itemId: p.id,
              quantity: p.quantity,
            ),
          )
          .toList();

      // Build request matching API format
      final PlaceOrderRequest request = PlaceOrderRequest(
        providerId: widget.service.providerId,
        bagIds: widget.state.selectedBagIds,
        orderLines: orderLines,
        specialInstructions: widget.state.specialInstructions,
        scheduledPickupDate: widget.state.schedule?.date.toIso8601String(),
        scheduledPickupSlot: widget.state.schedule?.timeSlot,
        deliveryInstruction: _getSelectedInstruction(),
        driverType: _selectedDriverType!,
      );

      // Call API to get pricing summary
      final OrderConfirmationResponse? summary = await widget.onGetPriceSummary(
        request,
      );
      setState(() {
        _priceSummary = summary;
        _isLoadingSummary = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSummary = false;
      });
    }
  }

  String _getSelectedInstruction() {
    final DeliveryInstruction selected = widget.state.instructions.firstWhere(
      (DeliveryInstruction inst) => inst.isSelected,
      orElse: () => const DeliveryInstruction(
        id: '',
        title: '',
        iconPath: '',
        isSelected: false,
      ),
    );

    switch (selected.id) {
      case 'take_from_door':
        return 'TAKE_FROM_DOOR';
      case 'knock_at_door':
        return 'KNOCK_AT_DOOR';
      case 'leave_at_door':
        return 'LEAVE_AT_DOOR';
      case 'avoid_bell':
        return 'AVOID_BELL';
      default:
        return 'KNOCK_AT_DOOR';
    }
  }

  String _formatDriverType(String type) {
    switch (type) {
      case 'HIRE_CARRIER':
        return 'Hire Carrier';
      case 'MYSELF':
        return 'Myself';
      default:
        return type;
    }
  }

  String _formatInstruction(String instruction) {
    switch (instruction) {
      case 'TAKE_FROM_DOOR':
        return 'Take from door';
      case 'KNOCK_AT_DOOR':
        return 'Knock at door';
      case 'LEAVE_AT_DOOR':
        return 'Leave at door';
      case 'AVOID_BELL':
        return 'Avoid bell';
      default:
        return instruction;
    }
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: AppTextStyles.paragraph0.copyWith(
              color: AppColors.title,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.paragraph0.copyWith(
              color: AppColors.title,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.paragraph1.copyWith(
                color: AppColors.title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
