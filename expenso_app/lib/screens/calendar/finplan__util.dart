// ignore_for_file: constant_identifier_names
import 'package:expenso_app/db/services/finplan__DBInitializer.dart';
import 'package:logger/logger.dart';

class FinPlanCalendarUtil {
  
  // A function to get the list of tasks
  Future<Map<String, dynamic>> getFutureData({String? day}) async {
    day = (day != null) ? day.split(' ')[0] : DateTime.now().toString().split(' ')[0]; // 2024-04-17
    Map<String, List<Map<String, Object?>>> data =  {
      'data': [
        {'id': '100', 'name': 'Task 1', 'when': '2020-03-05 00:00:00Z', 'details': 'One Sample Task', 'priority': 1, 'allDay': false, 'recurring': false, 'completed': false},
        {'id': '200', 'name': 'Task 2', 'when': '2024-12-31 00:00:00Z', 'details': 'Two Sample Task', 'priority': 2, 'allDay': false, 'recurring': false, 'completed': false},
        {'id': '300', 'name': 'Task 3', 'when': '2013-11-04 00:00:00Z', 'details': '3rd Sample Task', 'priority': 3, 'allDay': false, 'recurring': false, 'completed': false},
        {'id': '400', 'name': 'Task 4', 'when': '2018-01-06 00:00:00Z', 'details': '4th Sample Task', 'priority': 1, 'allDay': false, 'recurring': false, 'completed': false},
        {'id': '500', 'name': 'Task 5', 'when': '2018-01-06 00:00:00Z', 'details': '5th Sample Task', 'priority': 1, 'allDay': false, 'recurring': false, 'completed': false},
        {'id': '600', 'name': 'Task 6', 'when': '2018-01-06 00:00:00Z', 'details': '6th Sample Task', 'priority': 1, 'allDay': false, 'recurring': false, 'completed': false},
      ]
    };

    await Future.delayed(const Duration(seconds: 1));

    final db = await DatabaseService.instance.database;

    List<Map<String, Object?>> tasks = await db.rawQuery('SELECT * FROM task');

    // List<Map<String, Object>> tasksAsObject = tasks.map((task) => task as Map<String, Object>).toList();
    for(Map<String, Object?> each in tasks){
      Logger().d('Each Task => ${each.toString}');
      var dbTask = {
        'id' : each['id'] ?? 9999,
        'name' : each['name'] ?? 'DEFAULT_NAME',
        'when' : (each['when'] ?? DateTime.now()).toString(),
        'details' : (each['details'] ?? '').toString(),
        'priority' : each['priority'] ?? 1, // in case priority is not null 
        'allDay' : each['allDay'] ?? false,
        'recurring' : each['recurring'] ?? false,
        'completed' : each['completed'] ?? false,
      };
      data['data']?.add(dbTask);
    }
    Logger().d('La la Data=> ${data['data']}');
    return data;
  }

}