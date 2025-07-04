import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; // Tambahkan ini
import 'profile_screen.dart'; // Tambahkan ini di bagian import
import 'notifications_screen.dart'; // Tambahkan di bagian import
import '../services/api_service.dart'; // Import ApiService

// Bagian 1: Definisi Tema Aplikasi
// Variabel warna dan gaya teks yang diambil dari CSS.
class AppTheme {
  static const Color primaryColor = Color(0xFF1672CE);
  static const Color secondaryColor = Color(0xFFE7EDF3);
  static const Color accentColor = Color(0xFF4E7397);
  static const Color textPrimary = Color(0xFF0E141B);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFF8FAFC); // Tidak terpakai di UI ini
}

// Bagian 2: Widget Utama Halaman
class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _readTimeController = TextEditingController(text: '5 menit');
  final TextEditingController _tagsController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  final List<String> _categories = [
    'Technology',
    'Business',
    'Health',
    'General',
    'Sports',
    'Science',
    'Entertainment'
  ];

  void handleCreateArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Tags dipisah koma, lalu di-trim
    List<String> tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final data = {
      "title": _titleController.text.trim(),
      "category": _selectedCategory!,
      "readTime": _readTimeController.text.trim(),
      "imageUrl": _imageUrlController.text.trim(),
      "tags": tags,
      "content": _contentController.text.trim(),
    };

    final result = await ApiService.createArticle(data);

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil dibuat!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal membuat artikel')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              const Text('Title', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  filled: true,
                  fillColor: Color(0xFFE7EDF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // Read Time
              const Text('Read Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _readTimeController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter read time (e.g. 5 menit)',
                  filled: true,
                  fillColor: Color(0xFFE7EDF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Waktu baca wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // Image URL
              const Text('Image URL', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter image URL',
                  filled: true,
                  fillColor: Color(0xFFE7EDF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'URL gambar wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // Category
              const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: InputDecoration(
                  hintText: 'Select category',
                  filled: true,
                  fillColor: Color(0xFFE7EDF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 20),

              // Tags
              const Text('Tags', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tagsController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter tags separated by comma',
                  filled: true,
                  fillColor: Color(0xFFE7EDF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Content
              const Text('Content', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                style: const TextStyle(fontSize: 16),
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Write your article content here...',
                  filled: true,
                  fillColor: Color(0xFFE7EDF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Isi artikel wajib diisi' : null,
              ),
              const SizedBox(height: 28),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      label: const Text('Preview'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFE7EDF3)),
                        backgroundColor: Color(0xFFF8FAFC),
                      ),
                      onPressed: () {
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_outlined),
                      label: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Create'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1672CE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onPressed: _isLoading ? null : handleCreateArticle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Method untuk membangun AppBar di bagian atas
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 1.0,
      // ignore: deprecated_member_use
      shadowColor: Colors.black.withOpacity(0.1),
      // Tombol 'close' di sebelah kiri
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppTheme.textPrimary),
        onPressed: () {
          // Aksi untuk menutup halaman, misalnya Navigator.pop(context)
        },
      ),
      title: Text(
        'New Article',
        style: GoogleFonts.notoSans(
          color: AppTheme.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Memastikan judul berada di tengah
      centerTitle: true,
    );
  }

  // Method untuk membangun Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.secondaryColor, width: 1.0)),
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Navigasi ke HomeScreen jika tombol Home ditekan
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
          // Navigasi ke CreateArticleScreen jika tombol Create ditekan
          else if (index == 2) {
            // Sudah di halaman ini, bisa kosong atau refresh
          }
          // Navigasi ke NotificationsScreen jika tombol Notifications ditekan
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          }
          // Navigasi ke ProfileScreen jika tombol Profile ditekan
          else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.backgroundColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.accentColor,
        selectedLabelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.w500, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// Bagian 3: Widget Kustom untuk Tombol Lampiran
// Widget ini dibuat agar kode grid tidak berulang.
class AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const AttachmentButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      onPressed: () {
        // Aksi ketika tombol ditekan
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.notoSans(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}