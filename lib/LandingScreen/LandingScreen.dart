import 'package:flutter/material.dart';
import 'package:qandaapp/app_theme.dart';
import 'package:qandaapp/chatscreen/q_a_room.dart';
import 'package:qandaapp/models/user_model.dart';
import 'package:qandaapp/DiagramScreen/Diagram_Screen.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children:<Widget> [
          Column(
            children: <Widget>[
              Expanded(
                flex:4 ,
                //padding: const EdgeInsets.only(top: 0),
                child:Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff1e1b58),Color(0xffd12d4f)],
                      begin: Alignment(-1.0, -1),
                      end: Alignment(-1.0, 1),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 15.0,
                          offset: Offset(0.0, 0.75)
                      )
                    ],
                  ),
                  child: Column(
                      children: [
                        SizedBox(height: 60.0,),
                        CircleAvatar(
                          radius: 65.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/profilepic.png'),
                            radius: 63.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Text('Erza Scarlet',
                          style: MyTheme.heading2.copyWith(color: MyTheme.kWhite),
                        ),
                        SizedBox(height: 4.0,),
                        Text('Service Engineer',
                          style: MyTheme.bodyText1.copyWith(color: MyTheme.kWhite),
                        ),
                        SizedBox(height: 4.0,),
                        Text('scarlet.er@alstom.com',
                          style: MyTheme.bodyText1.copyWith(color: MyTheme.kWhite),
                        ),
                        SizedBox(height: 4.0,),
                        Text('(234) 235-5678',
                          style: MyTheme.bodyText1.copyWith(color: MyTheme.kWhite),
                        ),
                        SizedBox(height: 15.0,),
                      ]
                  ),
                ),
              ),

              Expanded(
                flex: 6,
               // padding: const EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 10),
                child: Center(
                    child:Card(
                        elevation: 10,  // Change this
                        shadowColor: Colors.grey,
                       margin:const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Container(
                           // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                            //width: MediaQuery.of(context).size.width*0.9,
                           // height:MediaQuery.of(context).size.height*0.65,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: allWorkOrders.length,
                                itemBuilder: (context, index) {
                                  WorkOrderData data = allWorkOrders[index];
                                  if (index == 0) {
                                    return Column(
                                      children: <Widget>[
                                        Text('Work Orders',
                                          style: MyTheme.screenTitle.copyWith(color: MyTheme.kDarkGrey),
                                        ),
                                        Divider(),
                                        ListTile(
                                          onTap: (){
                                            _moveToNextScreen(data.name);
                                          },
                                          title: Text(
                                              data.name,
                                            style: MyTheme.chatSenderName.copyWith(color: MyTheme.kDarkGrey),
                                          ),
                                          subtitle: Text(
                                            data.subtitle,
                                            style: MyTheme.summaryValue.copyWith(color: MyTheme.kDarkGrey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return ListTile(
                                      onTap: (){
                                        _moveToNextScreen(data.name);
                                      },
                                      title: Text(
                                        data.name,
                                        style: MyTheme.chatSenderName.copyWith(color: MyTheme.kDarkGrey),
                                      ),
                                      subtitle: Text(
                                        data.subtitle,
                                        style: MyTheme.summaryValue.copyWith(color: MyTheme.kDarkGrey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                              ),
                            )
                        )
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  _moveToNextScreen(String title){
   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QandARoom(user: botSuMed,heading: title,)));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DiagramScreen(user: botSuMed,heading: title,)));
  }
}



class WorkOrderData {

  WorkOrderData({required this.name,required this.subtitle});
  final String name;
  final String subtitle;
}

List<WorkOrderData> allWorkOrders = [
  WorkOrderData(name: 'WOAS01', subtitle: 'Inadequate air delivery at normal compressor working temperature'),
  WorkOrderData(name: 'WOAS02', subtitle: 'Preventive maintenance work orders'),
  WorkOrderData(name: 'WOAS03', subtitle: 'Inspection work orders'),
  WorkOrderData(name: 'WOAS04', subtitle: 'Emergency work orders'),
  WorkOrderData(name: 'WOAS05', subtitle: 'Corrective maintenance work orders'),
];