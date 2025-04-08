import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/wallet/wallet.dart';
import 'package:kkuk_kkuk/widgets/common/primary_section.dart';
import 'package:kkuk_kkuk/widgets/mypage/wallet_item.dart';

/// 지갑 목록을 표시하는 섹션 위젯
class WalletListSection extends StatelessWidget {
  final List<Wallet> wallets;
  final String? activeWalletAddress;
  final Function(int, String)? onWalletNameUpdate;
  final Function(int)? onWalletDelete;

  const WalletListSection({
    super.key,
    required this.wallets,
    this.activeWalletAddress,
    this.onWalletNameUpdate,
    this.onWalletDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PrimarySection(
      title: '내 지갑', // 섹션 제목
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          final isActive =
              activeWalletAddress != null &&
              wallet.address.toLowerCase() ==
                  activeWalletAddress!.toLowerCase();

          return WalletItem(
            // key 추가: 상태가 올바르게 유지되도록 고유 키 제공
            key: ValueKey('wallet_${wallet.id}'),
            wallet: wallet,
            isActive: isActive,
            onWalletNameUpdate: onWalletNameUpdate,
            onWalletDelete: onWalletDelete,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}
