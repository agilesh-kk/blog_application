import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/image_picker_service.dart';
import 'package:blog_app/core/utils/modal_bottom_sheet.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewBlogPage extends StatefulWidget {
  static const String pageName = '/add-new-blog';
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopic = [];

  XFile? _pickedImage;
  final _imagePickerService = ImagePickerService();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  //function that calls modalbottomsheet class
  void _showImageSourceBottomSheet() async {
    final result = await ModalBottomSheet.show<String>(
      context,
      title: "Select Image Source",
      options: [
        BottomSheetOption(
          value: 'camera',
          label: 'Camera',
          icon: Icons.camera_alt,
        ),
        BottomSheetOption(
          value: 'gallery',
          label: 'Gallery',
          icon: Icons.photo_library,
        ),
      ],
    );

    if (result == 'camera') {
      final image = await _imagePickerService.pickFromCamera();
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } else if (result == 'gallery') {
      final image = await _imagePickerService.pickFromGallery();
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _showImageSourceBottomSheet,
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: const Radius.circular(8),
                    strokeWidth: 2,
                    color: AppPallete.borderColor,
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    padding: const EdgeInsets.all(8),
                  ),

                  //place to add the image from the internal storage.
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    child:
                        _pickedImage == null
                            ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open_rounded, size: 40),
                                SizedBox(height: 15),
                                Text(
                                  "Select your Image",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //the contents from the list are iterated and assigned to the chip text.
                  children:
                      ['Technology', 'Business', 'Programming', 'Entertainment']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopic.contains(e)) {
                                    selectedTopic.remove(e);
                                  } else {
                                    selectedTopic.add(
                                      e,
                                    ); //appends the topics which are clicked.
                                  }
                                  setState(() {});
                                  //print(selectedTopic);
                                },
                                child: Chip(
                                  label: Text(e),
                                  //the selected topics are hightlighted with the gradient color.
                                  color:
                                      selectedTopic.contains(e)
                                          ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                          : null,
                                  side:
                                      selectedTopic.contains(e)
                                          ? null
                                          : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),

              SizedBox(height: 20),

              //creating the text field to add the title for the blog
              BlogEditor(controller: titleController, hintText: 'Blog title'),

              SizedBox(height: 20),

              //creating the text field to add the contents for the blog
              BlogEditor(
                controller: contentController,
                hintText: 'Blog Content',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
