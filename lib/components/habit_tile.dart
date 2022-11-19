// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(BuildContext)? settingTapped;

  final Function(BuildContext)? deleteTapped;

  //function for on tap
  final Function(bool?)? onChanged;
  const HabitTile({
    Key? key,
    required this.habitName,
    required this.habitCompleted,
    required this.settingTapped,
    required this.deleteTapped,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              //setting Opetions
              SlidableAction(
                onPressed: settingTapped,
                backgroundColor: Colors.grey.shade600,
                icon: Icons.settings,
                borderRadius: BorderRadius.circular(20),
              ),

              //delete option
              SlidableAction(
                onPressed: deleteTapped,
                backgroundColor: Colors.red,
                icon: Icons.delete_forever_rounded,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //check box
                  Checkbox(value: habitCompleted, onChanged: onChanged),
                  Text(
                    habitName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
