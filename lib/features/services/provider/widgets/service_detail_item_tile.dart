// features/services/provider/widgets/service_detail_item_tile.dart

// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../models/service_model.dart';

class ServiceDetailItemTile extends StatefulWidget {
  final ServiceItem item;
  final ServiceItem originalItem;
  final bool isEditing;
  final Function(ServiceItem) onUpdate;

  const ServiceDetailItemTile({
    super.key,
    required this.item,
    required this.originalItem,
    required this.isEditing,
    required this.onUpdate,
  });

  @override
  State<ServiceDetailItemTile> createState() => _ServiceDetailItemTileState();
}

class _ServiceDetailItemTileState extends State<ServiceDetailItemTile> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _priceController = TextEditingController(
      text: widget.item.price.toString(),
    );
  }

  @override
  void didUpdateWidget(ServiceDetailItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if item changes (e.g., after save)
    if (oldWidget.item.id != widget.item.id) {
      _nameController.text = widget.item.name;
      _priceController.text = widget.item.price.toString();
    }
  }

  void _notifyParent() {
    final num price = num.tryParse(_priceController.text) ?? widget.item.price;
    final ServiceItem updated = widget.item.copyWith(
      name: _nameController.text.trim(),
      price: price,
    );
    widget.onUpdate(updated); //  Notify parent with updated item
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.body.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Item Name
              Expanded(
                child: widget.isEditing
                    ? TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: AppTextStyles.paragraph1,
                        onChanged: (_) => _notifyParent(),
                      )
                    : Text(
                        widget.item.name,
                        style: AppTextStyles.paragraph1.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.title,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // Price
              SizedBox(
                width: 90,
                child: widget.isEditing
                    ? TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          prefixText: '\$ ',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: AppTextStyles.paragraph1,
                        onChanged: (_) => _notifyParent(),
                      )
                    : Text(
                        '\$${widget.item.price}',
                        style: AppTextStyles.paragraph1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
