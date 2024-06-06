import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madadguru/Allwidgets/background_screen.dart';
import 'package:madadguru/Pages/Profile_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceSet extends StatefulWidget {
  final String device;
  const PreferenceSet({
    super.key,
    required this.device,
  });
  @override
  State<PreferenceSet> createState() => _PreferenceSetState();
  }
  class _PreferenceSetState extends State<PreferenceSet> {

  List switchStates = [];
  String iwant ="";
  bool isLoading=false;
  Map<String, dynamic> Data = {};
    List<dynamic> Data2 = [];
    Future<void> sendSelectedAPI(String value) async {
      setState(() {
        isLoading = true;
      });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null){
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/updateProfile");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
          },
          body: {
            "i_want": iwant,
            },
          );
        print(" response${response}");
        if (response.statusCode == 200) {
          print(response.body);
          Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                  builder: (context) => ProfilePreference(
                  device: widget.device,
                ),
              ),
                  (route) => false);
          print('i_want selection sent to API successfully.');
          } else {
          print('Failed to send i_want selection to API. Status code: ${response.statusCode}');
           }
          }
        catch (error) {
        print('Error sending i_want selection to API: $error');
        }
         finally {
          setState(() {
          isLoading = false;
        });
      }
    }
    }

  @override
  void initState() {
    super.initState();
    // Call API to get data and initialize switches
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getWant");
      try {
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $usertoken',
            },

          );
           if (response.statusCode == 200) {
          var jData = json.decode(response.body);
          setState(() {
            Data = jData;
            Data2 = Data['data'];
            switchStates = List.generate(Data2.length, (index) => false);
            print("data from api is $Data");
            isLoading = false;
          });
          // if (jData['data'] != null) {
          //   initializeSwitches(jData['data']);
          //
          // }

          print(response.body);
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //       builder: (context) => ProfilePreference(
          //         device: widget.device,
          //       ),
          //     ),
          //         (route) => false);
          print('Data fetched successfully');
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
      finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  void updateIWant() {
    List<String> selectedItems = [];
    for (int i = 0; i < switchStates.length; i++) {
      if (switchStates[i]) {
        selectedItems.add(Data2[i]['id'].toString());
      }
    }
    setState(() {
      iwant = selectedItems.join(',');
    });
    print("i want's value here: $iwant");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child:isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15),
                  padding: const EdgeInsets.only(bottom: 7),
                  alignment: Alignment.center,
                  height: 50,
                  width: 180,
                  decoration:  BoxDecoration(
                    // borderRadius:BorderRadius.circular(12),border: Border.all(width: 1,color: Colors.orange),
                    image: DecorationImage(
                      image: AssetImage("assets/images/rectangle.png"),
                      //    fit: BoxFit.fill
                    ),
                  ),
                  child: Text(
                    "I want:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: const Color(0xFF524B6B),
                    ),
                  ),
                ),
                    SizedBox(height: 30,),
                    _buildListView(),

              ]),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                // Navigate to the second page
                sendSelectedAPI(iwant);
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
          ),
        ],
      ),
    );
  }
  // List<bool> switchStates = List.generate(Data.length, (index) => false);
  Widget _buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: Data.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index >= Data2.length) {
          return Container();
          }
          return ListTile(
          title: Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(12),
              border: Border.all(width: 1,color: Colors.orange),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    children: [
                      Image.asset('assets/images/icon.png'),
                      Text(
                        Data2[index]['name'].toString(), // Use data from your Data list
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: switchStates[index],
                    onChanged: (value) {
                      setState(() {
                        switchStates[index] = value;
                      });
                        updateIWant();
                          },
                    // value: switchStates[index],
                    // onChanged: (value) {
                    //   setState(() {
                    //     switchStates[index] = value;
                    //     iwant = value.toString();
                    //
                    //     // iwant = value.map((item) => item['id'].toString()).join(',');
                    //
                    //     print("i want's value here $iwant");
                    //   });
                    // },
                    activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );
      },
     );
    }
  }