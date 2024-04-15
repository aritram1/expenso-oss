// ignore_for_file: constant_identifier_names
class FinPlanCalendarUtil {
  
  // A function to get the list of tasks
  Future<Map<String, dynamic>> getFutureData({String? day}) async {
    day = (day != null) ? day.split(' ')[0] : DateTime.now().toString().split(' ')[0]; // 2024-04-17
    var data1 =  {
      'data': [
        {'id': '1', 'name': 'Task 1', 'date': '17/9/2020', 'details': 'One Sample Task', 'completed': 1, 'imp': 'h'},
        {'id': '2', 'name': 'Task 2', 'date': '12/6/2021', 'details': 'Two Sample Task', 'completed': 0, 'imp': 'h'},
        {'id': '3', 'name': 'Task 3', 'date': '23/4/2019', 'details': '3rd Sample Task', 'completed': 0, 'imp': 'm'},
        {'id': '4', 'name': 'Task 4', 'date': '15/2/2018', 'details': '4th Sample Task', 'completed': 1, 'imp': 'l'},
      ]
    };
    var data2 =  {
      'data': [
        {'id': '1', 'name': 'Task 1', 'date': '17/9/2020', 'details': 'One Sample Task', 'completed': 1, 'imp': 'h'},
        {'id': '2', 'name': 'Task 2', 'date': '12/6/2021', 'details': 'Two Sample Task', 'completed': 0, 'imp': 'h'},
        {'id': '3', 'name': 'Task 3', 'date': '23/4/2019', 'details': '3rd Sample Task', 'completed': 0, 'imp': 'm'},
        {'id': '4', 'name': 'Task 4', 'date': '15/2/2018', 'details': '4th Sample Task', 'completed': 1, 'imp': 'l'},
      ]
    };
    await Future.delayed(const Duration(seconds: 1));
    return data1;
  }

}