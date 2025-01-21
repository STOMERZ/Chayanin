import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlineapp_chayanin/showproduct.dart';
import 'package:onlineapp_chayanin/showproducttype.dart';
import 'addproduct.dart';

// Method หลักที่รัน
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ตรวจสอบว่าใช้งานใน Web หรือไม่
  if (kIsWeb) {
    // ในกรณีนี้กำหนดค่า Firebase สำหรับ Web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD1TkT00_ZGduEG3JJkjF10B_nxaWXsEbU",
        authDomain: "rmutt-secb-3f0cb.firebaseapp.com",
        databaseURL: "https://rmutt-secb-3f0cb-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "rmutt-secb-3f0cb",
        storageBucket: "rmutt-secb-3f0cb.firebasestorage.app",
        messagingSenderId: "1060841207883",
        appId: "1:1060841207883:web:58035aa5206726ef0635ce",
        measurementId: "G-SPZEBY58Z0"
      ),
    );
  } else {
    // สำหรับ Platform อื่นๆ เช่น Android หรือ iOS
    await Firebase.initializeApp();
  }

  runApp(MyApp()); // เรียกใช้งาน MyApp ที่เป็น Root Widget
}

// Class stateless สั่งแสดงผลหน้าจอ
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
      home: Main(), // หน้าหลักที่เชื่อมโยงไปยัง AddProduct
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เมนูหลัก',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.amber, // AppBar สีพื้นหลัง
      ),
      body: Container(
        // Adding background gradient to the whole body
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade100, Colors.amber.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // Center the content vertically and horizontally
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, 
              children: [
                Image.asset(
                  'assets/bacon.png',
                  width: 300, // แทนที่ URL นี้ด้วย URL ของภาพที่ต้องการใช้
                  height: 300, 
                ),
                SizedBox(height: 40), // Add space below the logo

                _buildCustomButton(
                  context,
                  label: 'จัดการข้อมูลสินค้า',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => addproduct(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildCustomButton(
                  context,
                  label: 'แสดงข้อมูลสินค้า',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showproduct(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildCustomButton(
                  context,
                  label: 'ประเภทสินค้า',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showproducttype(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom ElevatedButton with improved design
  Widget _buildCustomButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber.shade700, // Text color
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
