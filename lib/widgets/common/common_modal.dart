import 'package:flutter/material.dart';

class CommonModal extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClose;

  const CommonModal({
    super.key,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 얇은 AppBar + X 버튼
          Container(
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF778557),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          // 본문(커스텀 위젯)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: child,
          ),
        ],
      ),
    );
  }
}

Future<T?> showCommonModal<T>({
  required BuildContext context,
  required Widget child,
  VoidCallback? onClose,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CommonModal(
      child: child,
      onClose: onClose,
    ),
  );
}
