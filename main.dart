import 'package:flutter/material.dart';

void main() => runApp(const GujaratWheelsApp());

class Vehicle {
  final String id, title, category, city, price, image, seller;
  final int year;
  final bool featured;
  const Vehicle({
    required this.id, required this.title, required this.category,
    required this.city, required this.price, required this.image,
    required this.seller, required this.year, this.featured=false,
  });
}

const vehicles = [
  Vehicle(id:'1', title:'Mahindra Scorpio S11', category:'Cars', city:'Rajpipla', price:'₹ 12,50,000', image:'🚙', seller:'Amit', year:2021, featured:true),
  Vehicle(id:'2', title:'Massey Ferguson 7250 DI', category:'Tractors', city:'Narmada', price:'₹ 7,25,000', image:'🚜', seller:'Ramesh', year:2022, featured:true),
  Vehicle(id:'3', title:'Tata Ace Gold', category:'Commercial', city:'Bharuch', price:'₹ 4,10,000', image:'🚚', seller:'Ketan', year:2020),
  Vehicle(id:'4', title:'Hero Splendor Plus', category:'Bikes', city:'Vadodara', price:'₹ 52,000', image:'🏍️', seller:'Suresh', year:2022),
];

class GujaratWheelsApp extends StatefulWidget {
  const GujaratWheelsApp({super.key});
  @override State<GujaratWheelsApp> createState() => _GujaratWheelsAppState();
}

class _GujaratWheelsAppState extends State<GujaratWheelsApp> {
  int tab = 0;
  bool gujarati = true;
  @override Widget build(BuildContext context) {
    final pages = [
      HomePage(gujarati: gujarati, onLanguage: ()=>setState(()=>gujarati=!gujarati), onCategory:(c){setState(()=>tab=1); Navigator.of(context).push(MaterialPageRoute(builder:(_)=>ListingsPage(category:c, gujarati:gujarati)));}),
      ListingsPage(gujarati:gujarati),
      SellPage(gujarati:gujarati),
      MyAdsPage(gujarati:gujarati),
      ProfilePage(gujarati:gujarati),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:'GujaratWheels',
      theme:ThemeData(colorSchemeSeed:Colors.orange, useMaterial3:true),
      home:Scaffold(
        body:SafeArea(child:pages[tab]),
        bottomNavigationBar:NavigationBar(
          selectedIndex:tab,
          onDestinationSelected:(i)=>setState(()=>tab=i),
          destinations:[
            NavigationDestination(icon:Icon(Icons.home_outlined), selectedIcon:Icon(Icons.home), label:gujarati?'હોમ':'Home'),
            NavigationDestination(icon:Icon(Icons.directions_car_outlined), selectedIcon:Icon(Icons.directions_car), label:gujarati?'વાહનો':'Vehicles'),
            NavigationDestination(icon:Icon(Icons.add_circle_outline), selectedIcon:Icon(Icons.add_circle), label:gujarati?'વેચો':'Sell'),
            NavigationDestination(icon:Icon(Icons.list_alt), label:gujarati?'મારી Ads':'My Ads'),
            NavigationDestination(icon:Icon(Icons.person_outline), selectedIcon:Icon(Icons.person), label:gujarati?'પ્રોફાઇલ':'Profile'),
          ],
        ),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final String title; final bool gujarati; final VoidCallback? onLanguage;
  const AppHeader({super.key,required this.title,required this.gujarati,this.onLanguage});
  @override Widget build(BuildContext context)=>Padding(
    padding:const EdgeInsets.fromLTRB(20,18,20,10),
    child:Row(children:[
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(title,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
        const Text('Buy • Sell • Drive'),
      ])),
      if(onLanguage!=null) OutlinedButton(onPressed:onLanguage, child:Text(gujarati?'EN':'ગુ'))
    ]),
  );
}

class HomePage extends StatelessWidget {
  final bool gujarati; final VoidCallback onLanguage; final void Function(String) onCategory;
  const HomePage({super.key,required this.gujarati,required this.onLanguage,required this.onCategory});
  @override Widget build(BuildContext context)=>SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    AppHeader(title:'GujaratWheels',gujarati:gujarati,onLanguage:onLanguage),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:SearchBar(
      leading:const Icon(Icons.search),
      hintText:gujarati?'Car, Tractor અથવા Brand શોધો':'Search car, tractor or brand',
    )),
    Padding(padding:const EdgeInsets.fromLTRB(20,18,20,8),child:Text(gujarati?'વાહન પસંદ કરો':'Browse Categories',style:Theme.of(context).textTheme.titleLarge)),
    GridView.count(
      crossAxisCount:2, shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), childAspectRatio:1.9,
      padding:const EdgeInsets.symmetric(horizontal:20),
      children:[
        CategoryCard(icon:'🚗',title:gujarati?'કાર':'Cars',onTap:()=>onCategory('Cars')),
        CategoryCard(icon:'🚜',title:gujarati?'ટ્રેક્ટર':'Tractors',onTap:()=>onCategory('Tractors')),
        CategoryCard(icon:'🚚',title:gujarati?'કોમર્શિયલ':'Commercial',onTap:()=>onCategory('Commercial')),
        CategoryCard(icon:'🏍️',title:gujarati?'બાઈક':'Bikes',onTap:()=>onCategory('Bikes')),
      ],
    ),
    Padding(padding:const EdgeInsets.fromLTRB(20,16,20,8),child:Text(gujarati?'Featured વાહનો':'Featured Vehicles',style:Theme.of(context).textTheme.titleLarge)),
    ...vehicles.where((v)=>v.featured).map((v)=>VehicleCard(v:v,gujarati:gujarati)),
    const SizedBox(height:20)
  ]));
}

