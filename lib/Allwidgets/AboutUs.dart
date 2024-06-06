import 'package:flutter/material.dart';
  class AboutUs extends StatefulWidget {
  final String device;
    const AboutUs({
    super.key,
    required this.device,
  });

  @override
  State<AboutUs> createState() => _AboutUsState();
  }
 class _AboutUsState extends State<AboutUs> {
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
        title: Text(
          "About Us Madadguru",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'WHO',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'WE ARE',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 5,
                    color: Color(0xff2BB79D),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 30,
                    color: Color(0xff2BB79D),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'LOREM IPSUM IS SIMPLY',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff2BB79D),
                        fontWeight: FontWeight.bold),
                    ),
                   ],
                   ),

                 SizedBox(height: 10),

                 Row(
                  children: [
                  Container(
                    height: 130,
                    width: 3,
                    color: Colors.grey,
                  ),

                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,
                        'Madadguru NGO, operating in India, stands as a beacon of assistance and support for individuals navigating complex legal, real estate, property, community, and financial challenges. Founded on the principles of empowerment and community welfare, Madadguru has been instrumental in providing a holistic range of services to those in need, striving to create a more equitable and just society.', // 'We are a bunch of Techies on the Journey to make Education Simple and Affordable. But, is there a need?The worlds is Moving towards Artificial Intelligence, Machine Learning, Virtual Reality & Augmented Reality but the Education industry (Our institutes and teachers) is still not Comfortable with Technology.We want to guide our Teachers to make a swift Transition from Traditional to cutting edge methods of Imparting learning among Students.We are Consistently working towards making the Learning process simple and Affordable for the teachers as well as Students.',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 5,
                    color: Colors.redAccent.shade100,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 30,
                    color: Colors.redAccent.shade100,
                  ),

                  SizedBox(
                    width: 5,
                  ),

                  Text(
                    'LOREM IPSUM IS SIMPLY',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent.shade100,
                        fontWeight: FontWeight.bold),
                  ),
                 ],
                ),
              SizedBox(height: 10),
              Row(
                children: [

                  Container(
                    height: 120,
                    width: 3,
                    color: Colors.grey,
                       ),

                  SizedBox(width: 10),

                    Expanded(
                     child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,'One of the key areas where Madadguru excels is in legal aid. The organization offers pro bono legal assistance to individuals who may not have the means to access legal support otherwise. This includes guidance on various legal matters, representation in court, and advocacy for the rights of marginalized communities. By bridging the gap between legal expertise and those in need, Madadguru ensures that justice is not a privilege but a right for all.',
                         style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 5,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 5,
                    ),
                    Text(
                      'LOREM IPSUM IS SIMPLY',
                       style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold
                       ),
                     ),
                    ],
                  ),
              SizedBox(height: 10),

                Row(
                children: [
                  Container(
                    height: 130,
                    width: 3,
                    color: Colors.grey,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                     child: Container(
                      width: MediaQuery.of(context).size.width,
                       child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,
                        "Madadguru extends its impact to the community by fostering initiatives that promote social cohesion and development. Through community-building projects, educational programs, and health initiatives, the NGO aims to uplift the overall well-being of the communities it serves. This comprehensive approach recognizes the interconnectedness of various social issues and seeks to address them collectively.",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
