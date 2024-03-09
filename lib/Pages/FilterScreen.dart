import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:madadguru/Allwidgets/background_screen.dart';
import '../Allwidgets/BottomNavBar.dart';

class FilterScreen extends StatefulWidget {
  final String device;
  const FilterScreen({super.key, required this.device,});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<dynamic> department = [];
  List DepartmentList = [
    {
      "id": 29,
      "filterValue": "Tempory",
    },
    {
      "id": 30,
      "filterValue": "Permanent",
    },
    {
      "id": 31,
      "filterValue": "Greater Noida",
    },
    {
      "id": 32,
      "filterValue": "Vaisali",
    },
    {
      "id": 33,
      "filterValue": "Mumbai",
    },
    {
      "id": 34,
      "filterValue": "Chennai",
    },
    {
      "id": 35,
      "filterValue": "Pune",
    },
    {
      "id": 36,
      "filterValue": "Bangalore",
    },
    {
      "id": 37,
      "filterValue": "Rajasthan",
    },
    {
      "id": 38,
      "filterValue": "Goa",
    },
    {
      "id": 39,
      "filterValue": "Grater Noida",
    },
    {
      "id": 40,
      "filterValue": "Mumbai",
    },
    {
      "id": 41,
      "filterValue": "Chennai",
    },
    {
      "id": 42,
      "filterValue": "Pune",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const Background(),
        SingleChildScrollView(
          child:
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text('Personalize Your Feed -',style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: const Color(0xFF524B6B),
              ),),
            ),
            SizedBox(height: 50,),
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 15),
              padding: const EdgeInsets.only(bottom: 7),
              alignment: Alignment.center,
              height: 50,
              width: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/rectangle.png"),
                ),
              ),
              child: Text(
                "Help Category:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: const Color(0xFF524B6B),
                ),
              ),
            ),
            ChipsChoice<dynamic>.multiple(
              choiceItems: C2Choice.listFrom<dynamic, dynamic>(
                source: DepartmentList,
                value: (index1, item) => DepartmentList[index1]['id'],
                label: (index1, item) => DepartmentList[index1]['filterValue'],
              ),
              value: department,
              onChanged: (val) => setState(() => department = val),
              choiceCheckmark: true,
              choiceStyle: C2ChipStyle.outlined(
                color: Color(0xFFA2A09D),
                checkmarkColor: Colors.white,
                foregroundStyle:
                const TextStyle(color: Color(0xFF2F2924), fontSize: 14),
                selectedStyle: C2ChipStyle.filled(
                  foregroundStyle: TextStyle(color: Colors.white, fontSize: 14),
                  color: Color(0xff655D53),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              wrapped: true,
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 15),
              padding: const EdgeInsets.only(bottom: 7),
              alignment: Alignment.center,
              height: 50,
              width: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/rectangle.png"),
                    fit: BoxFit.fill),
              ),
              child: Text(
                "Help Urgency:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: const Color(0xFF524B6B),
                ),
              ),
            ),
            ChipsChoice<dynamic>.multiple(
              choiceItems: C2Choice.listFrom<dynamic, dynamic>(
                source: DepartmentList,
                value: (index1, item) => DepartmentList[index1]['id'],
                label: (index1, item) => DepartmentList[index1]['filterValue'],
              ),
              value: department,
              onChanged: (val) => setState(() => department = val),
              choiceCheckmark: true,
              choiceStyle: C2ChipStyle.outlined(
                color: Color(0xFFA2A09D),
                checkmarkColor: Colors.white,
                foregroundStyle:
                const TextStyle(color: Color(0xFF2F2924), fontSize: 14),
                selectedStyle: C2ChipStyle.filled(
                  foregroundStyle: TextStyle(color: Colors.white, fontSize: 14),
                  color: Color(0xff655D53),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              wrapped: true,
            ),

            Container(
              margin: EdgeInsets.only(left: 15, bottom: 15),
              padding: const EdgeInsets.only(bottom: 7),
              alignment: Alignment.center,
              height: 50,
              width: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/rectangle.png"),
                    fit: BoxFit.fill),
              ),
              child: Text(
                "Happy To:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: const Color(0xFF524B6B),
                ),
              ),
            ),

          ]),
        ),
        Positioned(
          right: 10,
          bottom: 40,
          left: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFFFEADD),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF524B6B),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BottomNavBar(
                      device: widget.device,
                    );
                  }));
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFFFEADD),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF524B6B),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
