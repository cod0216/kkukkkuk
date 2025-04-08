import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/wallet/owner.dart';
import 'package:kkuk_kkuk/entities/wallet/wallet.dart';

class WalletItem extends StatefulWidget {
  final Wallet wallet;
  final bool isActive;
  final Function(int, String)? onWalletNameUpdate;
  final Function(int)? onWalletDelete;

  const WalletItem({
    super.key, // key 파라미터 추가
    required this.wallet,
    required this.isActive,
    this.onWalletNameUpdate,
    this.onWalletDelete,
  });

  @override
  State<WalletItem> createState() => _WalletItemState();
}

// SingleTickerProviderStateMixin 추가 (RotationTransition을 위해)
class _WalletItemState extends State<WalletItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final double _avatarRadius = 12.0;

  // 애니메이션 컨트롤러 및 애니메이션 변수 선언
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // 애니메이션 컨트롤러 초기화
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 250), // 애니메이션 속도 조절
      vsync: this,
    );
    // 회전 애니메이션 설정 (0도 -> 180도)
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  // 확장/축소 토글 함수 (애니메이션 실행 추가)
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward(); // 펼침 애니메이션
      } else {
        _rotationController.reverse(); // 접힘 애니메이션
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isShared =
        widget.wallet.owners != null && widget.wallet.owners!.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpansion,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 기본 정보 Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 왼쪽: 이름(+ 활성 아이콘), 편집 아이콘 등, 주소
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이름(+ 체크) + 편집/삭제/공유 아이콘 Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 이름 + 체크 아이콘 그룹
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.wallet.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    if (widget.isActive)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4.0,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // 편집/삭제/공유 아이콘들
                              const SizedBox(width: 6),
                              if (isShared)
                                _buildIconButton(
                                  Icons.people_outline,
                                  null,
                                  18,
                                  Colors.grey.shade600,
                                ),
                              if (widget.onWalletNameUpdate != null)
                                _buildIconButton(
                                  Icons.edit_outlined,
                                  () => _showEditDialog(widget.wallet),
                                  18,
                                ),
                              if (!widget.isActive &&
                                  widget.onWalletDelete != null)
                                _buildIconButton(
                                  Icons.delete_outline,
                                  () => _showDeleteDialog(widget.wallet),
                                  18,
                                  Colors.red.shade700,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // 지갑 주소
                          Text(
                            '${widget.wallet.address.substring(0, 10)}...${widget.wallet.address.substring(widget.wallet.address.length - 8)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 오른쪽: 아바타(축소 시), 확장 아이콘 (회전 애니메이션 적용)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!_isExpanded &&
                            !widget.isActive &&
                            widget.wallet.owners != null &&
                            widget.wallet.owners!.isNotEmpty)
                          buildOwnerAvatarsInline(widget.wallet.owners!),
                        const SizedBox(width: 8),
                        // 확장 아이콘 (RotationTransition 적용)
                        _buildExpansionIcon(), // isExpanded 파라미터 제거
                      ],
                    ),
                  ],
                ),
                // 확장 시 소유자 목록 표시 (AnimatedSize 적용)
                AnimatedSize(
                  duration: const Duration(milliseconds: 250), // 크기 변화 속도
                  curve: Curves.easeInOut, // 크기 변화 곡선
                  alignment: Alignment.topCenter,
                  child:
                      (_isExpanded &&
                              widget.wallet.owners != null &&
                              widget.wallet.owners!.isNotEmpty)
                          ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: _buildOwnersList(widget.wallet.owners!),
                          )
                          : const SizedBox.shrink(), // 접혔을 때는 크기 0
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper 메서드 (RotationTransition 사용하는 _buildExpansionIcon 외에는 이전과 동일) ---

  Widget _buildIconButton(
    IconData icon,
    VoidCallback? onPressed,
    double size, [
    Color? color,
  ]) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Icon(
          icon,
          size: size,
          color: onPressed == null ? Colors.grey.shade400 : color,
        ),
      ),
    );
  }

  Widget buildOwnerAvatarsInline(List<Owner> owners) {
    const double overlap = 8.0;
    const int maxDisplayedOwners = 2;
    final displayedOwners =
        owners.length > maxDisplayedOwners
            ? owners.sublist(0, maxDisplayedOwners)
            : owners;
    if (displayedOwners.isEmpty) return SizedBox(width: _avatarRadius * 2);
    double totalWidth =
        (displayedOwners.length * (_avatarRadius * 2)) -
        ((displayedOwners.length - 1) * overlap);
    bool showPlusN = owners.length > maxDisplayedOwners;
    if (showPlusN) {
      totalWidth += (_avatarRadius * 2) - overlap;
    }
    List<Widget> avatarWidgets =
        List.generate(displayedOwners.length, (index) {
          final owner = displayedOwners[index];
          return Positioned(
            right: index * (_avatarRadius * 2 - overlap),
            child: Tooltip(
              message: owner.name,
              child: _buildOwnerAvatar(owner, _avatarRadius),
            ),
          );
        }).reversed.toList();
    if (showPlusN) {
      avatarWidgets.add(
        Positioned(
          right: maxDisplayedOwners * (_avatarRadius * 2 - overlap),
          child: Tooltip(
            message: '${owners.length - maxDisplayedOwners}명의 소유자 더 보기',
            child: CircleAvatar(
              radius: _avatarRadius,
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
        ),
      );
    }
    return Container(
      width: totalWidth,
      height: _avatarRadius * 2,
      child: Stack(alignment: Alignment.centerRight, children: avatarWidgets),
    );
  }

  // 확장 아이콘 (RotationTransition 사용)
  Widget _buildExpansionIcon() {
    return RotationTransition(
      turns: _rotationAnimation,
      child: Icon(
        Icons.keyboard_arrow_down, // 아이콘 고정
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildOwnersList(List<Owner> owners) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: owners.map((owner) => _buildOwnerItem(owner)).toList(),
      ),
    );
  }

  Widget _buildOwnerItem(Owner owner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          _buildOwnerAvatar(owner, 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              owner.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerAvatar(Owner owner, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage:
          (owner.image != null && owner.image!.isNotEmpty)
              ? NetworkImage(owner.image!)
              : null,
      child:
          (owner.image == null || owner.image!.isEmpty)
              ? Icon(Icons.person, size: radius * 1.1, color: Colors.grey)
              : null,
    );
  }

  void _showEditDialog(Wallet wallet) {
    final TextEditingController controller = TextEditingController(
      text: wallet.name,
    );
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('지갑 이름 수정'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: '새 지갑 이름'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    widget.onWalletNameUpdate?.call(
                      wallet.id,
                      controller.text.trim(),
                    );
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('수정'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(Wallet wallet) {
    if (widget.isActive) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('활성화된 지갑은 삭제할 수 없습니다.')));
      return;
    }
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('지갑 삭제'),
            content: Text('\'${wallet.name}\' 지갑을 정말로 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  widget.onWalletDelete?.call(wallet.id);
                  Navigator.pop(dialogContext);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }
}
