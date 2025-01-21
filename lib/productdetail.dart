import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // นำเข้า intl สำหรับการแปลงวันที่
 
class productdetail extends StatelessWidget {
  final Map<String, dynamic> product;
 
  const productdetail({required this.product, Key? key}) : super(key: key);
 
  // ฟังก์ชั่นแปลงวันที่
  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date); // แปลงจาก string เป็น DateTime
      return DateFormat('dd MMMM yyyy').format(parsedDate); // เปลี่ยนรูปแบบวันที่
    } catch (e) {
      return 'ไม่ทราบวันที่'; // หากวันที่ไม่ถูกต้องหรือไม่มีการแปลง
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'รายละเอียดสินค้า'),
        backgroundColor: Colors.deepOrange, // เพิ่มสีให้ AppBar
        elevation: 5.0, // เพิ่มเงาให้ AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4.0, // เพิ่มเงาให้การ์ด
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // ทำให้มุมการ์ดโค้งมน
                ),
                color: Colors.orange.shade50, // กำหนดสีพื้นหลังของการ์ด
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อสินค้า: ${product['name'] ?? 'ไม่ทราบชื่อ'}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange, // ใช้สีที่ตรงกับ AppBar
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'รายละเอียดสินค้า: ${product['description'] ?? 'ไม่มีรายละเอียด'}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ราคา: ${product['price'] ?? 'ไม่ทราบราคา'} บาท',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'จำนวนสินค้า: ${product['quantity'] ?? 'ไม่ทราบจำนวน'}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วันที่ผลิต: ${formatDate(product['productionDate'] ?? 'ไม่ทราบวันที่')}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
