import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EnquaryScreen extends StatefulWidget {
  final String device;
  const EnquaryScreen({
    super.key,
    required this.device,
  });
  @override
  State<EnquaryScreen> createState() => _EnquaryScreenState();
}
class _EnquaryScreenState extends State<EnquaryScreen> {
  bool isActive = false;
  List Notification = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
  }
  List<String> imagesDp = [
    'assets/images/dp1.png',
    'assets/images/dp2.jpeg',
    'assets/images/dp3.webp',
    'assets/images/dp4.jpeg',
    'assets/images/girl.png',
    'assets/images/dp3.webp',
    'assets/images/girl.png',
    'assets/images/dp3.webp',
    'assets/images/dp4.jpeg',
    'assets/images/people.webp',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            border: Border.all(color: Colors.black38, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: TextField(
              autofocus: false,
              // controller: searchController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff7a7979),
                    size: 25,
                    ),
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  // const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: const Color(0xff7a7979),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
              ),
              onSubmitted: (_) {}),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10, left: 10.0, top: 10, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child:
                                      // CircleAvatar(
                                      //   radius: 35,
                                      //   backgroundImage: NetworkImage(
                                      //     'https://i.pinimg.com/originals/5a/6b/16/5a6b16956a2753892d9ee5714f6f112a.jpg',
                                      //   ),
                                      // ),
                                      CircleAvatar(
                                    radius: 35,
                                    child: ClipOval(
                                      child: Image.asset(
                                        imagesDp[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ),
                                  ),
                                  SizedBox(
                                  width: 15,
                                  ),
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                         "Gajendra Singh ",
                                          style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                          ),
                                      SizedBox(
                                      height: 3,
                                         ),

                                         Text(
                                        "Lowyer",
                                         style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                          ),
                                        SizedBox(
                                        height: 3,
                                         ),

                                      Text(
                                      "Greater Noida",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      ),

                                     SizedBox(
                                      height: 2,
                                      ),
                                      Text(
                                         "This is the Sample Enquiry ask by App user.",
                                          style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                 ),
                                ],
                              ),
                              Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Call'),

                                              content: Text(
                                                  'Are you sure you want to Call?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                     child: Text('No'),
                                                        ),
                                                      TextButton(
                                                      onPressed: () async {
                                                      var phoneNumber = "";
                                                      var url = "tel:$phoneNumber";
                                                      print("Calling $phoneNumber");
                                                      await launchUrl(Uri.parse(url));
                                                      },
                                                      child: Text('Yes'),
                                                      ),
                                              ],
                                            );
                                          });
                                        },
                                       child: Icon(Icons.call,
                                        color: Colors.greenAccent)),
                                       InkWell(
                                       onTap: () {
                                        showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('WhatsApp'),
                                            content: Text(
                                                'Are you sure you want to WhatsApp Message?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                    Navigator.of(context).pop();
                                                    },
                                                    child: Text('No'),
                                                     ),
                                                TextButton(
                                                    onPressed: () async{
                                                    var url="https://wa.me/?text=Hello";
                                                    print("the url is $url");
                                                    await launchUrl(Uri.parse(url),
                                                    );
                                                     },
                                                     child: Text('Yes'),
                                                  ),
                                                  ],
                                                 );
                                                },
                                              );
                                            },
                                           child: Image.asset(
                                         'assets/images/whats.png',
                                         height: 50,
                                       width: 50,
                                     ),
                                ),
                              ],
                            ),
                          ],
                      ),
                     ),
                    ),
              );
            }),
         ),
        );
      }
    void launchContactLink() async {
    String phoneNumber = '8318301829';
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch Contacts/Dialer');
    }
    }

    // void launchWhatsApp() async {
    // String phoneNumber = '8318301829';
    // String message = 'Hello, this is a test message.';
    // String url =
    //     'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   print('Could not launch WhatsApp');
    // }
    // }


}
