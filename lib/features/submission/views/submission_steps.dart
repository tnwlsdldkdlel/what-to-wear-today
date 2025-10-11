import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/themes/app_theme.dart';
import '../../../core/models/outfit_submission.dart';
import '../controllers/submission_controller.dart';

class SubmissionTopStepView extends GetView<SubmissionController> {
  const SubmissionTopStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.confirmCancel,
      child: _SubmissionStepScaffold(
        title: '상의 선택',
        leadingIcon: Icons.close,
        onBackPressed: () async {
          final shouldExit = await controller.confirmCancel();
          if (shouldExit) {
            Get.back();
          }
        },
        body: _SingleSelectCards(
          items: controller.tops,
          selected: controller.selectedTop,
          onSelect: controller.selectTop,
        ),
      ),
    );
  }
}

class SubmissionBottomStepView extends GetView<SubmissionController> {
  const SubmissionBottomStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '하의 선택',
      onBackPressed: () async => Get.back(),
      body: _SingleSelectCards(
        items: controller.bottoms,
        selected: controller.selectedBottom,
        onSelect: controller.selectBottom,
      ),
    );
  }
}

class SubmissionOuterStepView extends GetView<SubmissionController> {
  const SubmissionOuterStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '아우터 선택',
      onBackPressed: () async => Get.back(),
      bottomSection: Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: controller.skipOuter,
          child: const Text('건너뛰기'),
        ),
      ),
      body: _SingleSelectCards(
        items: controller.outers,
        selected: controller.selectedOuter,
        onSelect: controller.selectOuter,
      ),
    );
  }
}

class SubmissionShoesStepView extends GetView<SubmissionController> {
  const SubmissionShoesStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '신발 선택',
      onBackPressed: () async => Get.back(),
      body: _SingleSelectCards(
        items: controller.shoes,
        selected: controller.selectedShoes,
        onSelect: controller.selectShoes,
      ),
    );
  }
}

class SubmissionAccessoriesStepView extends GetView<SubmissionController> {
  const SubmissionAccessoriesStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '악세서리 선택',
      onBackPressed: () async => Get.back(),
      body: _MultiSelectCards(
        items: controller.accessories,
        selectedItems: controller.selectedAccessories,
        onToggle: controller.toggleAccessory,
      ),
      bottomSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: controller.proceedFromAccessories,
            child: const Text('다음'),
          ),
          TextButton(
            onPressed: controller.skipAccessory,
            child: const Text('건너뛰기'),
          ),
        ],
      ),
    );
  }
}

class SubmissionComfortStepView extends GetView<SubmissionController> {
  const SubmissionComfortStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '체감 온도 선택',
      onBackPressed: () async => Get.back(),
      body: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: ComfortLevel.values.map((level) {
          return Obx(
            () => ChoiceChip(
              label: Text(_comfortLabel(level)),
              selected: controller.selectedComfort.value == level,
              selectedColor: _comfortColor(level),
              backgroundColor: _comfortColor(level).withOpacity(0.12),
              labelStyle: TextStyle(
                color: controller.selectedComfort.value == level
                    ? Colors.white
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => controller.selectComfort(level),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SubmissionReviewStepView extends GetView<SubmissionController> {
  const SubmissionReviewStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '제출 전 확인',
      subtitle: '선택한 착장을 확인하세요.',
      onBackPressed: () async => Get.back(),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReviewRow(label: '상의', value: controller.topLabel),
            _ReviewRow(label: '하의', value: controller.bottomLabel),
            _ReviewRow(label: '아우터', value: controller.outerLabel),
            _ReviewRow(label: '신발', value: controller.shoesLabel),
            _ReviewRow(label: '액세서리', value: controller.accessoriesLabel),
            _ReviewRow(label: '체감 온도', value: controller.comfortLabel),
          ],
        ),
      ),
      bottomSection: Obx(
        () => Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    controller.isSubmitting.value ? null : controller.submit,
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('제출하기'),
              ),
            ),
            if (controller.submitMessage.value.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                controller.submitMessage.value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubmissionStepScaffold extends StatelessWidget {
  const _SubmissionStepScaffold({
    required this.title,
    this.subtitle,
    this.stepLabel,
    required this.body,
    this.onBackPressed,
    this.leadingIcon = Icons.arrow_back_ios_new_rounded,
    this.bottomSection,
  });

  final String title;
  final String? subtitle;
  final String? stepLabel;
  final Widget body;
  final IconData leadingIcon;
  final Future<void> Function()? onBackPressed;
  final Widget? bottomSection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStepLabel = stepLabel != null && stepLabel!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(leadingIcon),
          onPressed: () async {
            if (onBackPressed != null) {
              await onBackPressed!();
            } else {
              Get.back();
            }
          },
        ),
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasStepLabel) ...[
                Text(stepLabel!, style: theme.textTheme.bodyMedium),
              ],
              if (hasStepLabel && hasSubtitle) const SizedBox(height: 8),
              if (hasSubtitle) ...[
                Text(
                  subtitle!,
                  style: theme.textTheme.titleMedium,
                ),
              ],
              if (hasSubtitle || hasStepLabel)
                const SizedBox(height: 24)
              else
                const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: body,
                ),
              ),
              if (bottomSection != null) ...[
                const SizedBox(height: 24),
                bottomSection!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SingleSelectCards extends StatelessWidget {
  const _SingleSelectCards({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<ClothingOption> items;
  final RxString selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final currentSelection = selected.value;
        return Column(
          children: [
            for (var i = 0; i < items.length; i++)
              Padding(
                padding:
                    EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
                child: _SelectableCard(
                  label: items[i].label,
                  assetPath: items[i].assetPath,
                  isSelected: currentSelection == items[i].label,
                  onTap: () => onSelect(items[i].label),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MultiSelectCards extends StatelessWidget {
  const _MultiSelectCards({
    required this.items,
    required this.selectedItems,
    required this.onToggle,
  });

  final List<ClothingOption> items;
  final RxList<String> selectedItems;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
              child: _SelectableCard(
                label: items[i].label,
                assetPath: items[i].assetPath,
                isSelected: selectedItems.contains(items[i].label),
                onTap: () => onToggle(items[i].label),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.label,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                assetPath,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

Color _comfortColor(ComfortLevel level) {
  switch (level) {
    case ComfortLevel.hot:
      return AppColors.hot;
    case ComfortLevel.justRight:
      return AppColors.justRight;
    case ComfortLevel.cold:
      return AppColors.cold;
  }
}

String _comfortLabel(ComfortLevel level) {
  switch (level) {
    case ComfortLevel.hot:
      return '덥다';
    case ComfortLevel.justRight:
      return '딱 좋아요';
    case ComfortLevel.cold:
      return '춥다';
  }
}
