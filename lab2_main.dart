import 'package:flutter/material.dart';

const images = [
  'https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80',
  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
  'https://cdn.pixabay.com/photo/2017/02/08/17/24/fantasy-2049567__480.jpg',
  'https://media.istockphoto.com/photos/saint-andrew-church-and-podil-in-kiev-ukraine-picture-id1217267081?b=1&k=20&m=1217267081&s=170667a&w=0&h=2FyCMZzG_q8fGmhIZFlbJF6mYjf20Q7ATPfEF5Xggyo=',
  'https://upload.wikimedia.org/wikipedia/commons/4/4a/100x100_black_and_white_pixels.png'
];

const Map<int, Color> color =
{
50:Color.fromRGBO(255, 220, 128, .1),
100:Color.fromRGBO(255, 220, 128, .2),
200:Color.fromRGBO(255, 220, 128, .3),
300:Color.fromRGBO(255, 220, 128, .4),
400:Color.fromRGBO(255, 220, 128, .5),
500:Color.fromRGBO(255, 220, 128, .6),
600:Color.fromRGBO(255, 220, 128, .7),
700:Color.fromRGBO(255, 220, 128, .8),
800:Color.fromRGBO(255, 220, 128, .9),
900:Color.fromRGBO(255, 220, 128, 1),
};

MaterialColor colorCustom = MaterialColor(color[900]!.value, color);

var return_tag;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagrom',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const MyHomePage(title: 'Instagrom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  void _dismissDialog(){
    Navigator.pop(context);
  }

  void _buttonAction(){
    showDialog(context: context,
    builder: (context) {
          return AlertDialog(
            title: const Text('Test Dialog'),
            content: const Text('This is a dialog message.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: const Text('Close')),
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: const Text('Also, close'),
              ),
            ],
          );
        });
  }

  int _currIndex = 0;

  var tabs;

  var controller;

  @override
  void initState() {
    super.initState();

    var posts = <Widget>[];
    for (var i = 0; i < 5; i++) {
      posts.add(
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          color: const Color.fromRGBO(100, 20, 20, 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.person),
                    Expanded(
                      child: Text('Post ' + (i+1).toString(), textAlign: TextAlign.center),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  return_tag = i;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OpenedImage()));
                },
                child: Hero(
                  tag: (i+1).toString(),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ]
                    ),
                    child: Image.network(images[i]),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.comment),
                    Icon(Icons.send),
                  ],
                ),
              )
            ],
          ),
        )
      );
    }
    
    tabs = [
      ListView(
        children: [
          Column(
            children: posts,
          ),
        ],
      ),
      ListView(
        children: [
          Column(
            children: List.from(posts.reversed),
          ),
        ],
      ),
    ];
    controller = TabController(length: tabs.length, vsync: this);
    controller.addListener(() {
      setState(() {
        _currIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TabBarView(
        children: tabs,
        controller: controller,
      ),
      drawer: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Hello from drawer!', style: TextStyle(color: Colors.red, backgroundColor: Colors.blueGrey, fontSize: 36)),
          Image.network(images[1]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buttonAction,
        tooltip: 'Dialog',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        selectedItemColor: color[900],
        onTap: (index) {
          setState(() {
            _currIndex = index;
            controller.animateTo(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: const Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: const Icon(Icons.person_pin_circle),
          ),
        ],
      ),
    );
  }
}

class OpenedImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Hero(
        tag: (return_tag+1).toString(),
        child: Image.network(images[return_tag]),
      ),
    );
  }
}