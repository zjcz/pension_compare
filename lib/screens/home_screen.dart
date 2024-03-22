import 'package:flutter/material.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/database/tables/pensions_with_latest_statement.dart';
// import 'package:bin_reminder/widgets/delete_confirmation_dialog.dart';
import 'package:pension_compare/screens/edit_pension_screen.dart';
import 'package:pension_compare/screens/edit_statement_screen.dart';
import 'package:pension_compare/screens/edit_state_pension_screen.dart';
import 'package:pension_compare/widgets/pension_data_table.dart';

// TODO - add list of pensions + summary data
// TODO - Allow add pension and statement functionality
// TODO - Add Chart
// TODO - Add Settings button
class HomeScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const HomeScreen({super.key, required this.databaseService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = _getDatabaseService();

    return Scaffold(
        appBar: AppBar(title: const Text('Overview'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditPensionScreen()))
                  .then((_) => {setState(() {})});
            },
          ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FutureBuilder<List<PensionWithLatestStatement>>(
                    future: db.getAllPensionsWithLatestStatement(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error loading data: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child:
                                Text('No pensions found.  Click + to add one'));
                      } else {
                        final List<PensionWithLatestStatement> pensions =
                            snapshot.data!;
                        return PensionDataTable(
                          pensionDataList: pensions,
                          onTap: (Pension pension) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPensionScreen(
                                          pension: pension,
                                          databaseService: db,
                                        ))).then((_) => {setState(() {})});
                          },
                        );

                        // return ListView.separated(
                        //   separatorBuilder: (BuildContext context, int index) {
                        //     return const SizedBox(height: 5);
                        //   },
                        //   itemBuilder: (context, index) {
                        //     Pension pension = pensions[index];
                        //     return ListTile(
                        //       //tileColor: context.surfaceContainerHighest,
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius:
                        //               BorderRadiusDirectional.circular(5)),
                        //       title: Text(pension.name),
                        //     );
                        //   },
                        //   itemCount: pensions.length,
                        // );
                      }
                    },
                  )),
            ),
          ],
        ));
  }

  DatabaseService _getDatabaseService() {
    return widget.databaseService;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
