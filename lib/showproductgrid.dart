import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 
// Method หลักที่ Run
void main() {
  runApp(MyApp());
}
 
// Class stateless
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: ShowProduct(),
    );
  }
}
 
// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class ShowProduct extends StatefulWidget {
  @override
  State<ShowProduct> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<ShowProduct> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
 
  List<Map<String, dynamic>> products = [];
 
  Future<void> fetchProducts() async {
    try {
      // ลบการกรองข้อมูลตาม 'category' ที่เป็น 'Food'
      final snapshot = await dbRef.get();  // ดึงข้อมูลทั้งหมดจาก 'products'
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สำหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
 
        // เรียงสินค้าตามราคา (จากมากไปหาน้อย)
        loadedProducts.sort((a, b) => b['price'].compareTo(a['price']));
 
        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
      // แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }
 
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }
 
  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }
 
  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงข้อมูลสินค้า'),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // จำนวนคอลัมน์
                crossAxisSpacing: 5, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 5, // ระยะห่างระหว่างแถว
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(7.0),
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Column(
                      children: [
                        Text('รายละเอียดสินค้า: ${product['description']}'),
                        Text(
                            'วันที่ผลิตสินค้า: ${formatDate(product['productionDate'])}')
                      ],
                    ),
                    trailing: Text('ราคา : ${product['price']} บาท'),
                    onTap: () {
                      //เมื่อกดที่แต่ละรายการจะเกิดอะไรขึ้น
                    },
                  ),
                );
              },
            ),
    );
  }
}