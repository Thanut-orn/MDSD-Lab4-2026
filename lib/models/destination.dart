// ทุก Field เป็น final เพราะ Destination ควรเป็น Immutable Object
// (สร้างแล้วไม่แก้ไขค่าเดิม ถ้าต้องการเปลี่ยนค่าให้สร้าง Object ใหม่แทน)
class Destination {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final double rating;
  final int price; // ราคาโดยประมาณ (USD/คืน)
  final List<String> tags;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.tags,
  });
}

// ข้อมูลตัวอย่าง
final List<Destination> sampleDestinations = [
  Destination(
    id: '1',
    name: 'กรุงเทพฯ',
    country: 'ไทย',
    description:
        'เมืองหลวงที่คึกคักของไทย เต็มไปด้วยวัดวาอาราม อาหารริมทาง และชีวิตยามค่ำคืนที่ไม่รู้จบ',
    imageUrl: 'https://picsum.photos/seed/bangkok/400/300',
    rating: 4.7,
    price: 50,
    tags: ['วัด', 'อาหาร', 'ช้อปปิ้ง'],
  ),
  Destination(
    id: '2',
    name: 'เชียงใหม่',
    country: 'ไทย',
    description:
        'เมืองทางเหนือที่ล้อมรอบด้วยภูเขา วัดโบราณ และวัฒนธรรมล้านนา',
    imageUrl: 'https://picsum.photos/seed/chiangmai/400/300',
    rating: 4.8,
    price: 35,
    tags: ['ธรรมชาติ', 'วัฒนธรรม', 'Trekking'],
  ),
  Destination(
    id: '3',
    name: 'ภูเก็ต',
    country: 'ไทย',
    description: 'เกาะที่สวยงามที่สุดของไทย มีหาดทรายขาว น้ำทะเลใส และกิจกรรมดำน้ำ',
    imageUrl: 'https://picsum.photos/seed/phuket/400/300',
    rating: 4.6,
    price: 80,
    tags: ['ทะเล', 'ดำน้ำ', 'รีสอร์ท'],
  ),
  Destination(
    id: '4',
    name: 'โตเกียว',
    country: 'ญี่ปุ่น',
    description: 'มหานครที่ผสมผสานความทันสมัยและวัฒนธรรมดั้งเดิมได้อย่างลงตัว',
    imageUrl: 'https://picsum.photos/seed/tokyo/400/300',
    rating: 4.9,
    price: 120,
    tags: ['เทคโนโลยี', 'อาหาร', 'อนิเมะ'],
  ),
  Destination(
    id: '5',
    name: 'บาหลี',
    country: 'อินโดนีเซีย',
    description: 'เกาะแห่งพระเจ้า เต็มไปด้วยวัดและชายหาดสวยงาม',
    imageUrl: 'https://picsum.photos/seed/bali/400/300',
    rating: 4.7,
    price: 60,
    tags: ['วัฒนธรรม', 'ทะเล', 'Yoga'],
  ),
  Destination(
    id: '6',
    name: 'สิงคโปร์',
    country: 'สิงคโปร์',
    description: 'นครรัฐที่สะอาด ทันสมัย และปลอดภัย มีอาหารหลากหลายวัฒนธรรม',
    imageUrl: 'https://picsum.photos/seed/singapore/400/300',
    rating: 4.8,
    price: 150,
    tags: ['ช้อปปิ้ง', 'อาหาร', 'สวนสนุก'],
  ),
];