import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({Key? key}) : super(key: key);

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {

  final dateformat = DateFormat("dd - MM - yyyy");
  var today_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text("Student Feedbacks"),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(onPressed: (){}, label: Text(dateformat.format(today_date)), icon: const Icon(FluentIcons.calendar))
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('feedbacks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData){
              return const Center(child: ProgressRing());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            );
          }
        ),
      ),
    );
  }
}
