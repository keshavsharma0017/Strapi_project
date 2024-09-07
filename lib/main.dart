import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:strapi_task_app/screens/task_list_screen.dart';

void main() async {
  await initHiveForFlutter();
  final HttpLink httpLink = HttpLink('https://your-strapi-api-url/graphql');
  
  // Add auth if needed
  final AuthLink authLink = AuthLink(getToken: () async => 'Bearer your-access-token');
  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client,});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Strapi Task App',
        home: TaskListScreen(),
      ),
    );
  }
}
