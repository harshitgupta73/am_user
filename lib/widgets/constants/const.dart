

import 'package:flutter/material.dart';

const backgroundColor = Colors.white;
const forgroundColor = Colors.black;
const searchBoxColor = Color.fromRGBO(40, 20, 30, 1);




const customTextColor = Colors.black;

const stateList = [

 "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
 "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
 "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
 "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
 "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
 "New Hampshire", "New Jersey", "New Mexico", "New York",
 "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
 "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
 "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
 "West Virginia", "Wisconsin", "Wyoming"
];


const  Map<String, List<String>> stateDistrictMap = {
'Andhra Pradesh': [
'Anantapur', 'Chittoor', 'East Godavari', 'Guntur', 'Krishna', 'Kurnool', 'Nellore',
'Prakasam', 'Srikakulam', 'Visakhapatnam', 'Vizianagaram', 'West Godavari', 'YSR Kadapa',
],
'Arunachal Pradesh': [
'Anjaw', 'Changlang', 'East Kameng', 'East Siang', 'Kurung Kumey', 'Lohit', 'Longding',
'Lower Dibang Valley', 'Lower Subansiri', 'Namsai', 'Papum Pare', 'Siang', 'Tawang',
'Tirap', 'Upper Dibang Valley', 'Upper Siang', 'Upper Subansiri', 'West Kameng', 'West Siang',
],
'Assam': [
'Baksa', 'Barpeta', 'Bongaigaon', 'Cachar', 'Charaideo', 'Chirang', 'Darrang', 'Dhemaji',
'Dibrugarh', 'Dima Hasao', 'Goalpara', 'Golaghat', 'Hailakandi', 'Hojai', 'Jorhat',
'Kamrup', 'Kamrup Metropolitan', 'Karbi Anglong', 'Karimganj', 'Kokrajhar', 'Lakhimpur',
'Majuli', 'Morigaon', 'Nagaon', 'Nalbari', 'Sivasagar', 'Sonitpur', 'South Salmara-Mankachar',
'Tinsukia', 'Udalguri', 'Umar', 'West Karbi Anglong',
],
'Bihar': [
'Araria', 'Arwal', 'Aurangabad', 'Banka', 'Begusarai', 'Bhagalpur', 'Bhojpur', 'Buxar',
'Darbhanga', 'East Champaran', 'Gaya', 'Gopalganj', 'Jamui', 'Jehanabad', 'Kaimur', 'Katihar',
'Khagaria', 'Kishanganj', 'Lakhisarai', 'Madhepura', 'Madhubani', 'Munger', 'Muzaffarpur',
'Nalanda', 'Nawada', 'Patna', 'Purnia', 'Rohtas', 'Saharsa', 'Samastipur', 'Saran',
'Sheikhpura', 'Sheohar', 'Sitamarhi', 'Siwan', 'Supaul', 'Vaishali', 'West Champaran',
],
'Chhattisgarh': [
'Balod', 'Baloda Bazar', 'Balrampur', 'Bastar', 'Bemetara', 'Bijapur', 'Bilaspur', 'Dantewada',
'Dhamtari', 'Durg', 'Gariaband', 'Janjgir-Champa', 'Jashpur', 'Kabirdham', 'Kanker', 'Kondagaon',
'Korba', 'Koriya', 'Mahasamund', 'Mungeli', 'Narayanpur', 'Raigarh', 'Raipur', 'Rajnandgaon', 'Sarguja',
],
'Goa': [
'North Goa', 'South Goa',
],
'Gujarat': [
'Ahmedabad', 'Amreli', 'Anand', 'Aravalli', 'Banaskantha', 'Bharuch', 'Bhavnagar', 'Botad',
'Chhota Udepur', 'Dahod', 'Dang', 'Devbhoomi Dwarka', 'Gandhinagar', 'Gir Somnath', 'Jamnagar',
'Junagadh', 'Kachchh', 'Kheda', 'Mahisagar', 'Mehsana', 'Morbi', 'Narmada', 'Navsari', 'Panchmahal',
'Patan', 'Porbandar', 'Rajkot', 'Sabarkantha', 'Surat', 'Surendranagar', 'Tapi', 'Vadodara', 'Valsad',
],
'Haryana': [
'Ambala', 'Bhiwani', 'Charkhi Dadri', 'Faridabad', 'Fatehabad', 'Gurugram', 'Hisar', 'Jhajjar',
'Jind', 'Kaithal', 'Karnal', 'Kurukshetra', 'Mahendragarh', 'Nuh', 'Palwal', 'Panchkula', 'Panipat',
'Rewari', 'Sirsa', 'Sonipat', 'Yamunanagar',
],
'Himachal Pradesh': [
'Bilaspur', 'Chamba', 'Hamirpur', 'Kangra', 'Kullu', 'Mandi', 'Shimla', 'Sirmaur', 'Solan', 'Una',
],
'Jharkhand': [
'Bokaro', 'Chatra', 'Deoghar', 'Dhanbad', 'Dumka', 'East Singhbhum', 'Garhwa', 'Giridih', 'Godda',
'Gumla', 'Hazaribagh', 'Jamtara', 'Khunti', 'Koderma', 'Latehar', 'Lohardaga', 'Pakur', 'Palamu',
'Ramgarh', 'Ranchi', 'Sahibganj', 'Seraikela-Kharsawan', 'Simdega', 'West Singhbhum',
],
'Karnataka': [
'Bagalkot', 'Ballari', 'Belagavi', 'Bellary', 'Bidar', 'Bijapur', 'Chamarajanagar', 'Chikkaballapur',
'Chikkamagaluru', 'Chitradurga', 'Dakshina Kannada', 'Davanagere', 'Dharwad', 'Gadag', 'Gulbarga',
'Hassan', 'Haveri', 'Kodagu', 'Kolar', 'Koppal', 'Mandya', 'Mysuru', 'Raichur', 'Ramanagara', 'Shivamogga',
'Tumakuru', 'Udupi', 'Vijayapura', 'Vijayapura', 'Yadgir',
],
'Kerala': [
'Alappuzha', 'Ernakulam', 'Idukki', 'Kottayam', 'Kozhikode', 'Malappuram', 'Palakkad', 'Pathanamthitta',
'Thiruvananthapuram', 'Thrissur', 'Wayanad',
],
'Madhya Pradesh': [
'Alirajpur', 'Anuppur', 'Ashoknagar', 'Balaghat', 'Barwani', 'Betul', 'Bhind', 'Bhopal', 'Burhanpur',
'Chhindwara', 'Damoh', 'Datia', 'Dewas', 'Dhar', 'Dindori', 'Guna', 'Gwalior', 'Harda', 'Hoshangabad',
'Indore', 'Jabalpur', 'Jhabua', 'Katni', 'Khandwa', 'Khargone', 'Mandla', 'Mandsaur', 'Morena', 'Narsinghpur',
'Neemuch', 'Panna', 'Raisen', 'Rajgarh', 'Ratlam', 'Rewa', 'Sagar', 'Satna', 'Sehore', 'Seoni', 'Shahdol',
'Shajapur', 'Sheopur', 'Shivpuri', 'Tikamgarh', 'Ujjain', 'Umaria', 'Vidisha',
],
'Maharashtra': [
'Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara', 'Buldhana', 'Chandrapur', 'Dhule',
'Gadchiroli', 'Gondia', 'Hingoli', 'Jalna', 'Kolhapur', 'Latur', 'Mumbai', 'Nanded', 'Nagpur', 'Nandurbar',
'Navi Mumbai', 'Osmanabad', 'Palghar', 'Parbhani', 'Pune', 'Raigad', 'Ratnagiri', 'Sangli', 'Satara',
'Sindhudurg', 'Solapur', 'Thane', 'Wardha', 'Washim', 'Yavatmal',
],
'Manipur': [
'Imphal East', 'Imphal West', 'Bishnupur', 'Churachandpur', 'Chandel', 'Thoubal', 'Senapati',
'Tamenglong', 'Ukhrul', 'Kangpokpi', 'Jiribam',
],
'Meghalaya': [
'East Garo Hills', 'East Khasi Hills', 'Jaintia Hills', 'Ri-Bhoi', 'West Garo Hills', 'West Khasi Hills',
],
'Mizoram': [
'Aizawl', 'Champhai', 'Kolasib', 'Lunglei', 'Mamit', 'Saitual', 'Serchhip',
],
'Nagaland': [
'Dimapur', 'Kohima', 'Mokokchung', 'Mon', 'Peren', 'Phek', 'Tuensang', 'Wokha', 'Zunheboto',
],
'Odisha': [
'Angul', 'Bargarh', 'Bhadrak', 'Balangir', 'Balasore', 'Cuttack', 'Dhenkanal', 'Ganjam', 'Gajapati',
'Jagatsinghpur', 'Jajpur', 'Kalahandi', 'Kandhamal', 'Kendrapara', 'Kendujhar', 'Khurda', 'Koraput',
'Malkangiri', 'Mayurbhanj', 'Nabarangpur', 'Nayagarh', 'Nuapada', 'Puri', 'Rayagada', 'Sambalpur', 'Sonepur',
],
'Punjab': [
'Amritsar', 'Barnala', 'Bathinda', 'Fatehgarh Sahib', 'Firozpur', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar',
'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Muktsar', 'Patiala', 'Rupnagar', 'Sangrur', 'SAS Nagar',
'Tarn Taran',
],
'Rajasthan': [
'Ajmer', 'Alwar', 'Banswara', 'Baran', 'Barmer', 'Bhilwara', 'Bikaner', 'Bundi', 'Chittorgarh',
'Churu', 'Dausa', 'Dholpur', 'Dungarpur', 'Hanumangarh', 'Jaipur', 'Jaisalmer', 'Jalore', 'Jhalawar',
'Jhunjhunu', 'Jodhpur', 'Karauli', 'Kota', 'Nagaur', 'Pali', 'Rajsamand', 'Sawai Madhopur',
'Sikar', 'Sirohi', 'Tonk', 'Udaipur',
],
'Sikkim': [
'East Sikkim', 'North Sikkim', 'South Sikkim', 'West Sikkim',
],
'Tamil Nadu': [
'Chennai', 'Coimbatore', 'Madurai', 'Trichy', 'Salem', 'Chidambaram', 'Cuddalore', 'Dharmapuri', 'Dindigul',
'Erode', 'Kanchipuram', 'Kanyakumari', 'Karur', 'Krishnagiri', 'Nagapattinam', 'Namakkal', 'Perambalur',
'Pudukkottai', 'Ramanathapuram', 'Salem', 'Sivaganga', 'Tenkasi', 'Thanjavur', 'The Nilgiris', 'Theni',
'Tiruvallur', 'Tirupur', 'Vellore', 'Villupuram', 'Virudhunagar',
],
'Telangana': [
'Hyderabad', 'Warangal', 'Khammam', 'Nizamabad', 'Karimnagar', 'Adilabad', 'Mahabubnagar', 'Medak',
'Khammam', 'Rangareddy', 'Nalgonda', 'Mahabubabad', 'Jagityal',
],
'Tripura': [
'Agartala', 'Dharmanagar', 'Udaipur', 'Ambassa', 'Kailashahar', 'Belonia',
],
'Uttar Pradesh': [
'Agra', 'Aligarh', 'Allahabad', 'Ambedkar Nagar', 'Azamgarh', 'Barabanki', 'Bareilly', 'Basti', 'Bijnor',
'Bulandshahr', 'Chandauli', 'Chitrakoot', 'Deoria', 'Etah', 'Etawah', 'Faizabad', 'Farrukhabad', 'Fatehpur',
'Firozabad', 'Gautam Buddha Nagar', 'Ghaziabad', 'Gonda', 'Gorakhpur', 'Hamirpur', 'Hardoi', 'Hathras',
'Jhansi', 'Jalaun', 'Jaunpur', 'Kanpur', 'Kanpur Dehat', 'Kasganj', 'Kaushambi', 'Kushinagar', 'Lakhimpur Kheri',
'Lucknow', 'Maharajganj', 'Mathura', 'Meerut', 'Mirzapur', 'Moradabad', 'Muzaffarnagar', 'Pilibhit',
'Pratapgarh', 'Raebareli', 'Rampur', 'Saharanpur', 'Sambhal', 'Sant Kabir Nagar', 'Shahjahanpur', 'Shrawasti',
'Siddharthnagar', 'Sitapur', 'Sonbhadra', 'Sultanpur', 'Unnao', 'Varanasi',
],
'Uttarakhand': [
'Almora', 'Bageshwar', 'Chamoli', 'Champawat', 'Dehradun', 'Haridwar', 'Nainital', 'Pauri Garhwal',
'Pithoragarh', 'Rudraprayag', 'Tehri Garhwal', 'Udham Singh Nagar', 'Uttarkashi',
],
'West Bengal': [
'Alipurduar', 'Bankura', 'Birbhum', 'Cooch Behar', 'Dakshin Dinajpur', 'Darjeeling', 'Hooghly', 'Howrah',
'Jalpaiguri', 'Kolkata', 'Malda', 'Murshidabad', 'Nadia', 'North 24 Parganas', 'Paschim Bardhaman',
'Paschim Medinipur', 'Purba Bardhaman', 'Purba Medinipur', 'South 24 Parganas', 'Uttar Dinajpur',
],
};


