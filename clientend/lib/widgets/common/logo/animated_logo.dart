import 'package:flutter/material.dart';

// Constants moved to a shared location
const logoColor = Color.fromARGB(255, 30, 64, 175);
const pawIconSize = 80.0;
const logoFontSize = 38.0;
const logoSpacing = 32.0;
const singleKukkWidth = logoFontSize * 1.3;

class AnimatedLogo extends StatelessWidget {
  final AnimationController logoAnimationController;
  final Animation<double> pawAnimation;
  final Animation<double> textAnimation;

  const AnimatedLogo({
    super.key,
    required this.logoAnimationController,
    required this.pawAnimation,
    required this.textAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: logoAnimationController,
        builder: (context, child) {
          // 화면 너비의 절반
          final halfScreenWidth = MediaQuery.of(context).size.width / 2;

          // *** 간격 조절 핵심 파트 ***
          // Paw 아이콘 최종 X 위치: 중앙에서 더 왼쪽으로 이동
          final double pawTargetX =
              -(singleKukkWidth / 2 + logoSpacing / 2) - 15.0;
          // Text 아이콘 최종 X 위치: 중앙에서 (아이콘 너비의 절반 + 간격의 절반) 만큼 오른쪽으로 이동
          final double textTargetX = (pawIconSize / 2 + logoSpacing / 2);

          // 현재 Paw X 위치: 초기 중앙(0)에서 pawTargetX까지 이동
          final double currentPawX = pawTargetX * pawAnimation.value;

          // 현재 Text X 위치:
          // 시작: 오른쪽 화면 밖 (대략 halfScreenWidth)
          // 끝: textTargetX
          // 애니메이션 진행률(textAnimation.value)에 따라 시작 위치에서 끝 위치로 이동
          final double textStartX = halfScreenWidth; // 오른쪽 화면 밖에서 시작
          final double currentTextX =
              textStartX + (textTargetX - textStartX) * textAnimation.value;

          return Stack(
            clipBehavior: Clip.none, // 자식 요소가 벗어나도 보이도록
            alignment: Alignment.center,
            children: [
              // 1. Paw 아이콘 (Transform 사용)
              Transform.translate(
                offset: Offset(currentPawX, 0),
                child: const Icon(
                  Icons.pets,
                  color: logoColor,
                  size: pawIconSize,
                ),
              ),

              // 2. KUKK KUKK 텍스트 (Transform + Opacity)
              Transform.translate(
                offset: Offset(currentTextX, 0),
                child: Opacity(
                  opacity: textAnimation.value, // Fade-in 효과
                  child: const Text(
                    'KUKK\nKUKK',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: logoFontSize,
                      fontWeight: FontWeight.bold,
                      color: logoColor,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}