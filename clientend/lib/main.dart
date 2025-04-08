import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/app/routes/app_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kkuk_kkuk/shared/config/app_config.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await AppConfig.load();

  // kakao sdk 초기화
  KakaoSdk.init(nativeAppKey: AppConfig.kakaoAppKey);
  AuthRepository.initialize(
      appKey: AppConfig.kakaoJavaScriptKey,
      baseUrl: AppConfig.apiBaseUrl
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '꾹꾹',
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          foregroundColor: Color.fromARGB(255, 30, 64, 175),
          backgroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 30, 64, 175),
          primary: const Color.fromARGB(255, 30, 64, 175),
        ),
      ),
    );
  }
}
