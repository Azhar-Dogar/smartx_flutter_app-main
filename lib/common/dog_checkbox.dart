import 'package:flutter/material.dart';

import '../models/dog_model.dart';
import 'margin_widget.dart';

class DogCheckBox extends StatefulWidget {
  DogCheckBox(
      {super.key,
      required this.check,
      required this.onChanged,
      required this.model});
  bool check;
  DogModel model;
  void Function(bool?) onChanged;
  @override
  State<DogCheckBox> createState() => _DogCheckBoxState();
}

class _DogCheckBoxState extends State<DogCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(widget.model.imagePath ??
              "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*"),
        ),
        const MarginWidget(
          factor: 1,
          isHorizontal: true,
        ),
        Expanded(child: Text(widget.model.name)),
        Checkbox(value: widget.check, onChanged: widget.onChanged)
      ],
    );
  }
}
