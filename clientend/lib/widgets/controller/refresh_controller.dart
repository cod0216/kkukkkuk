// lib/pages/pet_profile/pet_profile_screen.dart

import 'package:flutter/material.dart';

class RefreshController {
  VoidCallback? _onRefreshCompleted;
  VoidCallback? _onRefreshFailed;
  void refreshCompleted() {
    _onRefreshCompleted?.call();
  }

  void refreshFailed() {
    _onRefreshFailed?.call();
  }

  void dispose() {
    _onRefreshCompleted = null;
    _onRefreshFailed = null;
  }

  void setCallbacks({VoidCallback? onCompleted, VoidCallback? onFailed}) {
    _onRefreshCompleted = onCompleted;
    _onRefreshFailed = onFailed;
  }
}
