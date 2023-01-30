import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar({String? title, String? body, Color? backgroundColor}) {
  try {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor ?? const Color(0xFF303030),
        message: body != null && body.trim().isNotEmpty ? body : "error occurred",
        duration: const Duration(seconds: 2),
        borderRadius: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  } catch (e) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor ?? const Color(0xFF303030),
        message: "error occurred",
        duration: const Duration(seconds: 2),
        borderRadius: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}
