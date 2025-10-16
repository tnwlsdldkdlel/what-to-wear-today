import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/themes/app_theme.dart';
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
          child: const Text(
            '건너뛰기',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('다음'),
          ),
          TextButton(
            onPressed: controller.skipAccessory,
            child: const Text(
              '건너뛰기',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SubmissionReviewStepView extends GetView<SubmissionController> {
  const SubmissionReviewStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionStepScaffold(
      title: '확인',
      onBackPressed: () async => Get.back(),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.selectedTopOption != null)
              _ReviewItemSection(
                label: '상의',
                item: controller.selectedTopOption!,
              ),
            if (controller.selectedBottomOption != null)
              _ReviewItemSection(
                label: '하의',
                item: controller.selectedBottomOption!,
              ),
            if (controller.selectedOuterOption != null)
              _ReviewItemSection(
                label: '아우터',
                item: controller.selectedOuterOption!,
              )
            else
              _ReviewEmptySection(label: '아우터'),
            if (controller.selectedShoesOption != null)
              _ReviewItemSection(
                label: '신발',
                item: controller.selectedShoesOption!,
              ),
            if (controller.selectedAccessoriesOptions.isNotEmpty)
              _ReviewAccessoriesSection(
                label: '액세서리',
                items: controller.selectedAccessoriesOptions,
              )
            else
              _ReviewEmptySection(label: '액세서리'),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
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
                const SizedBox(height: 16)
              else
                const SizedBox(height: 0),
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
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.79,
          ),
          itemBuilder: (context, index) {
            final option = items[index];
            return _SelectableCard(
              label: option.label,
              assetPath: option.assetPath,
              isSelected: currentSelection == option.label,
              onTap: () => onSelect(option.label),
            );
          },
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.79,
      ),
      itemBuilder: (context, index) {
        final option = items[index];
        return Obx(
          () => _SelectableCard(
            label: option.label,
            assetPath: option.assetPath,
            isSelected: selectedItems.contains(option.label),
            onTap: () => onToggle(option.label),
          ),
        );
      },
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildAssetImage(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetImage() {
    final isSvg = assetPath.toLowerCase().endsWith('.svg');
    if (isSvg) {
      return SvgPicture.asset(
        assetPath,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
    );
  }
}

class _ReviewItemSection extends StatelessWidget {
  const _ReviewItemSection({
    required this.label,
    required this.item,
  });

  final String label;
  final ClothingOption item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _ReviewItemCard(item: item),
        ],
      ),
    );
  }
}

class _ReviewAccessoriesSection extends StatelessWidget {
  const _ReviewAccessoriesSection({
    required this.label,
    required this.items,
  });

  final String label;
  final List<ClothingOption> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) => _ReviewItemCard(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ReviewEmptySection extends StatelessWidget {
  const _ReviewEmptySection({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '선택 안 함',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItemCard extends StatelessWidget {
  const _ReviewItemCard({required this.item});

  final ClothingOption item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSvg = item.assetPath.toLowerCase().endsWith('.svg');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isSvg
                ? SvgPicture.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: 12),
          Text(
            item.label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
