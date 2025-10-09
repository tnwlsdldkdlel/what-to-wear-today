import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/themes/app_theme.dart';
import '../../../core/models/outfit_submission.dart';
import '../controllers/submission_controller.dart';

class SubmissionView extends GetView<SubmissionController> {
  const SubmissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 착장 제출하기')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepHeader(step: 1, title: '오늘 입은 상의'),
              _EmojisGrid(
                items: controller.tops,
                selected: controller.selectedTop,
                onTap: (value) => controller.selectedTop.value = value,
              ),
              const SizedBox(height: 24),
              const _StepHeader(step: 2, title: '하의'),
              _EmojisGrid(
                items: controller.bottoms,
                selected: controller.selectedBottom,
                onTap: (value) => controller.selectedBottom.value = value,
              ),
              const SizedBox(height: 24),
              const _StepHeader(step: 3, title: '아우터 (선택)'),
              _EmojisGrid(
                items: controller.outers,
                selected: controller.selectedOuter,
                onTap: (value) => controller.selectedOuter.value =
                    controller.selectedOuter.value == value ? '' : value,
                allowDeselect: true,
              ),
              const SizedBox(height: 24),
              const _StepHeader(step: 4, title: '신발'),
              _EmojisGrid(
                items: controller.shoes,
                selected: controller.selectedShoes,
                onTap: (value) => controller.selectedShoes.value = value,
              ),
              const SizedBox(height: 24),
              const _StepHeader(step: 5, title: '액세서리 (복수 선택)'),
              Obx(
                () => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.accessories
                      .map(
                        (item) => FilterChip(
                          label: Text(item),
                          selected:
                              controller.selectedAccessories.contains(item),
                          backgroundColor: AppColors.background,
                          selectedColor: AppColors.justRight,
                          labelStyle: TextStyle(
                            color: controller.selectedAccessories.contains(item)
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) => controller.toggleAccessory(item),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              const _StepHeader(step: 6, title: '체감 온도'),
              Obx(
                () => Row(
                  children: ComfortLevel.values
                      .map(
                        (level) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(_comfortLabel(level)),
                              selected:
                                  controller.selectedComfort.value == level,
                              selectedColor: _comfortColor(level),
                              backgroundColor:
                                  _comfortColor(level).withOpacity(0.12),
                              labelStyle: TextStyle(
                                color: controller.selectedComfort.value == level
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              onSelected: (_) =>
                                  controller.selectedComfort.value = level,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submit,
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('딱 맞아요! 제출'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => AnimatedOpacity(
                  opacity: controller.submitMessage.value.isEmpty ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    controller.submitMessage.value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
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
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step, required this.title});

  final int step;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step.toString(),
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _EmojisGrid extends StatelessWidget {
  const _EmojisGrid({
    required this.items,
    required this.selected,
    required this.onTap,
    this.allowDeselect = false,
  });

  final List<String> items;
  final RxString selected;
  final void Function(String) onTap;
  final bool allowDeselect;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items
            .map(
              (item) => ChoiceChip(
                label: Text(item),
                selected: selected.value == item,
                labelStyle: TextStyle(
                  color: selected.value == item
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: AppColors.background,
                selectedColor: AppColors.primary,
                onSelected: (_) {
                  if (allowDeselect && selected.value == item) {
                    selected.value = '';
                  } else {
                    onTap(item);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
