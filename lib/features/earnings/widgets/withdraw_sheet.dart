// features/earnings/widgets/withdraw_bottom_sheet.dart

// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/colors.dart';

class WithdrawSheet extends StatefulWidget {
  final num availableBalance;
  final num minimumWithdraw;
  final Function(num amount) onWithdraw;

  const WithdrawSheet({
    super.key,
    required this.availableBalance,
    this.minimumWithdraw = 1,
    required this.onWithdraw,
  });

  @override
  State<WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<WithdrawSheet> {
  final TextEditingController _amountController = TextEditingController();
  bool _isWithdrawing = false;
  String? _errorText;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(num amount) {
    setState(() {
      _amountController.text = amount.toStringAsFixed(2);
      _errorText = null;
    });
  }

  bool _validateAmount() {
    final double? amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Please enter a valid amount');
      return false;
    }

    if (amount < widget.minimumWithdraw) {
      setState(
        () => _errorText = 'Minimum withdrawal is \$${widget.minimumWithdraw}',
      );
      return false;
    }

    if (amount > widget.availableBalance) {
      setState(() => _errorText = 'Amount exceeds available balance');
      return false;
    }

    setState(() => _errorText = null);
    return true;
  }

  Future<void> _handleWithdraw() async {
    if (!_validateAmount()) {
      return;
    }

    setState(() => _isWithdrawing = true);

    try {
      final double amount = double.parse(_amountController.text);
      widget.onWithdraw(amount);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorText = 'Failed to withdraw. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isWithdrawing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Drag handle
        const Text(
          'Withdraw',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.title,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Available: \$${widget.availableBalance.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.body.withValues(alpha: 0.7),
          ),
        ),

        const SizedBox(height: 24),

        // Amount Input
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          style: const TextStyle(
            fontSize: 32,
            color: AppColors.primary,
          ),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: const TextStyle(
              fontSize: 32,
              color: AppColors.primary,
            ),
            hintText: '0.00',
            hintStyle: const TextStyle(
              fontSize: 32,
            ),
            errorText: _errorText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (_) => setState(() => _errorText = null),
        ),

        // const SizedBox(
        //   height: 12,
        // ),

        // const DashedDivider(
        //   dashGap: 2,
        // ),
        const SizedBox(
          height: 12,
        ),

        // Quick Amount Buttons
        Row(
          children: <Widget>[
            Expanded(
              child: _QuickButton(
                label: '25%',
                amount: widget.availableBalance * 0.25,
                onTap: _setAmount,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickButton(
                label: '50%',
                amount: widget.availableBalance * 0.50,
                onTap: _setAmount,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickButton(
                label: 'Max',
                amount: widget.availableBalance,
                onTap: _setAmount,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Withdraw Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isWithdrawing ? null : _handleWithdraw,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isWithdrawing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : const Text(
                    'Withdraw',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        // const SizedBox(height: 12),
      ],
    );
  }
}

// Simple quick button
class _QuickButton extends StatelessWidget {
  final String label;
  final num amount;
  final Function(num) onTap;

  const _QuickButton({
    required this.label,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