const Map<String,List<String>> jobCategories = {
 'Other':['Other'],

 "Skilled Trades": [
  "Electrician",
  "Plumber",
  "HVAC Technician",
  "Welder",
  "Carpenter"
 ],
 "Education & Training": [
  "Teacher",
  "Professor",
  "School Counselor",
  "Tutor",
  "Instructional Designer"
 ],
 "Transportation & Logistics": [
  "Truck Driver",
  "Logistics Coordinator",
  "Delivery Driver",
  "Supply Chain Analyst",
  "Fleet Manager"
 ],

 "Construction & Architecture": [
  "Architect",
  "Civil Engineer",
  "Construction Manager",
  "Surveyor",
  'worker',
  "Heavy Equipment Operator"
 ],
 "Hospitality & Food Service": [
  "Chef",
  "Waiter/Waitress",
  "Hotel Manager",
  "Barista",
  "Housekeeper"
 ],
 "Agriculture & Environment": [
  "Farmer",
  "Agricultural Technician",
  "Environmental Scientist",
  "Forester",
  "Conservation Officer"
 ],

 "Manufacturing & Production": [
  "Factory Worker",
  "Production Manager",
  "Assembler",
  "Machine Operator"
 ],


 "Real Estate & Property Management": [
  "Real Estate Agent",
  "Property Manager",
  "Leasing Consultant",
  "Appraiser",
  "Building Superintendent"
 ],

 "Beauty & Personal Care": [
  "Hair Stylist",
  "Barber",
  "Makeup Artist",
  "Esthetician",
  "Nail Technician"
 ],
 "Fitness & Recreation": [
  "Personal Trainer",
  "Fitness Instructor",
  "Recreation Coordinator",
  "Coach",
  "Yoga Instructor"
 ],
};




