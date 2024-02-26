import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  final String device;
  const NotificationScreen({super.key, required this.device,});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isActive = false;
  List Notification = [];

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
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            "Notification",
            style: GoogleFonts.roboto(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          )),
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
                    margin:
                    const EdgeInsets.only(bottom: 15, ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                      tileColor: Colors.white,
                      leading:   CircleAvatar(
                        radius: 25,
                        child: ClipOval(
                          child: Image.asset(imagesDp[index],

                            fit: BoxFit.cover,

                          ),
                        ),
                      ),
                          title: Text(
                        "Your job application to Google has been successfully submitted.",
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text(
                        "Oct 06, 2023",
                        style: GoogleFonts.roboto(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              );
            }),
      ),
    );
  }
}
