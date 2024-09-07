import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:strapi_task_app/screens/components/task_item.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  final String getTasksQuery = """
    query GetTasks {
      tasks {
        data {
          id
          attributes {
            title
            description
            completed
          }
        }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          // Add Button to navigate to AddTaskScreen
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navigate to AddTaskScreen and wait for result
              bool? taskAdded = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );

              // If a new task was added, trigger refetch
              if (taskAdded == true) {
                // Trigger refetch after the user adds a task
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task added! Refetching...')),
                );
              }
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getTasksQuery),
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text('Error fetching tasks'));
          }

          final tasks = result.data!['tasks']['data'];

          return RefreshIndicator(
            onRefresh: () async {
              refetch!();  // Enable pull-to-refresh
            },
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index]['attributes'];
                return TaskItem(
                  id: tasks[index]['id'],
                  title: task['title'],
                  description: task['description'],
                  completed: task['completed'],
                  refetch: refetch!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}