//
//
// const Map<String,List<String>> job_categories = {
// "Skilled Trades": [
// "Electrician",
// "Plumber",
// "HVAC Technician",
// "Welder",
// "Carpenter"
// ],
// "Business & Administration": [
// "Office Manager",
// "Executive Assistant",
// "Administrative Coordinator",
// "Operations Manager",
// "Clerk"
// ],
// "Information Technology (IT)": [
// "Software Developer",
// "Data Analyst",
// "System Administrator",
// "Cybersecurity Specialist",
// "IT Support Technician"
// ],
// "Healthcare & Medical": [
// "Doctor",
// "Nurse",
// "Pharmacist",
// "Medical Assistant",
// "Physical Therapist"
// ],
// "Education & Training": [
// "Teacher",
// "Professor",
// "School Counselor",
// "Tutor",
// "Instructional Designer"
// ],
// "Arts, Media & Design": [
// "Graphic Designer",
// "Photographer",
// "Video Editor",
// "Illustrator",
// "UX/UI Designer"
// ],
// "Transportation & Logistics": [
// "Truck Driver",
// "Logistics Coordinator",
// "Delivery Driver",
// "Supply Chain Analyst",
// "Fleet Manager"
// ],
// "Construction & Architecture": [
// "Architect",
// "Civil Engineer",
// "Construction Manager",
// "Surveyor",
// "Heavy Equipment Operator"
// ],
// "Sales & Customer Service": [
// "Sales Representative",
// "Retail Associate",
// "Customer Service Agent",
// "Account Manager",
// "Call Center Specialist"
// ],
// "Hospitality & Food Service": [
// "Chef",
// "Waiter/Waitress",
// "Hotel Manager",
// "Barista",
// "Housekeeper"
// ],
// "Agriculture & Environment": [
// "Farmer",
// "Agricultural Technician",
// "Environmental Scientist",
// "Forester",
// "Conservation Officer"
// ],
// "Public Safety & Law": [
// "Police Officer",
// "Firefighter",
// "Security Guard",
// "Lawyer",
// "Paralegal"
// ],
// "Science & Research": [
// "Research Scientist",
// "Lab Technician",
// "Biologist",
// "Chemist",
// "Clinical Research Associate"
// ],
// "Manufacturing & Production": [
// "Factory Worker",
// "Production Manager",
// "Assembler",
// "Quality Control Inspector",
// "Machine Operator"
// ],
// "Finance & Accounting": [
// "Accountant",
// "Financial Analyst",
// "Auditor",
// "Bookkeeper",
// "Payroll Specialist"
// ],
// "Engineering": [
// "Mechanical Engineer",
// "Electrical Engineer",
// "Civil Engineer",
// "Software Engineer",
// "Industrial Engineer"
// ],
// "Legal Services": [
// "Lawyer",
// "Legal Assistant",
// "Paralegal",
// "Court Clerk",
// "Legal Analyst"
// ],
// "Human Resources (HR)": [
// "HR Manager",
// "Recruiter",
// "Training Coordinator",
// "HR Assistant",
// "Compensation & Benefits Analyst"
// ],
// "Marketing & Advertising": [
// "Marketing Manager",
// "Content Strategist",
// "SEO Specialist",
// "Social Media Manager",
// "Brand Manager"
// ],
// "Nonprofit & Social Services": [
// "Social Worker",
// "Case Manager",
// "Community Outreach Coordinator",
// "Program Manager",
// "Grant Writer"
// ],
// "Real Estate & Property Management": [
// "Real Estate Agent",
// "Property Manager",
// "Leasing Consultant",
// "Appraiser",
// "Building Superintendent"
// ],
// "Telecommunications": [
// "Network Technician",
// "Telecom Engineer",
// "Field Service Technician",
// "Support Specialist",
// "Installer"
// ],
// "Entertainment & Performing Arts": [
// "Actor",
// "Musician",
// "Director",
// "Producer",
// "Stage Manager"
// ],
// "Aerospace & Aviation": [
// "Pilot",
// "Aerospace Engineer",
// "Aircraft Mechanic",
// "Air Traffic Controller",
// "Flight Attendant"
// ],
// "Energy & Utilities": [
// "Electric Utility Technician",
// "Energy Analyst",
// "Power Plant Operator",
// "Renewable Energy Engineer",
// "Gas Technician"
// ],
// "Military & Defense": [
// "Soldier",
// "Intelligence Analyst",
// "Military Police",
// "Defense Contractor",
// "Aircraft Technician"
// ],
// "E-commerce & Online Business": [
// "E-commerce Manager",
// "Product Lister",
// "Digital Storefront Designer",
// "Customer Experience Specialist",
// "Online Sales Analyst"
// ],
// "Beauty & Personal Care": [
// "Hair Stylist",
// "Barber",
// "Makeup Artist",
// "Esthetician",
// "Nail Technician"
// ],
// "Fitness & Recreation": [
// "Personal Trainer",
// "Fitness Instructor",
// "Recreation Coordinator",
// "Coach",
// "Yoga Instructor"
// ],
// "Translation & Language Services": [
// "Translator",
// "Interpreter",
// "Localization Specialist",
// "Language Teacher",
// "Subtitler"
// ]
// }



final List<String> postImages = List.generate(
 12,
     (index) => "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fHww+${index + 1}",
);
List<String> videos = [
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
 "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"
];
