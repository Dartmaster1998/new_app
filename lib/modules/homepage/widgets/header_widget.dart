import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWidget extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final String langCode; // 🔹 Добавляем язык

  const HeaderWidget({super.key, this.onSearchChanged, this.langCode = 'ru'});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with SingleTickerProviderStateMixin {
  bool showSearchField = false;
  final TextEditingController _controller = TextEditingController();
  late final AnimationController _animationController;
  late final Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      showSearchField = !showSearchField;
      if (showSearchField) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _controller.clear();
        widget.onSearchChanged?.call('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Цвета для тем
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.white : Colors.black;

    // Локализация слова "Знаменитости"
    final title =
        {
          'ru': 'Знаменитости',
          'ky': 'Билгилүү адамдар',
          'en': 'Famous people',
        }[widget.langCode] ??
        'Famous people';

    return Material(
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // 🔹 Логотип
                Image.asset(
                  "assets/images/logo.png",
                  width: 100.w,
                  height: 40.h,
                  fit: BoxFit.contain,
                  color: isDark ? Colors.white : null,
                  colorBlendMode: isDark ? BlendMode.modulate : BlendMode.dst,
                ),

                SizedBox(width: 10.w),

                // 🔹 Название "Знаменитости"
                Text(
                  showSearchField
                      ? {
                            'ru': 'Знаменитости',
                            'ky': 'Билгилүү адамдар',
                            'en': 'Famous people',
                          }[widget.langCode] ??
                          'Famous people'
                      : '',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const Spacer(),

                // 🔹 Анимированное поле поиска
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 180.w * _widthAnimation.value,
                      child:
                          showSearchField
                              ? FadeTransition(
                                opacity: _animationController,
                                child: TextField(
                                  controller: _controller,
                                  autofocus: true,
                                  style: TextStyle(color: textColor),
                                  cursorColor: iconColor,
                                  onChanged: widget.onSearchChanged,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Поиск...",
                                    hintStyle: TextStyle(
                                      color: textColor.withOpacity(0.6),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 20,
                                      color: iconColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor:
                                        isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 8.w,
                                    ),
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                    );
                  },
                ),

                // 🔹 Кнопка поиска / закрытия
                IconButton(
                  icon: Icon(
                    showSearchField ? Icons.close : Icons.search,
                    size: 28,
                    color: iconColor,
                  ),
                  onPressed: _toggleSearch,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
