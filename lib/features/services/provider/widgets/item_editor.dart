import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/create_service_request.dart';

class ItemEditor extends StatelessWidget {
  final ServiceItem item;
  final int index;
  final String formId;
  final ValueChanged<ServiceItem> onUpdate;
  final VoidCallback onRemove;
  final String? nameError;
  final String? priceError;

  const ItemEditor({
    super.key,
    required this.item,
    required this.index,
    required this.formId,
    required this.onUpdate,
    required this.onRemove,
    this.nameError,
    this.priceError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: item.name,
                decoration: InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: nameError,
                ),
                onChanged: (String value) =>
                    onUpdate(item.copyWith(name: value)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: item.price == 0 ? '' : item.price.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Price *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: priceError,
                ),
                onChanged: (String value) {
                  final num price = num.tryParse(value) ?? 0;
                  onUpdate(item.copyWith(price: price));
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 24,
              ),
              onPressed: onRemove,
              tooltip: 'Remove item',
            ),
          ],
        ),
      ],
    );
  }
}
