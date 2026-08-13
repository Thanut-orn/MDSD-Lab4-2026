import 'package:flutter/material.dart';
import '../models/destination.dart';

// ── คลาสจัดการ State สำหรับเก็บรายการที่ถูกบันทึก (Global State) ──
class SavedManager {
  static final ValueNotifier<Set<String>> savedIds = ValueNotifier<Set<String>>({});

  static bool toggle(String id) {
    final current = Set<String>.from(savedIds.value);
    bool newlySaved = false;
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
      newlySaved = true;
    }
    savedIds.value = current;
    return newlySaved; 
  }
}

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;
  
  // เพิ่ม parameter นี้เพื่อเช็คว่า Card นี้กำลังแสดงใน Grid หรือไม่ (จะช่วยลดปัญหาขอบเบี้ยว)
  final bool isGridItem;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
    this.isGridItem = false, // ค่าเริ่มต้นเป็น false (สำหรับใช้ใน ListView แนวนอน)
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // ถ้าแสดงใน Grid ให้กว้างเต็มพื้นที่ ถ้าเป็นแนวนอนให้กว้าง 280
        width: isGridItem ? null : 280, 
        // ถ้าแสดงใน Grid ไม่ต้องมี margin ขวา 
        margin: isGridItem ? EdgeInsets.zero : const EdgeInsets.only(right: 16), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              // ── 3. Stack: Image + Rating Badge + Favorite Button ──
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      destination.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 48),
                      ),
                    ),
                  ),
                  
                  // 🎯 เช็คข้อ 1 & 3: ย้าย Rating Badge มามุมซ้ายล่าง และเขียน Comment อธิบาย Positioned
                  Positioned(
                    bottom: 8, 
                    left: 8,  
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            destination.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ปุ่มหัวใจ (ย้ายมามุมขวาบน เพื่อไม่ให้ซ้อนทับ หรือแย่งจุดเด่นกันกับ Rating)
                  Positioned(
                    top: 8,
                    right: 8, 
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: SavedManager.savedIds,
                      builder: (context, savedIds, _) {
                        final isSaved = savedIds.contains(destination.id);
                        return GestureDetector(
                          onTap: () {
                            final newlySaved = SavedManager.toggle(destination.id);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  newlySaved
                                      ? 'บันทึก ${destination.name} แล้ว! ❤️'
                                      : 'ยกเลิกการบันทึก ${destination.name} แล้ว',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved ? Icons.favorite : Icons.favorite_border,
                              color: isSaved ? Colors.pinkAccent : Colors.white,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // ── 4. Info Section ────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            destination.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${destination.price}/คืน',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          destination.country,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: destination.tags.map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.blue.shade50,
                        shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
                        padding: EdgeInsets.zero,
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    
                    // 🎯 เช็คข้อ 2: เพิ่ม Row แสดงไอคอนเตียงและข้อความ "พร้อมเข้าพัก" 
                    Row(
                      children: const [
                        Icon(Icons.bed, size: 14, color: Colors.blue),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "พร้อมเข้าพัก",
                            style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}