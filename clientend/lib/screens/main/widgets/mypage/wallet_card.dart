import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';

/// 지갑 정보 카드 위젯
class WalletCard extends StatelessWidget {
  final List<Wallet> wallets;
  final String? activeWalletAddress;

  const WalletCard({
    super.key, 
    required this.wallets,
    this.activeWalletAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내 지갑',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 지갑 목록
            ...wallets.map((wallet) {
              final isActive =
                  activeWalletAddress != null &&
                  wallet.address.toLowerCase() ==
                      activeWalletAddress!.toLowerCase();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${wallet.address.substring(0, 10)}...${wallet.address.substring(wallet.address.length - 8)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 활성화된 지갑 표시
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '활성화됨',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}