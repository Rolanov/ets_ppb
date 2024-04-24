import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../db/db.dart';
import '../model/book.dart';
import '../page/edit_book_page.dart';
import '../page/book_detail_page.dart';
import '../widget/book_card_widget.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late List<Book> books;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshBooks();
  }

  @override
  void dispose() {
    BooksDatabase.instance.close();

    super.dispose();
  }

  Future refreshBooks() async {
    setState(() => isLoading = true);

    try {
      books = await BooksDatabase.instance.readAllBooks();
    } catch (e) {
      // Handle the error, e.g., show a snackbar or display an error message
      print('Error loading books: $e');
      // Optionally, you can rethrow the error to propagate it further
      // throw e;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Books',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
      actions: const [
        Icon(Icons.search, color: Colors.white),
        SizedBox(width: 12)
      ],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : books.isEmpty
          ? const Text(
        'No Books',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildBooks(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditBookPage()),
        );

        refreshBooks();
      },
    ),
  );

  Widget buildBooks() => GridView.count(
    crossAxisCount: 3,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: List.generate(
      books.length,
          (index) {
        final book = books[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookDetailPage(bookId: book.id!),
            ));

            refreshBooks();
          },
          child: BookCardWidget(book: book, index: index),
        );
      },
    ),
  );
}
