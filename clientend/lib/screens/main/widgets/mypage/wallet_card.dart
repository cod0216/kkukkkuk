import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/wallet/owner.dart';
import 'package:kkuk_kkuk/entities/wallet/wallet.dart';

/// 지갑 정보 카드 위젯
class WalletCard extends StatefulWidget {
  final List<Wallet> wallets;
  final String? activeWalletAddress;
  final Function(int, String)? onWalletNameUpdate; // Add this
  final Function(int)? onWalletDelete; // Add this

  const WalletCard({
    super.key,
    required this.wallets,
    this.activeWalletAddress,
    this.onWalletNameUpdate, // Add this
    this.onWalletDelete, // Add this
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  // 확장된 지갑 ID를 추적하는 Set
  final Set<int> _expandedWalletIds = {};

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            ..._buildWalletList(),
          ],
        ),
      ),
    );
  }

  /// 카드 헤더 위젯 생성
  Widget _buildHeader() {
    return const Text(
      '내 지갑',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// 지갑 목록 위젯 생성
  List<Widget> _buildWalletList() {
    return widget.wallets.map((wallet) {
      final isActive = _isWalletActive(wallet);
      final isExpanded = _expandedWalletIds.contains(wallet.id);

      return Column(
        children: [
          _buildWalletItem(wallet, isActive, isExpanded),
          if (isExpanded && wallet.owners != null && wallet.owners!.isNotEmpty)
            _buildOwnersList(wallet.owners!),
          if (wallet != widget.wallets.last) const Divider(),
        ],
      );
    }).toList();
  }

  /// 지갑 아이템 위젯 생성
  Widget _buildWalletItem(Wallet wallet, bool isActive, bool isExpanded) {
    return InkWell(
      onTap: () => _toggleExpansion(wallet.id),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Expanded(child: _buildWalletInfo(wallet)),
            if (isActive) _buildActiveIndicator(),
            _buildExpansionIcon(isExpanded),
          ],
        ),
      ),
    );
  }

  /// 지갑 정보 위젯 생성
  Widget _buildWalletInfo(Wallet wallet) {
    final isExpanded = _expandedWalletIds.contains(wallet.id);
    final isActive = _isWalletActive(wallet);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    wallet.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (isExpanded && widget.onWalletNameUpdate != null) ...[
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditDialog(wallet),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                    if (!isActive && widget.onWalletDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => _showDeleteDialog(wallet),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (!isExpanded &&
                wallet.owners != null &&
                wallet.owners!.isNotEmpty)
              ..._buildOwnerAvatarsInline(wallet.owners!),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${wallet.address.substring(0, 10)}...${wallet.address.substring(wallet.address.length - 8)}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  /// 지갑 이름 수정 다이얼로그 표시
  void _showEditDialog(Wallet wallet) {
    final TextEditingController controller = TextEditingController(
      text: wallet.name,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('지갑 이름 수정'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: '새 지갑 이름'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    widget.onWalletNameUpdate?.call(wallet.id, controller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('수정'),
              ),
            ],
          ),
    );
  }

  /// 지갑 삭제 확인 다이얼로그 표시
  void _showDeleteDialog(Wallet wallet) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('지갑 삭제'),
            content: const Text('정말로 이 지갑을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  widget.onWalletDelete?.call(wallet.id);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }

  /// 인라인 소유자 아바타 목록 생성 (지갑 이름 옆에 표시)
  List<Widget> _buildOwnerAvatarsInline(List<Owner> owners) {
    // 최대 표시할 소유자 수 제한
    const int maxDisplayedOwners = 3;
    final displayedOwners =
        owners.length > maxDisplayedOwners
            ? owners.sublist(0, maxDisplayedOwners)
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
    if (owners.length > maxDisplayedOwners) {
      avatars.add(
        Tooltip(
          message: '${owners.length - maxDisplayedOwners}명의 소유자 더 보기',
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[300],
            child: Text(
              '+${owners.length - maxDisplayedOwners}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      );
    }

    return avatars;
  }

  /// 활성화 표시 위젯 생성
  Widget _buildActiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  /// 확장 아이콘 위젯 생성
  Widget _buildExpansionIcon(bool isExpanded) {
    return Icon(
      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      color: Colors.grey[600],
    );
  }

  /// 소유자 목록 위젯 생성
  Widget _buildOwnersList(List<Owner> owners) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: owners.map((owner) => _buildOwnerItem(owner)).toList(),
      ),
    );
  }

  /// 소유자 아이템 위젯 생성
  Widget _buildOwnerItem(Owner owner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildOwnerAvatar(owner),
          const SizedBox(width: 12),
          Text(owner.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
        ],
      ),
    );
  }

  /// 소유자 아바타 위젯 생성
  Widget _buildOwnerAvatar(Owner owner) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey[200],
      backgroundImage: owner.image != null ? NetworkImage(owner.image!) : null,
      child:
          owner.image == null
              ? const Icon(Icons.person, size: 16, color: Colors.grey)
              : null,
    );
  }

  /// 지갑이 활성화되었는지 확인
  bool _isWalletActive(Wallet wallet) {
    return widget.activeWalletAddress != null &&
        wallet.address.toLowerCase() ==
            widget.activeWalletAddress!.toLowerCase();
  }

  /// 지갑 확장 상태 토글
  void _toggleExpansion(int walletId) {
    setState(() {
      if (_expandedWalletIds.contains(walletId)) {
        _expandedWalletIds.remove(walletId);
      } else {
        _expandedWalletIds.add(walletId);
      }
    });
  }
}
