
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TaskItem extends StatelessWidget {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final VoidCallback refetch;

  const TaskItem({super.key, 
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.refetch,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: description != null ? Text(description!) : null,
      trailing: Checkbox(
        value: completed,
        onChanged: (bool? value) {
          _toggleTaskComplete(context, value!);
        },
      ),
    );
  }

  void _toggleTaskComplete(BuildContext context, bool isCompleted) async {
    const String updateTaskMutation = """
      mutation UpdateTask(\$id: ID!, \$completed: Boolean!) {
        updateTask(id: \$id, data: { completed: \$completed }) {
          data {
            id
            attributes {
              completed
            }
          }
        }
      }
    """;

    final GraphQLClient client = GraphQLProvider.of(context).value;

    await client.mutate(
      MutationOptions(
        document: gql(updateTaskMutation),
        variables: {'id': id, 'completed': isCompleted},
      ),
    );
    
    refetch();
  }
}
