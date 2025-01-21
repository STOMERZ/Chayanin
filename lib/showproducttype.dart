import 'package:flutter/material.dart';
import 'showfiltertype.dart';
 
class showproducttype extends StatelessWidget {
  const showproducttype({super.key});
 
  // รายการประเภทสินค้า (สามารถเปลี่ยนแปลงได้ตามต้องการ)
  final List<Map<String, String>> productTypes = const [
    {'name': 'Electronics', 'icon': 'devices'},
    {'name': 'Clothing', 'icon': 'shirt'},
    {'name': 'Food', 'icon': 'restaurant'},
    {'name': 'Books', 'icon': 'book'},
  ];
 
  // ฟังก์ชันเพื่อเลือกไอคอนจากชื่อ
  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'devices':
        return Icons.computer;
      case 'shirt':
        return Icons.checkroom_sharp;
      case 'restaurant':
        return Icons.food_bank;
      case 'book':
        return Icons.menu_book;
      default:
        return Icons.help; // กรณีไม่มี icon ที่ตรง
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประเภทสินค้า'),
        backgroundColor: const Color.fromARGB(255, 255, 238, 0), // กำหนดสีของ AppBar
        elevation: 6.0, // เพิ่มเงาให้กับ AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // แสดง 2 คอลัมน์
            crossAxisSpacing: 10.0, // เพิ่มระยะห่างระหว่างคอลัมน์
            mainAxisSpacing: 10.0, // เพิ่มระยะห่างระหว่างแถว
            childAspectRatio: 1.2, // ปรับสัดส่วนของ Grid แต่ละอัน
          ),
          itemCount: productTypes.length,
          itemBuilder: (context, index) {
            final type = productTypes[index];
            return GestureDetector(
              onTap: () {
                // เมื่อกดประเภทสินค้า จะไปที่หน้า ShowFilterType และส่ง category ไป
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        showfiltertype(category: type['name'] ?? ''),
                  ),
                );
              },
              child: Card(
                elevation: 8.0, // เพิ่มระดับของเงาให้กับการ์ด
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // ขอบการ์ดโค้งมน
                ),
                color: Colors.orange.shade100, // กำหนดสีพื้นหลังของการ์ด
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // เพิ่มระยะห่างภายในการ์ด
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        getIcon(type['icon'] ?? 'home'), // ใช้ฟังก์ชัน getIcon
                        size: 50, // ขยายขนาดไอคอน
                        color: const Color.fromARGB(255, 255, 145, 0), // สีไอคอน
                      ),
                      const SizedBox(height: 12.0), // ระยะห่างระหว่างไอคอนและชื่อ
                      Text(
                        type['name'] ?? 'ไม่มีชื่อ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // ขนาดฟอนต์ที่ใหญ่ขึ้น
                          color: Colors.black87, // สีฟอนต์ที่เข้มขึ้น
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
