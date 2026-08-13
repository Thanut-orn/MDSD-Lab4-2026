import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  
  // ── 1. เพิ่มตัวแปรสำหรับ Category Filter ตาม Checkpoint 7.1 ──
  String _selectedTag = 'ทั้งหมด';
  final List<String> _allTags = ['ทั้งหมด', 'ทะเล', 'ธรรมชาติ', 'วัฒนธรรม', 'อาหาร', 'ช้อปปิ้ง'];

  // ── 2. อัปเดต Logic กรองข้อมูลให้รองรับทั้ง Search และ Tag Filter ──
  List<Destination> get _filteredDestinations {
    return sampleDestinations.where((d) {
      // เช็คการค้นหาจาก Text (Search Bar)
      final matchQuery = _searchQuery.isEmpty ||
          d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.country.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));

      // เช็คการกรองจากปุ่ม (Filter Chip)
      final matchTag = _selectedTag == 'ทั้งหมด' || d.tags.contains(_selectedTag);

      // ต้องผ่านทั้ง 2 เงื่อนไขถึงจะแสดงผล
      return matchQuery && matchTag;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สำรวจ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'ค้นหา Destination...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          // ── 3. เพิ่ม Widget Filter Chip ระหว่าง Search Bar กับ Grid ──
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _allTags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final tag = _allTags[index];
                final isSelected = tag == _selectedTag;
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedTag = tag),
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade700,
                );
              },
            ),
          ),
          const SizedBox(height: 12), // เพิ่มระยะห่างด้านล่าง Filter นิดหน่อย
          
          // ── สลับโหมด: ถ้ามีการค้นหา หรือ มีการเลือก Tag (ที่ไม่ใช่ "ทั้งหมด") ให้แสดง Grid ──
          Expanded(
            child: (_searchQuery.isNotEmpty || _selectedTag != 'ทั้งหมด') 
                ? _buildGridView() 
                : _buildDashboard(),
          ),
        ],
      ),
    );
  }

  // 1. หน้าจอ Dashboard 
  Widget _buildDashboard() {
    final sortedDestinations = List<Destination>.from(sampleDestinations)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final topRated = sortedDestinations.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('สวัสดี, นักเดินทาง! 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('แนะนำสำหรับคุณ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 310,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sampleDestinations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) => DestinationCard(
                destination: sampleDestinations[index],
                onTap: () => context.pushNamed('destination-detail', pathParameters: {'id': sampleDestinations[index].id}, extra: sampleDestinations[index]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('สถิติการเดินทาง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            _buildStatCard('5', 'Trip', Colors.blue.shade50, Colors.blue),
            const SizedBox(width: 12),
            _buildStatCard('3', 'Country', Colors.orange.shade50, Colors.orange),
            const SizedBox(width: 12),
            _buildStatCard('12', 'Saved', Colors.pink.shade50, Colors.pink),
          ]),
          const SizedBox(height: 24),
          const Text('รีวิวยอดนิยม', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topRated.length,
                itemBuilder: (context, index) {
                  final d = topRated[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(d.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(d.country),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${d.rating}'),
                        ],
                      ),
                      onTap: () => context.pushNamed('destination-detail', pathParameters: {'id': d.id}, extra: d),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 2. หน้าจอผลลัพธ์ค้นหา (Grid)
  Widget _buildGridView() {
    return _filteredDestinations.isEmpty 
      ? const Center(child: Text('ไม่พบข้อมูล'))
      : GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.72,
          ),
          itemCount: _filteredDestinations.length,
          itemBuilder: (context, index) => DestinationCard(
            destination: _filteredDestinations[index],
            onTap: () => context.pushNamed('destination-detail', pathParameters: {'id': _filteredDestinations[index].id}, extra: _filteredDestinations[index]),
          ),
        );
  }

  Widget _buildStatCard(String value, String label, Color bgColor, Color textColor) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        Text(label, style: TextStyle(fontSize: 12, color: textColor.withAlpha(200))),
      ]),
    ));
  }
}