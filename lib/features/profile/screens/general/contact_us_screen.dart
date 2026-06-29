import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/general_providers.dart';
import '../../state/general/contact_us_state.dart';

class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ContactUsState state = ref.watch(contactUsProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Contact Us",
        showBackBtn: true,
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
                ref.read(aboutUsProvider.notifier).refreshContent(),
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
      child: Html(
        data: htmlContent,
      ),
    );
  }
}
