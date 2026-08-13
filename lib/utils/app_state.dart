import 'package:flutter/material.dart';

// ใช้ ValueNotifier เก็บ Set ของ ID เพื่อให้ Widget ที่ดักฟังอยู่ (Listener) อัปเดต UI อัตโนมัติเมื่อข้อมูลเปลี่ยน
final ValueNotifier<Set<String>> globalSavedIds = ValueNotifier<Set<String>>({});