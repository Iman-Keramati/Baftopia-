import 'package:flutter/material.dart';
import '../core/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool showAction;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.showAction = false,
    this.iconSize = 80.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with background circle
          Container(
            width: iconSize + 40,
            height: iconSize + 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: iconSize, color: AppConstants.primaryColor),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),

          // Subtitle (optional)
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.hintColor,
                height: 1.5,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Action button (optional)
          if (showAction && actionText != null && onActionPressed != null) ...[
            const SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton.icon(
              onPressed: onActionPressed,
              icon: const Icon(Icons.add, size: 20),
              label: Text(actionText!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                elevation: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Predefined empty state widgets for common scenarios
class EmptyStateWidgets {
  static Widget favoritesEmpty({
    VoidCallback? onAddPressed,
    bool showAction = false,
  }) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'بافتنی ای هنوز به دلت ننشسته',
      subtitle:
          'وقتی بافتنی‌ای را به علاقه‌مندی‌ها اضافه کنی، اینجا نمایش داده می‌شود',
      actionText: 'مشاهده بافتنی‌ها',
      onActionPressed: onAddPressed,
      showAction: showAction,
    );
  }

  static Widget categoriesEmpty({
    VoidCallback? onAddPressed,
    bool showAction = false,
  }) {
    return EmptyStateWidget(
      icon: Icons.category_outlined,
      title: 'هیچ دسته‌بندی وجود ندارد',
      subtitle: 'برای افزودن دسته‌بندی جدید، روی دکمه + بالای صفحه بزنید',
      actionText: 'افزودن دسته‌بندی',
      onActionPressed: onAddPressed,
      showAction: showAction,
    );
  }

  static Widget productsEmpty({
    String? categoryName,
    VoidCallback? onAddPressed,
    bool showAction = false,
    bool isAdmin = false,
  }) {
    return EmptyStateWidget(
      icon: Icons.inventory_2_outlined,
      title:
          categoryName != null
              ? 'بافتنی ای در این دسته‌بندی وجود ندارد'
              : 'هیچ بافتنی‌ای وجود ندارد',
      subtitle:
          isAdmin
              ? (categoryName != null
                  ? 'در دسته‌بندی "$categoryName" هنوز بافتنی‌ای اضافه نشده است'
                  : 'برای افزودن بافتنی جدید، روی دکمه + بالای صفحه بزنید')
              : (categoryName != null
                  ? 'در دسته‌بندی "$categoryName" هنوز بافتنی‌ای اضافه نشده است'
                  : 'هنوز بافتنی‌ای در این بخش وجود ندارد'),
      actionText: isAdmin ? 'افزودن بافتنی' : null,
      onActionPressed: isAdmin ? onAddPressed : null,
      showAction: showAction && isAdmin,
    );
  }

  static Widget searchEmpty({
    String? searchQuery,
    VoidCallback? onClearPressed,
    bool showAction = false,
  }) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title:
          searchQuery != null
              ? 'نتیجه‌ای برای "$searchQuery" یافت نشد'
              : 'نتیجه‌ای یافت نشد',
      subtitle:
          searchQuery != null
              ? 'کلمات کلیدی دیگری امتحان کنید یا فیلترهای جستجو را تغییر دهید'
              : 'لطفاً کلمات کلیدی را وارد کنید',
      actionText: 'پاک کردن جستجو',
      onActionPressed: onClearPressed,
      showAction: showAction,
    );
  }

  static Widget errorState({
    String? errorMessage,
    VoidCallback? onRetryPressed,
    bool showAction = true,
  }) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'خطا در بارگذاری',
      subtitle: errorMessage ?? 'مشکلی پیش آمده است. لطفاً دوباره تلاش کنید',
      actionText: 'تلاش مجدد',
      onActionPressed: onRetryPressed,
      showAction: showAction,
    );
  }

  static Widget loadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppConstants.primaryColor),
          SizedBox(height: AppConstants.paddingMedium),
          Text(
            'در حال بارگذاری...',
            style: TextStyle(
              color: AppConstants.hintColor,
              fontSize: AppConstants.textSizeMedium,
            ),
          ),
        ],
      ),
    );
  }
}