class CategoryCard extends StatelessWidget {
  final String icon,title; final VoidCallback onTap;
  const CategoryCard({super.key,required this.icon,required this.title,required this.onTap});
  @override Widget build(BuildContext context)=>Card(child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(12),child:Padding(padding:const EdgeInsets.all(12),child:Row(children:[Text(icon,style:const TextStyle(fontSize:28)),const SizedBox(width:10),Expanded(child:Text(title,style:const TextStyle(fontWeight:FontWeight.bold)))]))));
}

class ListingsPage extends StatefulWidget {
  final bool gujarati; final String? category;
  const ListingsPage({super.key,required this.gujarati,this.category});
  @override State<ListingsPage> createState()=>_ListingsPageState();
}
class _ListingsPageState extends State<ListingsPage> {
  String? category;
  @override void initState(){super.initState();category=widget.category;}
  @override Widget build(BuildContext context){
    final list=category==null?vehicles:vehicles.where((v)=>v.category==category).toList();
    return Column(children:[
      AppHeader(title:category==null?(widget.gujarati?'વાહનો':'Vehicles'):category!,gujarati:widget.gujarati),
      Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:DropdownButtonFormField<String>(
        value:category, hint:Text(widget.gujarati?'બધી Category':'All Categories'),
        items:['Cars','Tractors','Commercial','Bikes'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
        onChanged:(v)=>setState(()=>category=v),
      )),
      Expanded(child:ListView(children:list.map((v)=>VehicleCard(v:v,gujarati:widget.gujarati)).toList()))
    ]);
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle v; final bool gujarati;
  const VehicleCard({super.key,required this.v,required this.gujarati});
  @override Widget build(BuildContext context)=>Card(
    margin:const EdgeInsets.fromLTRB(20,8,20,8),
    child:InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>VehicleDetails(v:v,gujarati:gujarati))),
      child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[
        Container(width:76,height:76,decoration:BoxDecoration(color:Colors.orange.withOpacity(.12),borderRadius:BorderRadius.circular(12)),child:Center(child:Text(v.image,style:const TextStyle(fontSize:42)))),
        const SizedBox(width:14),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(v.title,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:16)),
          const SizedBox(height:5),Text('${v.year} • ${v.city}'),const SizedBox(height:5),
          Text(v.price,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Colors.deepOrange))
        ])),
        const Icon(Icons.chevron_right)
      ]))
    )
  );
}

