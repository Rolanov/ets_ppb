// import 'package:flutter/material.dart';
//
// class BookFormWidget extends StatelessWidget {
//   final bool? isImportant;
//   final int? number;
//   final String? title;
//   final String? description;
//   final ValueChanged<bool> onChangedImportant;
//   final ValueChanged<int> onChangedNumber;
//   final ValueChanged<String> onChangedTitle;
//   final ValueChanged<String> onChangedDescription;
//
//   const BookFormWidget({
//     Key? key,
//     this.isImportant = false,
//     this.number = 0,
//     this.title = '',
//     this.description = '',
//     required this.onChangedTitle,
//     required this.onChangedDescription,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Switch(
//                 value: isImportant ?? false,
//                 onChanged: onChangedImportant,
//               ),
//               Expanded(
//                 child: Slider(
//                   value: (number ?? 0).toDouble(),
//                   min: 0,
//                   max: 5,
//                   divisions: 5,
//                   onChanged: (number) => onChangedNumber(number.toInt()),
//                 ),
//               )
//             ],
//           ),
//           buildTitle(),
//           const SizedBox(height: 8),
//           buildDescription(),
//           const SizedBox(height: 16),
//         ],
//       ),
//     ),
//   );
//
//   Widget buildTitle() => TextFormField(
//     maxLines: 1,
//     initialValue: title,
//     style: const TextStyle(
//       color: Colors.white70,
//       fontWeight: FontWeight.bold,
//       fontSize: 24,
//     ),
//     decoration: const InputDecoration(
//       border: InputBorder.none,
//       hintText: 'Title',
//       hintStyle: TextStyle(color: Colors.white70),
//     ),
//     validator: (title) =>
//     title != null && title.isEmpty ? 'The title cannot be empty' : null,
//     onChanged: onChangedTitle,
//   );
//
//   Widget buildDescription() => TextFormField(
//     maxLines: 5,
//     initialValue: description,
//     style: const TextStyle(color: Colors.white60, fontSize: 18),
//     decoration: const InputDecoration(
//       border: InputBorder.none,
//       hintText: 'Type something...',
//       hintStyle: TextStyle(color: Colors.white60),
//     ),
//     validator: (title) => title != null && title.isEmpty
//         ? 'The description cannot be empty'
//         : null,
//     onChanged: onChangedDescription,
//   );
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookFormWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? imagePath;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<String> onChangedImagePath;
  final VoidCallback onImagePickerClicked;

  const BookFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    this.imagePath,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangedImagePath,
    required this.onImagePickerClicked,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(),
          const SizedBox(height: 8),
          buildDescription(),
          const SizedBox(height: 8),
          buildImagePreview(),
          const SizedBox(height: 8),
          buildImagePickerButton(),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: title,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: onChangedTitle,
  );

  Widget buildDescription() => TextFormField(
    maxLines: 5,
    initialValue: description,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'The description cannot be empty' : null,
    onChanged: onChangedDescription,
  );

  Widget buildImagePreview() => imagePath != null
      ? Image.file(
    File(imagePath!),
    width: double.infinity,
    height: 200,
    fit: BoxFit.cover,
  )
      : Container();

  Widget buildImagePickerButton() => ElevatedButton(
    onPressed: onImagePickerClicked,
    child: const Text('Pick Image'),
    // const SizedBox(height: 20,),
    // _selectedImage != null ? Image.file(_selectedImage!)
  );

  Future _pickImageFromGallery() async{
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
