
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const BookManagementApp());
}

// ================= BOOK MODEL =================

class Book {
  final String name;
  final String author;
  final double price;
  final String category;
  final String description;

  const Book({
    required this.name,
    required this.author,
    required this.price,
    required this.category,
    required this.description,
  });
}

// ================= MAIN APP =================

class BookManagementApp extends StatelessWidget {
  const BookManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ================= SPLASH SCREEN =================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.menu_book_rounded,
                size: 75,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'BOOK MANAGEMENT',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your Personal Digital Library',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 35),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= MAIN SCREEN =================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Book> books = [];

  void addBook(Book book) {
    setState(() {
      books.add(book);
      selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        bookCount: books.length,
        onAddBook: () {
          setState(() {
            selectedIndex = 1;
          });
        },
        onViewBooks: () {
          setState(() {
            selectedIndex = 2;
          });
        },
      ),
      BookFormScreen(
        onSubmit: addBook,
      ),
      BookGridScreen(
        books: books,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Management App'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Book Form',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Book Grid',
          ),
        ],
      ),
    );
  }
}

// ================= HOME SCREEN =================

class HomeScreen extends StatelessWidget {
  final int bookCount;
  final VoidCallback onAddBook;
  final VoidCallback onViewBooks;

  const HomeScreen({
    super.key,
    required this.bookCount,
    required this.onAddBook,
    required this.onViewBooks,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Icon(
            Icons.local_library_rounded,
            size: 110,
            color: Colors.indigo,
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to Your Library!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add, organize, and explore your favorite books.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),

          Card(
            elevation: 3,
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.menu_book),
              ),
              title: const Text('Total Books'),
              subtitle: Text('$bookCount books in your library'),
              trailing: Text(
                '$bookCount',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddBook,
              icon: const Icon(Icons.add),
              label: const Text('Add New Book'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewBooks,
              icon: const Icon(Icons.grid_view),
              label: const Text('View All Books'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= BOOK FORM SCREEN =================

class BookFormScreen extends StatefulWidget {
  final Function(Book) onSubmit;

  const BookFormScreen({
    super.key,
    required this.onSubmit,
  });

  @override
  State<BookFormScreen> createState() =>
      _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController authorController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  String category = 'Education';

  final List<String> categories = [
    'Education',
    'Fiction',
    'Science',
    'Technology',
    'History',
    'Biography',
    'Other',
  ];

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final Book book = Book(
      name: nameController.text.trim(),
      author: authorController.text.trim(),
      price: double.parse(priceController.text.trim()),
      category: category,
      description: descriptionController.text.trim(),
    );

    widget.onSubmit(book);

    nameController.clear();
    authorController.clear();
    priceController.clear();
    descriptionController.clear();

    setState(() {
      category = 'Education';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Book',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the book information below.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),

            // Book Name
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Book Name',
                hintText: 'Enter book name',
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book name';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            // Author Name
            TextFormField(
              controller: authorController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Author Name',
                hintText: 'Enter author name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter author name';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            // Price
            TextFormField(
              controller: priceController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Book Price',
                hintText: 'Enter price',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final double? price =
                double.tryParse(value?.trim() ?? '');

                if (price == null || !price.isFinite || price <= 0) {
                  return 'Enter a valid price greater than zero';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            // Category
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: 'Book Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: categories.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            // Description
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Book Description',
                hintText: 'Enter book description',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book description';
                }
                return null;
              },
            ),

            const SizedBox(height: 25),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Submit Book'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= BOOK GRID SCREEN =================

class BookGridScreen extends StatelessWidget {
  final List<Book> books;

  const BookGridScreen({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.library_books_outlined,
                size: 90,
                color: Colors.grey,
              ),
              SizedBox(height: 15),
              Text(
                'No Books Available',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add books using the Book Form tab.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: books.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        final Book book = books[index];

        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      BookDetailsScreen(book: book),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 65,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    book.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'By ${book.author}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₹${book.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      book.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.indigo,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================= BOOK DETAILS CARD VIEW =================

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.indigo.shade50,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 65,
                      color: Colors.indigo,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Center(
                  child: Text(
                    book.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'By ${book.author}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const Divider(height: 35),

                detailRow('Book Name', book.name),
                detailRow('Author', book.author),
                detailRow(
                  'Price',
                  '₹${book.price.toStringAsFixed(2)}',
                ),
                detailRow('Category', book.category),

                const SizedBox(height: 15),

                const Text(
                  'Book Description',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  book.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Book Grid'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
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
