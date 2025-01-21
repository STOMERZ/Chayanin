import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlineapp_chayanin/main.dart';
import 'showproduct.dart';

// Method หลักที่รัน
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: Main(), // หน้าหลักที่เชื่อมโยงไปยัง AddProduct
    );
  }
}

// Class Stateless ที่เป็น root ของแอปพลิเคชัน
class AddProductApp extends StatelessWidget {
  const AddProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: addproduct(),
    );
  }
}

// Class Stateful สำหรับหน้าจอการเพิ่มสินค้า
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _AddProductState();
}

class _AddProductState extends State<addproduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;
  DateTime? productionDate;

  // ฟังก์ชันสำหรับเลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> saveProductToDatabase() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // สร้าง reference ไปยัง Firebase Realtime Database
        DatabaseReference dbRef =
            FirebaseDatabase.instance.ref('products');

        // ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
        Map<String, dynamic> productData = {
          'name': nameController.text,
          'description': desController.text,
          'category': selectedCategory,
          'productionDate': productionDate?.toIso8601String(),
          'price':
              double.tryParse(priceController.text) ?? 0.0, // แปลงเป็น double
          'quantity':
              int.tryParse(quantityController.text) ?? 0, // แปลงเป็น int
        };

        // ใช้คำสั่ง push() เพื่อสร้าง key อัตโนมัติสำหรับสินค้าใหม่
        await dbRef.push().set(productData);

        // แจ้งเตือนเมื่อบันทึกสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => showproduct(), //ชื่อหน้าจอที่ต้องการเปิด
          ),
        );

        // รีเซ็ตฟอร์ม
        _formKey.currentState?.reset();
        nameController.clear();
        desController.clear();
        priceController.clear();
        quantityController.clear();
        dateController.clear();
        setState(() {
          selectedCategory = null;
          productionDate = null;
        });
      } catch (e) {
        // แจ้งเตือนเมื่อเกิดข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  // ส่วนออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกข้อมูลสินค้า'),
        backgroundColor: Colors.amber.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding รอบหน้าจอทั้งหมด
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.amber.shade800,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.amber.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อสินค้า';
                      }
                      return null;
                    },
                  ),
                ),

                // รายละเอียดสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller: desController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียดสินค้า',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.amber.shade800,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.amber.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรายละเอียด';
                      }
                      return null;
                    },
                  ),
                ),

                // เลือกประเภทสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'ประเภทสินค้า',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.amber.shade800,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.amber.shade50,
                    ),
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกประเภทสินค้า';
                      }
                      return null;
                    },
                  ),
                ),

                // ราคาสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'ราคาสินค้า',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.amber.shade800,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.amber.shade50,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกราคาสินค้า';
                      }
                      if (double.tryParse(value) == null) {
                        return 'กรุณากรอกค่าราคาที่เป็นตัวเลข';
                      }
                      return null;
                    },
                  ),
                ),

                // จำนวนสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: 'จำนวนสินค้า',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.amber.shade800,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.amber.shade50,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกจำนวนสินค้า';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกจำนวนที่เป็นตัวเลข';
                      }
                      return null;
                    },
                  ),
                ),

                // วันที่ผลิตสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'วันที่ผลิตสินค้า',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.amber.shade800,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.amber.shade50,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => pickProductionDate(context),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกวันที่ผลิต';
                      }
                      return null;
                    },
                  ),
                ),

                // ปุ่มบันทึกสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          saveProductToDatabase();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('บันทึกสินค้า'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
