import 'package:flutter/material.dart';
import 'package:habit_tracker/components/month_summery.dart';
import 'package:habit_tracker/habit/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/habit_tile.dart';
import '../components/my_alert_box.dart';
import '../components/my_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  @override
  void initState() {
    //if there is no current habit list,then it is the time ever opening  the app
    //then crete default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    //there already exists data,this is not the first time
    else {
      db.loadData();
    }

    //update the database
    db.updateDatabase();
    super.initState();
  }
  //checkbox was tapped

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value;
      db.updateDatabase();
    });
  }

  //create a new habit
  final _newHabitNameController = TextEditingController();
  void creatNewHabit() {
    //show alert dialog for user to eneter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
          hintText: 'Enter New Habit Name..',
          hintStyle: const TextStyle(color: Colors.red),
        );
      },
    );
  }

  //save  new habit
  void saveNewHabit() {
    //add new habit to todays habit list
    setState(() {
      db.todayHabitList.add([_newHabitNameController.text, false]);
    });
    //clear previous saved txtfield
    _newHabitNameController.clear();
    //pop dialog box
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  //cancel new Habit
  void cancelDialogBox() {
    //clear previous saved txt
    _newHabitNameController.clear();
    //pop dialog box
    Navigator.of(context).pop();
  }

  //open habit setting to edit
  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitNameController,
            onSave: () => saveExistingHabit(index),
            onCancel: cancelDialogBox,
            hintText: 'Edit the habit',
            hintStyle: const TextStyle(color: Colors.yellow),
          );
        });
  }

//save existing habit with the new name of the habit
  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _newHabitNameController.text;
    });
    Navigator.pop(context);
    db.updateDatabase();
  }

  //delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: MyFloatingActionButton(onPressed: creatNewHabit),
        body: ListView(
          children: [
//monthly summary heat map
            MonthlySummary(
                datasets: db.heatMapDataSet,
                startDate: _myBox.get("START_DATE")),
            //list of habits
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todayHabitList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todayHabitList[index][0],
                    habitCompleted: db.todayHabitList[index][1],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                  );
                }),
          ],
        ));
  }
}
