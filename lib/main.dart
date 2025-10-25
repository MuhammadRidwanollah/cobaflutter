import 'package:flutter/material.dart';

// =======================================================
// MODEL DATA SEDERHANA
// =======================================================

/// Model untuk merepresentasikan data Siswa.
class Student {
  final int nis;
  final String name;
  const Student(this.nis, this.name);
}

/// Model untuk merepresentasikan Jadwal Kelas.
class ClassSchedule {
  final String className;
  final String subject;
  final String time;
  const ClassSchedule(this.className, this.subject, this.time);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Absensi Siswa Guru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// =======================================================
// 1. HALAMAN LOGIN (OTENTIKASI GURU)
// =======================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller harus berada di State sehingga bisa di-dispose.
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    // Simulasi logika login sukses
    if (_nipController.text.trim().isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil! Selamat datang.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan NIP dan Kata Sandi Anda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'APLIKASI ABSENSI SISWA',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 50),
              
              const Icon(Icons.qr_code_scanner, size: 100, color: Colors.blue),
              const SizedBox(height: 50),

              TextField(
                controller: _nipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIP / Username Guru',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Sandi',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: () => _handleLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  'MASUK',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Halaman Lupa Kata Sandi...')));
                },
                child: const Text('Lupa Kata Sandi?', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// 2. HALAMAN BERANDA (JADWAL GURU)
// =======================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Data dummy jadwal hari ini (const karena konstruktor ClassSchedule const)
  final List<ClassSchedule> todaySchedule = const [
    ClassSchedule('VII', 'Matematika', '07:00 - 08:30'),
    ClassSchedule('VIII', 'Bahasa Inggris', '08:30 - 10:00'),
    ClassSchedule('IX', 'Seni Budaya', '10:30 - 12:00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Absensi Hari Ini'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka halaman Riwayat/Rekap...')));
            },
            tooltip: 'Riwayat Absensi',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            tooltip: 'Keluar (Logout)',
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person, color: Colors.white)),
                title: Text('Selamat Datang, Guru A!', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Tanggal: 24 Oktober 2025'),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Pilih Kelas untuk Absensi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: todaySchedule.length,
              itemBuilder: (context, index) {
                final schedule = todaySchedule[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.class_, color: Colors.blue, size: 30),
                    title: Text('${schedule.className} - ${schedule.subject}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Jam Pelajaran: ${schedule.time}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceScreen(schedule: schedule),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('ABSEN', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// 3. HALAMAN PENCATATAN ABSENSI SISWA
// =======================================================
class AttendanceScreen extends StatefulWidget {
  final ClassSchedule schedule;
  const AttendanceScreen({super.key, required this.schedule});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Data dummy siswa (const Student)
  final List<Student> students = const [
    Student(1001, 'Ani Mardiana'),
    Student(1002, 'Budi Santoso'),
    Student(1003, 'Citra Dewi'),
    Student(1004, 'Dian Kusuma'),
    Student(1005, 'Eko Pranoto'),
    Student(1006, 'Fatimah Az Zahra'),
    Student(1007, 'Gilang Ramadhan'),
    Student(1008, 'Hera Lestari'),
    Student(1009, 'Indra Permana'),
    Student(1010, 'Joko Susilo'),
  ];

  late Map<int, String> attendanceStatus;

  @override
  void initState() {
    super.initState();
    attendanceStatus = {
      for (var s in students) s.nis : 'H'
    };
  }

  void _updateStatus(int nis, String status) {
    setState(() {
      attendanceStatus[nis] = status;
    });
  }

  void _submitAttendance() {
    int totalAlpa = attendanceStatus.values.where((s) => s == 'A').length;
    int totalHadir = attendanceStatus.values.where((s) => s == 'H').length;
    int totalIzin = attendanceStatus.values.where((s) => s == 'I').length;
    int totalSakit = attendanceStatus.values.where((s) => s == 'S').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Konfirmasi Absensi'),
        content: Text(
          'Kelas: ${widget.schedule.className} \nMapel: ${widget.schedule.subject} \n\nRekap Sementara:\n• Hadir: $totalHadir\n• Sakit: $totalSakit\n• Izin: $totalIzin\n• Alpa: $totalAlpa\n\nApakah Anda yakin ingin menyimpan data ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: POST data ke backend
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Absensi Berhasil Disimpan!')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String label, String tooltip, Color color, String currentStatus, int nis) {
    bool isSelected = currentStatus == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () => _updateStatus(nis, label),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? Border.all(color: Colors.black54, width: 2) : null,
              boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)] : null,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatatan Absensi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.schedule.className, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(widget.schedule.subject, style: const TextStyle(color: Colors.black87)),
                  Text('Jam Pelajaran: ${widget.schedule.time}', style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final status = attendanceStatus[student.nis] ?? 'H';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade800,
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('NIS: ${student.nis}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusButton('H', 'Hadir', Colors.green, status, student.nis),
                        _buildStatusButton('S', 'Sakit', Colors.orange, status, student.nis),
                        _buildStatusButton('I', 'Izin', Colors.blue, status, student.nis),
                        _buildStatusButton('A', 'Alpa', Colors.red, status, student.nis),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _submitAttendance,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'SIMPAN ABSENSI',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
