import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ข้อ 2: เขียน Logic Sort เรียงลำดับ Destination ตาม rating จากมากไปน้อย
    final sortedDestinations = List<Destination>.from(sampleDestinations)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final topRatedDestinations = sortedDestinations.take(3).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'สวัสดี, นักเดินทาง! 👋',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ไปไหนดีวันนี้?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── 1. Featured Section (แสดงทั้งหมด ไม่จำกัดแค่ 3 รายการ) ──
            const Text(
              'แนะนำสำหรับคุณ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                // ข้อ 1: เปลี่ยนจาก take(3) เป็นแสดง sampleDestinations ทั้งหมด
                itemCount: sampleDestinations.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final destination = sampleDestinations[index];
                  return DestinationCard(
                    destination: destination,
                    onTap: () {
                      context.pushNamed(
                        'destination-detail',
                        pathParameters: {'id': destination.id},
                        extra: destination,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Quick Stats Section ──
            const Text(
              'สถิติการเดินทาง',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('5', 'Trip', Colors.blue.shade50, Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard('3', 'Country', Colors.orange.shade50, Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard('12', 'Saved', Colors.pink.shade50, Colors.pink),
              ],
            ),
            const SizedBox(height: 24),

            // ── 2. Section ใหม่: "รีวิวยอดนิยม" ──
            const Text(
              'รีวิวยอดนิยม',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // ข้อ 2 & 3: ใช้ Column ครอบ ListView แนวตั้ง พร้อมกำหนด shrinkWrap และ physics
            Column(
              children: topRatedDestinations.map((destination) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        destination.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, _) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, size: 24),
                        ),
                      ),
                    ),
                    title: Text(
                      destination.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(destination.country),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          destination.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.pushNamed(
                        'destination-detail',
                        pathParameters: {'id': destination.id},
                        extra: destination,
                      );
                    },
                  ),
                );
              }).toList(),
            ),

            // หากใช้ ListView ร่วมด้วย สามารถใส่ comment อธิบายตามข้อ 3 ได้ดังนี้:
            /* 
              // ข้อ 3: ทำไมต้องใส่ shrinkWrap: true และ NeverScrollableScrollPhysics() เมื่อวาง ListView ซ้อนใน Column ที่อยู่ใน SingleChildScrollView:
              // - shrinkWrap: true: ทำให้ ListView หดตัวและมีความสูงเท่ากับเนื้อหาด้านในพอดี ไม่พยายามขยายขนาดความสูงไปจนถึงอนันต์ (Unbounded height)
              // - NeverScrollableScrollPhysics: ปิดการเลื่อนของตัว ListView ย่อย เพื่อป้องกันความขัดแย้งในการเลื่อน (Scroll Conflict) กับ SingleChildScrollView ตัวแม่ด้านนอก 
              // ถ้าไม่ใส่จะทำให้เกิด Error "Vertical viewport was given unbounded height" และแอปจะพังทันที
            */
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textColor.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }
}