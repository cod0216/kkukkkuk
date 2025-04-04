import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';

/// 최대 표시할 소유자 수
const int _maxDisplayedOwners = 3;

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
                          Row(
                            children: [
                              Text(
                                wallet.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 소유자 프로필 표시
                              if (wallet.owners != null &&
                                  wallet.owners!.isNotEmpty)
                                ..._buildOwnerAvatars(wallet.owners!),
                            ],
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

  /// 소유자 아바타 목록 생성
  List<Widget> _buildOwnerAvatars(List<Owner> owners) {
    // 최대 표시할 소유자 수 제한
    final displayedOwners =
        owners.length > _maxDisplayedOwners
            ? owners.sublist(0, _maxDisplayedOwners)
            : owners;

    final avatars =
        displayedOwners.map((owner) {
          return Tooltip(
            message: owner.name,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    owner.image != null ? NetworkImage(owner.image!) : null,
                child:
                    owner.image == null
                        ? const Icon(Icons.person, size: 12, color: Colors.grey)
                        : null,
              ),
            ),
          );
        }).toList();

    // 표시되지 않는 소유자가 있는 경우 +N 표시 추가
    if (owners.length > _maxDisplayedOwners) {
      avatars.add(
        Tooltip(
          message: '${owners.length - _maxDisplayedOwners}명의 소유자 더 보기',
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[300],
            child: Text(
              '+${owners.length - _maxDisplayedOwners}',
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ),
      );
    }

    return avatars;
  }
}
