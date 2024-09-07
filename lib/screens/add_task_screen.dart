import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final String createTaskMutation = """
    mutation CreateTask(\$title: String!, \$description: String) {
      createTask(data: { title: \$title, description: \$description, completed: false }) {
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
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Input Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Description Input Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            
            // Mutation Widget to Trigger GraphQL Mutation
            Mutation(
              options: MutationOptions(
                document: gql(createTaskMutation),
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return ElevatedButton(
                  onPressed: () {
                    final String title = _titleController.text;
                    final String description = _descriptionController.text;

                    // Validate input fields
                    if (title.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title cannot be empty')),
                      );
                      return;
                    }

                    // Trigger mutation to create a new task
                    runMutation({
                      'title': title,
                      'description': description,
                    });

                    // Return true to indicate task was added
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Add Task'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
