  import 'package:flutter/material.dart';
  class Account_JobPreference extends StatefulWidget {
  final String device;
  const Account_JobPreference({super.key, required this.device});
  @override
  State<Account_JobPreference> createState() => _Account_JobPreferenceState();
    }
  class _Account_JobPreferenceState extends State<Account_JobPreference> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Colors.white,
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
            title: Text("About Us",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
        ),
         ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Welcome to MadadGuru ! ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
               "Your go-to platform for all your human resources needs in the industry!\n\n"
                  "We understand that a successful business thrives on the passion, dedication, and expertise of its workforce. That's why we are committed to providing comprehensive HR solutions tailored specifically for the unique challenges faced by the sector.\n\n"
                  "At MadadGuru, we offer Technology Powered Staffing Solutions to meet the specific demands of the industry. Our platform provides 100% verified profiles, Video Interviews, Free job postings, Inbuilt skill assessment tests, Inbuilt HRMS capabilities as well as Intelligent profile matching algorithm.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              ),
              SizedBox(
              height: 30,
              ),
              Text("Why Choose MadadGuru : ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              ),
               SizedBox(
              height: 10,
               ),
               Text(
                  "Industry Expertise\n"
                  "User-Friendly Interface\n"
                  "Dedicated Support\n"
                  "Full time, Part time, On Demand Work\n"
                  "Professional and skill development\n"
                  "Verified employers\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!\n\n"
                  "Join us at MadadGuru and revolutionize the way you manage your human resources. Our disruptive technology is transforming the landscape for professionals and partners alike.\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!",
                 style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                ),
               ),
        ]),
      ),
    );
  }
  }
  class Privacy_JobPreference extends StatefulWidget {
    final String device;
    const Privacy_JobPreference({super.key, required this.device});
    @override
    State<Privacy_JobPreference> createState() => _Privacy_JobPreferenceState();
  }
  class _Privacy_JobPreferenceState extends State<Privacy_JobPreference> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
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
          title: Text("Privacy policy",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Welcome to MadadGuru ! ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your go-to platform for all your human resources needs in the industry!\n\n"
                  "We understand that a successful business thrives on the passion, dedication, and expertise of its workforce. That's why we are committed to providing comprehensive HR solutions tailored specifically for the unique challenges faced by the sector.\n\n"
                  "At MadadGuru, we offer Technology Powered Staffing Solutions to meet the specific demands of the industry. Our platform provides 100% verified profiles, Video Interviews, Free job postings, Inbuilt skill assessment tests, Inbuilt HRMS capabilities as well as Intelligent profile matching algorithm.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Why Choose MadadGuru : ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Industry Expertise\n"
                  "User-Friendly Interface\n"
                  "Dedicated Support\n"
                  "Full time, Part time, On Demand Work\n"
                  "Professional and skill development\n"
                  "Verified employers\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!\n\n"
                  "Join us at MadadGuru and revolutionize the way you manage your human resources. Our disruptive technology is transforming the landscape for professionals and partners alike.\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
        ),
      );
    }
  }




  class Term_JobPreference extends StatefulWidget {
    final String device;
    const Term_JobPreference({super.key, required this.device});
    @override
    State<Term_JobPreference> createState() => _Term_JobPreferenceState();
  }
  class _Term_JobPreferenceState extends State<Term_JobPreference> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
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
          title: Text("Term of use",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Welcome to MadadGuru ! ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your go-to platform for all your human resources needs in the industry!\n\n"
                  "We understand that a successful business thrives on the passion, dedication, and expertise of its workforce. That's why we are committed to providing comprehensive HR solutions tailored specifically for the unique challenges faced by the sector.\n\n"
                  "At MadadGuru, we offer Technology Powered Staffing Solutions to meet the specific demands of the industry. Our platform provides 100% verified profiles, Video Interviews, Free job postings, Inbuilt skill assessment tests, Inbuilt HRMS capabilities as well as Intelligent profile matching algorithm.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Why Choose MadadGuru : ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Industry Expertise\n"
                  "User-Friendly Interface\n"
                  "Dedicated Support\n"
                  "Full time, Part time, On Demand Work\n"
                  "Professional and skill development\n"
                  "Verified employers\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!\n\n"
                  "Join us at MadadGuru and revolutionize the way you manage your human resources. Our disruptive technology is transforming the landscape for professionals and partners alike.\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
        ),
      );
    }
  }


  class myPreferece extends StatefulWidget {
    final String device;
    const myPreferece({super.key, required this.device});
    @override
    State<myPreferece> createState() => _myPrefereceState();
  }
  class _myPrefereceState extends State<myPreferece> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
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
          title: Text("My Preference",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Welcome to MadadGuru ! ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your go-to platform for all your human resources needs in the industry!\n\n"
                  "We understand that a successful business thrives on the passion, dedication, and expertise of its workforce. That's why we are committed to providing comprehensive HR solutions tailored specifically for the unique challenges faced by the sector.\n\n"
                  "At MadadGuru, we offer Technology Powered Staffing Solutions to meet the specific demands of the industry. Our platform provides 100% verified profiles, Video Interviews, Free job postings, Inbuilt skill assessment tests, Inbuilt HRMS capabilities as well as Intelligent profile matching algorithm.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Why Choose MadadGuru : ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Industry Expertise\n"
                  "User-Friendly Interface\n"
                  "Dedicated Support\n"
                  "Full time, Part time, On Demand Work\n"
                  "Professional and skill development\n"
                  "Verified employers\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!\n\n"
                  "Join us at MadadGuru and revolutionize the way you manage your human resources. Our disruptive technology is transforming the landscape for professionals and partners alike.\n\n"
                  "We believe in empowering you to shape your own career path and work on your terms, where flexibility and freedom are at the core of your professional journey. With MadadGuru, you have the autonomy to work with hotels, restaurants, and other partners- whenever, wherever, and however you want!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
        ),
      );
    }
  }
