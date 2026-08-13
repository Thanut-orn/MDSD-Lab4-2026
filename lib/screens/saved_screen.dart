import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart'; // 👈 นำเข้าไฟล์นี้เพื่อให้เรียกใช้ SavedManager ได้

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกไว้', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      // 📝 จุดซับซ้อนที่ 1: ใช้ ValueListenableBuilder เพื่อดักจับ State แบบเรียลไทม์
      // วิดเจ็ตนี้จะทำการ Build หน้าจอตัวเองใหม่โดยอัตโนมัติทันทีที่ค่า SavedManager.savedIds 
      // มีการเพิ่มหรือลบข้อมูล (เช่น กด Unsave แล้วหายไปทันทีโดยไม่ต้อง setState)
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: SavedManager.savedIds,
        builder: (context, savedIds, child) {
          
          // 📝 จุดซับซ้อนที่ 2: การใช้ .where() กรองข้อมูลจาก Database จำลอง
          // ค้นหาเฉพาะ Destination ที่มี id ตรงกับ id ที่เก็บอยู่ใน State ที่ผู้ใช้กดถูกใจไว้
          // แล้วแปลงกลับเป็น List ให้พร้อมใช้งานกับ GridView
          final savedDestinations = sampleDestinations
              .where((d) => savedIds.contains(d.id))
              .toList();

          // แสดง Empty State กรณีไม่มีข้อมูล
          if (savedDestinations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('ยังไม่มีสถานที่ที่บันทึกไว้', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          // 📝 จุดซับซ้อนที่ 3: ใช้ LayoutBuilder ทำ Responsive GridView
          // ตรวจสอบความกว้างของหน้าจอ (constraints.maxWidth) หากหน้าจอกว้างกว่า 600
          // จะแสดง 3 คอลัมน์ (Tablet/Web) หากแคบกว่าจะแสดง 2 คอลัมน์ (Mobile)
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: savedDestinations.length,
                itemBuilder: (context, index) {
                  final destination = savedDestinations[index];
                  return DestinationCard(
                    destination: destination,
                    isGridItem: true, // 👈 ส่งค่าเป็น true เพื่อให้การ์ดแสดงผลพอดีช่อง Grid
                    onTap: () => context.pushNamed(
                      'destination-detail',
                      pathParameters: {'id': destination.id},
                      extra: destination,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}