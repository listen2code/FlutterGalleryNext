import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:package_libs/utils/auth_util.dart';
import 'package:package_libs/utils/sp_util.dart';

class BiometricAuthLockDialog extends StatefulWidget {
  static const String tag = "BiometricAuthLockDialog";

  const BiometricAuthLockDialog({super.key});

  static void show() {
    SmartDialog.show(
      tag: tag,
      backType: SmartBackType.block,
      clickMaskDismiss: false,
      builder: (_) => const BiometricAuthLockDialog(),
    );
  }

  static dismiss() {
    SmartDialog.dismiss(tag: tag);
  }

  @override
  State<BiometricAuthLockDialog> createState() => _BiometricAuthLockDialogState();
}

class _BiometricAuthLockDialogState extends State<BiometricAuthLockDialog> {
  String _timeoutLabel = "0";

  @override
  void initState() {
    super.initState();
    _loadTimeout();
    // Automatically trigger authentication when dialog appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAuth();
    });
  }

  void _loadTimeout() {
    setState(() {
      _timeoutLabel = SpUtil.instance.getString(AuthUtil.keyAuthTimeout, defaultValue: "0");
    });
  }

  Future<void> _startAuth() async {
    final result = await AuthUtil.instance().authenticate();
    if (result == AuthResult.success) {
      BiometricAuthLockDialog.dismiss();
    }
  }

  void _handleReset() {
    GlobalDialog.showConfirmDialog(
      "This will clear your lock settings. Continue?",
      title: "Reset Authentication",
      onOkPressed: () {
        AuthUtil.instance().clearWhenForgetPassword();
        BiometricAuthLockDialog.dismiss();
        SmartDialog.dismiss();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colors.foreground.withAlpha(40),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colors.blue100,
                  child: Icon(Icons.lock_outline, color: colors.blue600, size: 32),
                ),
                const SizedBox(height: 20),
                Text(
                  "App Locked",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.foreground,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Timeout set to ${_timeoutLabel}m",
                  style: TextStyle(color: colors.neutral500, fontSize: 13),
                ),
                const SizedBox(height: 32),

                // Primary Auth Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: colors.blue600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _startAuth,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text("Unlock with Biometrics"),
                ),

                const SizedBox(height: 12),

                // Reset Button
                TextButton(
                  onPressed: _handleReset,
                  child: Text(
                    "Forgot Password / Reset",
                    style: TextStyle(color: colors.red500, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
