import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/pages/wallet/views/wallet_choice_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/mnemonic_display_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/mnemonic_confirmation_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/wallet_recovery_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/wallet_naming_view.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart'; // CustomAppBar 사용
import 'package:kkuk_kkuk/widgets/common/loading_indicator.dart';
import 'package:kkuk_kkuk/widgets/common/error_view.dart';

/// 지갑 설정 화면
class WalletScreen extends ConsumerWidget {
  final StateNotifierProvider<WalletNotifier, WalletState> viewModel;

  const WalletScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(viewModel);
    final walletNotifier = ref.read(viewModel.notifier);

    // 뒤로가기 버튼 숨김 (라우터 설정에서 관리하거나 여기서 직접 제어)
    final bool canPop = Navigator.of(context).canPop();

    return Scaffold(
      // hideBackButton을 canPop 기준으로 설정
      appBar: CustomAppBar(),
      body: _buildCurrentView(context, ref, walletState, walletNotifier), // Padding 제거
    );
  }

  /// 현재 상태에 맞는 뷰 반환 (Padding 추가)
  Widget _buildCurrentView(
      BuildContext context,
      WidgetRef ref,
      WalletState walletState,
      WalletNotifier viewModel,
      ) {
    Widget currentView;

    switch (walletState.status) {
      case WalletStatus.initial:
      case WalletStatus.walletChoice:
        currentView = const WalletChoiceView();
        break; // 각 case 끝에 break 추가

      case WalletStatus.generatingMnemonic:
        currentView = _buildGeneratingView();
        break;

      case WalletStatus.mnemonicGenerated:
      // MnemonicDisplayView는 자체적으로 Expanded를 사용하므로 Padding만 적용
        currentView = MnemonicDisplayView(walletState: walletState);
        break;

      case WalletStatus.mnemonicConfirmation:
      // MnemonicConfirmationView는 자체적으로 Expanded를 사용하므로 Padding만 적용
        currentView = MnemonicConfirmationView(walletState: walletState);
        break;

      case WalletStatus.recoveringWallet:
      // WalletRecoveryView는 자체적으로 Expanded를 사용하므로 Padding만 적용
        currentView = const WalletRecoveryView();
        break;

      case WalletStatus.namingWallet:
        currentView = const WalletNamingView();
        break;

      case WalletStatus.creatingWallet:
      case WalletStatus.registeringWallet:
        currentView = _buildCreatingWalletView();
        break;

      case WalletStatus.error:
        currentView = ErrorView(
          message: walletState.error ?? '지갑 생성 중 오류가 발생했습니다.',
          onRetry: () => viewModel.handleErrorRetry(),
        );
        break;

      case WalletStatus.completed:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
          } else {
            // Pop할 수 없는 경우 (예: 직접 /wallet-creation 접근 시) 홈으로 이동 등 대체 경로 필요
            context.go('/pets'); // 예시: 홈으로 이동
          }
        });
        currentView = const Center( // 완료 화면은 간단히 표시
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('지갑 설정 완료!'),
            ],
          ),
        );
        break; // break 추가
    }

    // SafeArea와 Padding을 여기서 적용
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // Column으로 감싸서 Expanded가 아닌 위젯들도 포함 가능하도록 함
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Column 자식들이 가로로 확장되도록
            children: [
              // Expanded가 필요한 뷰 (Display, Confirmation, Recovery)는 내부적으로 처리,
              // 나머지는 직접 표시
              if (currentView is MnemonicDisplayView ||
                  currentView is MnemonicConfirmationView ||
                  currentView is WalletRecoveryView ||
                  currentView is WalletNamingView || // NamingView도 Expanded 필요 가정
                  currentView is WalletChoiceView    // ChoiceView도 Expanded 필요
              )
                Expanded(child: currentView)
              else
                currentView, // 다른 뷰들은 직접 표시 (Loading, Error, Completed 등)
            ]
        ),
      ),
    );
  }

  // 로딩 뷰 (기존 코드 활용, Expanded 제거)
  Widget _buildGeneratingView() {
    return const Center( // Expanded 대신 Center 사용
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingIndicator(), // LoadingIndicator 는 Center를 포함하고 있음
          SizedBox(height: 16),
          Text('니모닉 단어를 생성하는 중입니다...', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  // 로딩 뷰 (기존 코드 활용, Expanded 제거)
  Widget _buildCreatingWalletView() {
    return const Center( // Expanded 대신 Center 사용
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingIndicator(), // LoadingIndicator 는 Center를 포함하고 있음
          SizedBox(height: 16),
          Text('지갑을 생성/등록하는 중입니다...', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}