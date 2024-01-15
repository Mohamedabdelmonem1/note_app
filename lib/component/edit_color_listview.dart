import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';
import '../constants.dart';
import 'custom_color_item.dart';

class EditColorListView extends StatefulWidget {
  const EditColorListView({super.key, required this.noteModel});

  final NoteModel noteModel;

  @override
  State<EditColorListView> createState() => _EditColorListViewState();
}

class _EditColorListViewState extends State<EditColorListView> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = kColors.indexOf(Color(widget.noteModel.color));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: kColors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                  widget.noteModel.color = kColors[index].value;
                });
              },
              child: ColorItem(
                color: kColors[index],
                isActive: currentIndex == index,
              ),
            ),
          );
        },
      ),
    );
  }
}
