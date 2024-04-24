import 'dart:io'; // Add this import for File class
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db.dart';
import '../model/book.dart';
import '../page/edit_book_page.dart';

class BookDetailPage extends StatefulWidget {
  final int bookId;

  const BookDetailPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Book book;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshBook();
  }

  Future refreshBook() async {
    setState(() => isLoading = true);

    book = await BooksDatabase.instance.readBook(widget.bookId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            book.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            DateFormat.yMMMd().format(book.createdTime),
            style: TextStyle(color: Colors.white38),
          ),
          SizedBox(height: 8),
          // Display image preview
          book.image.isNotEmpty
              ? Image.file(File(book.image))
              : Container(),
          SizedBox(height: 8),
          Text(
            book.description,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
    icon: Icon(Icons.edit_outlined, color: Colors.white),
    onPressed: () async {
      if (isLoading) return;

      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditBookPage(book: book),
      ));

      refreshBook();
    },
  );

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete, color: Colors.white),
    onPressed: () async {
      await BooksDatabase.instance.delete(widget.bookId);

      Navigator.of(context).pop();
    },
  );
}