class VehicleDetails extends StatelessWidget {
  final Vehicle v; final bool gujarati;
  const VehicleDetails({super.key,required this.v,required this.gujarati});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:Text(v.title)),
    body:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Center(child:Text(v.image,style:const TextStyle(fontSize:110))),
      const SizedBox(height:10),Text(v.title,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
      Text(v.price,style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold,color:Colors.deepOrange)),
      const SizedBox(height:18),
      ListTile(leading:const Icon(Icons.calendar_today),title:Text('${v.year} Model')),
      ListTile(leading:const Icon(Icons.location_on),title:Text(v.city)),
      ListTile(leading:const Icon(Icons.person),title:Text('${gujarati?'Seller':'Seller'}: ${v.seller}')),
      const SizedBox(height:20),
      SizedBox(width:double.infinity,child:ElevatedButton.icon(onPressed:(){},icon:const Icon(Icons.phone),label:Text(gujarati?'Seller ને Call કરો':'Call Seller'))),
      const SizedBox(height:10),
      SizedBox(width:double.infinity,child:OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.chat),label:Text('WhatsApp Seller')))
    ]))
  );
}

class SellPage extends StatelessWidget {
  final bool gujarati; const SellPage({super.key,required this.gujarati});
  @override Widget build(BuildContext context)=>SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(gujarati?'તમારું વાહન વેચો':'Sell Your Vehicle',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
    const SizedBox(height:6),Text(gujarati?'ફોટા અને વિગતો ભરીને તમારી જાહેરાત મૂકો':'Post your ad with photos and details'),
    const SizedBox(height:20),
    ...[
      (gujarati?'Category':'Category',Icons.category),
      (gujarati?'Brand / Model':'Brand / Model',Icons.directions_car),
      (gujarati?'Year':'Year',Icons.calendar_today),
      (gujarati?'Price':'Price',Icons.currency_rupee),
      (gujarati?'Location':'Location',Icons.location_on),
      (gujarati?'Mobile Number':'Mobile Number',Icons.phone),
    ].map((x)=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(decoration:InputDecoration(labelText:x.$1,prefixIcon:Icon(x.$2),border:const OutlineInputBorder())))),
    OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.photo_camera),label:Text(gujarati?'Photos Upload કરો':'Upload Photos')),
    const SizedBox(height:16),
    SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>showDialog(context:context,builder:(_)=>AlertDialog(title:Text(gujarati?'Demo':'Demo'),content:Text(gujarati?'Supabase જોડ્યા પછી તમારી Ad સાચવાશે અને Admin Approval માટે જશે.':'After Supabase integration, your ad will be saved and sent for admin approval.'))),child:Text(gujarati?'Ad Submit કરો':'Submit Ad')))
  ]));
}

class MyAdsPage extends StatelessWidget {
  final bool gujarati; const MyAdsPage({super.key,required this.gujarati});
  @override Widget build(BuildContext context)=>Column(children:[
    AppHeader(title:gujarati?'મારી જાહેરાતો':'My Ads',gujarati:gujarati),
    Expanded(child:Center(child:Column(mainAxisSize:MainAxisSize.min,children:[
      const Icon(Icons.list_alt,size:72),const SizedBox(height:12),
      Text(gujarati?'Login કર્યા પછી તમારી Ads અહીં દેખાશે':'Your listings will appear here after login')
    ])))
  ]);
}

class ProfilePage extends StatelessWidget {
  final bool gujarati; const ProfilePage({super.key,required this.gujarati});
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),children:[
    const CircleAvatar(radius:42,child:Icon(Icons.person,size:42)),
    const SizedBox(height:12),Center(child:Text(gujarati?'Guest User':'Guest User',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold))),
    const SizedBox(height:25),
    ListTile(leading:const Icon(Icons.login),title:Text(gujarati?'Mobile Login / OTP':'Mobile Login / OTP'),onTap:()=>showModalBottomSheet(context:context,builder:(_)=>Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[Text(gujarati?'Mobile Number દાખલ કરો':'Enter Mobile Number',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const SizedBox(height:12),const TextField(keyboardType:TextInputType.phone,decoration:InputDecoration(prefixText:'+91 ',border:OutlineInputBorder())),const SizedBox(height:12),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:(){},child:Text(gujarati?'OTP મોકલો':'Send OTP')))]))),
    ListTile(leading:const Icon(Icons.favorite_border),title:Text(gujarati?'Saved Vehicles':'Saved Vehicles')),
    ListTile(leading:const Icon(Icons.support_agent),title:Text(gujarati?'Help & Support':'Help & Support')),
    const Divider(),
    const Text('GujaratWheels v1.0.0',textAlign:TextAlign.center)
  ]);
}
