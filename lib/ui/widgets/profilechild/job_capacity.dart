import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:flutter_mmhelper/utils/data.dart';

class JobCapacity extends StatefulWidget {
  @override
  _JobCapacityState createState() => _JobCapacityState();
}

class _JobCapacityState extends State<JobCapacity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Job Capacity",
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
        textTheme:
        TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MamaProfile();
                }));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(10),
          separatorBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 0.5,
                color: Colors.black26,
                width: MediaQuery.of(context).size.width,
                child: Divider(),
              ),
            );
          },
          itemCount: jobcapacitys.length,
          itemBuilder: (BuildContext context, int index) {
            Map jobcapacity = jobcapacitys[index];
            return Padding(
              padding:const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
              child: Container(
                child: GestureDetector(
                  child: Text(
                      jobcapacity['name']
                  ),
                  onTap:(){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MamaProfile(dataIndex: 1,workText:jobcapacity['name'] ,);
                    }));
                  } ,
                ),
              ),
            );
          }
      ),
    );
  }
}
