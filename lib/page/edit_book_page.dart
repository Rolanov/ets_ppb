import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/db.dart';
import '../model/book.dart';
import '../widget/book_form_widget.dart';

class AddEditBookPage extends StatefulWidget {
  final Book? book;

  const AddEditBookPage({
    Key? key,
    this.book,
  }) : super(key: key);

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String? image;

  @override
  void initState() {
    super.initState();

    title = widget.book?.title ?? '';
    description = widget.book?.description ?? '';
    image = widget.book?.image;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: BookFormWidget(
        title: title,
        description: description,
        imagePath: image,
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
        onChangedImagePath: (path) => setState(() => this.image = path),
        onImagePickerClicked: pickImage,
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateBook,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateBook() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.book != null;

      if (isUpdating) {
        await updateBook();
      } else {
        await addBook();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateBook() async {
    final book = widget.book!.copy(
      title: title,
      description: description,
      image: image ?? '',
    );

    await BooksDatabase.instance.update(book);
  }

  Future addBook() async {
    final book = Book(
      title: title,
      description: description,
      image: image ?? '',
      createdTime: DateTime.now(),
    );

    await BooksDatabase.instance.create(book);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = pickedImage.path;
      });
    }
  }
}
