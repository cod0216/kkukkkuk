import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? text; // Nullable로 변경
  final Widget? child; // child 추가 (text 대신 사용 가능)
  final VoidCallback? onPressed; // Nullable로 변경 (로딩 시 비활성화 위해)
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? leadingIcon;
  final double iconSpacing;
  final bool isLoading; // 로딩 상태 추가

  const PrimaryButton({
    super.key,
    this.text, // text 또는 child 중 하나는 필수
    this.child,
    required this.onPressed,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.leadingIcon,
    this.iconSpacing = 8.0,
    this.isLoading = false, // 기본값 false
  }) : assert(
         text != null || child != null,
         'Either text or child must be provided.',
       ); // 검증 추가

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor;
    // 로딩 중이거나 onPressed가 null이면 버튼 비활성화
    final effectiveOnPressed = isLoading ? null : onPressed;
    // 로딩 중일 때 배경색 약간 투명하게 (선택적)
    final effectiveBgColor = isLoading ? bgColor.withOpacity(0.7) : bgColor;

    return ElevatedButton(
      onPressed: effectiveOnPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBgColor, // 수정된 배경색 적용
        foregroundColor: textColor,
        minimumSize: Size(isFullWidth ? double.infinity : 0, 50),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        // 비활성화 상태 스타일 (선택적)
        disabledBackgroundColor: bgColor.withOpacity(0.5),
        disabledForegroundColor: textColor?.withOpacity(0.7),
      ),
      child:
          isLoading
              ? SizedBox(
                // 로딩 중일 때 Indicator 표시
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  // 배경색과 대비되는 색상 사용 (기본 흰색)
                  color: textColor ?? Colors.white,
                ),
              )
              : child ??
                  Row(
                    // 로딩 중 아닐 때: child가 있으면 child 표시, 없으면 기본 Row 표시
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null) ...[
                        leadingIcon!,
                        SizedBox(width: iconSpacing),
                      ],
                      // assert로 인해 text가 null이 아님을 보장 (child가 null일 경우)
                      Text(
                        text!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
    );
  }
}
