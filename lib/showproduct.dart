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
      home: showproduct(),
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class showproduct extends StatefulWidget {
  @override
  State<showproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproduct> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');

  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final snapshot = await dbRef.get(); // ดึงข้อมูลทั้งหมดจาก 'products'
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
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
        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  // ฟังก์ชันที่ใช้ลบสินค้า
  void deleteProduct(String key, BuildContext context) {
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      // รีเฟรชข้อมูลสินค้าใหม่หลังจากลบสำเร็จ
      fetchProducts(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลใหม่เพื่อแสดงผลหลังการแก้ไขเช่น fetchProducts
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
            // ปุ่มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
            // ปุ่มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    TextEditingController productionDateController =
        TextEditingController(text: product['productionDate']);

    List<String> categories = ['Electronic', 'Clothing', 'Food' , 'Books'];
    String selectedCategory = product['category'] ?? ''; // ถ้าไม่มีค่าใช้ค่าว่าง

    // ถ้าค่า selectedCategory ไม่มีใน categories ให้ใช้ค่าเริ่มต้น
    if (!categories.contains(selectedCategory)) {
      selectedCategory = categories.isNotEmpty ? categories.first : '';
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        productionDateController.text = "${picked.toLocal()}".split(' ')[0];
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory.isNotEmpty ? selectedCategory : null, // ใช้ null ถ้าไม่มีค่า
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                  items: categories.toSet().toList().map((String category) { // ป้องกันค่าซ้ำ
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(dialogContext);
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: productionDateController,
                      decoration: InputDecoration(labelText: 'วันที่ผลิต'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // ตรวจสอบว่า Key ไม่เป็น null ก่อนอัปเดต
                if (product['key'] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ไม่พบ key ของสินค้า')),
                  );
                  return;
                }

                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.tryParse(priceController.text) ?? 0,
                  'category': selectedCategory,
                  'quantity': int.tryParse(quantityController.text) ?? 0,
                  'productionDate': productionDateController.text,
                };

                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  setState(() {}); // รีเฟรช UI
                  fetchProducts(); // โหลดข้อมูลใหม่
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });

                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงข้อมูลสินค้า'),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade100, Colors.amber.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จำนวนคอลัมน์
                  crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
                  childAspectRatio: 0.8, // สัดส่วนของแต่ละไอเท็ม
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 6.0, // เพิ่มเงาให้กับ Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // มุมโค้งมน
                    ),
                    color: Colors.white, // สีพื้นหลังของ Card
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'รายละเอียด: ${product['description']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'วันที่ผลิต: ${formatDate(product['productionDate'])}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'ราคา : ${product['price']} บาท',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red[10], // พื้นหลังสีแดงอ่อน
                                shape: BoxShape.circle, // รูปทรงวงกลม
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // เรียกฟังก์ชัน showDeleteConfirmationDialog
                                  // โดยส่งค่า Primary key เข้าไป
                                  showDeleteConfirmationDialog(
                                      product['key'], context);
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red, // สีของไอคอน
                                iconSize: 20,
                                tooltip: 'ลบสินค้า',
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red[10], // พื้นหลังสีแดงอ่อน
                                shape: BoxShape.circle, // รูปทรงวงกลม
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // เรียกฟังก์ชัน showDeleteConfirmationDialog
                                  // โดยส่งค่า Primary key เข้าไป
                                  showEditProductDialog(product);
                                },
                                icon: Icon(Icons.edit),
                                color: const Color.fromARGB(
                                    255, 95, 255, 80), // สีของไอคอน
                                iconSize: 20,
                                tooltip: 'แก้ไข',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
