import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/general_providers.dart';
import '../../state/general/support_state.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SupportState state = ref.watch(supportProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        showBackBtn: true,
        title: 'Support',
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? _buildErrorState(ref, state.error!)
            : _buildHtmlContent(state.htmlContent),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                ref.read(supportProvider.notifier).refreshContent(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlContent(String htmlContent) {
    if (htmlContent.isEmpty) {
      return const Center(
        child: Text('No content available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Html(
        data: htmlContent,
      ),
    );
  }
}
