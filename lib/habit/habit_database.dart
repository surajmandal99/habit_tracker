//reference our box

// ignore_for_file: unused_element

import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createDefaultData() {
    [
      ["Code New App", false],
      ["Learn Flutter", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

//load data if it already exists

  void loadData() {
    //if it's a nnew day,get habit list from database
    //if it's not a new day,load todays list
    if (_myBox.get(todaysDateFormatted()) == null) {
      todayHabitList = _myBox.get("CURRENT_HABIT_LIST");

      //SET ALL HABIT COMPLETED TO FALSE IF IT'S A NEW DAY
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[i][1] = false;
      }
    }
    //if it's not a new day, load todays data
    else {
      todayHabitList = _myBox.get(todaysDateFormatted());
    }
  }

//update database

  void updateDatabase() {
    //update today entry
    _myBox.put(todaysDateFormatted(), todayHabitList);

    //update universal habit list in case it change(new habit,edit habit,delete habit)

    _myBox.put("CURRENT_HABIT_LIST", todayHabitList);

    //CALCULATE HABIT COMPLETE PERCENTAGES FOR EACH DAY

    // calculateHabitPercentages();
    //load heat map
    loadHeatMap();

    void calculateHabitPercentages() {
      int countCompleted = 0;
      for (int i = 0; i < todayHabitList.length; i++) {
        if (todayHabitList[i][1] == true) {
          countCompleted++;
        }
      }
      // ignore: unused_local_variable
      String percent = todayHabitList.isEmpty
          ? "0.0"
          : (countCompleted / todayHabitList.length).toStringAsFixed(1);
      //key:"PERCENTAGE-SUMMERY-YYMMDD"
      //VALUE:STRING OF 1DP NUMBER BETWEEN 0.0-1 INCLUSIVE
      _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
    }
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    //COUNT THE NUMBER OF DAYS TO LOAD
    // ignore: unused_local_variable
    int daysInBetween = DateTime.now().difference(startDate).inDays;
  }
}
