import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  runApp(ChangeNotifierProvider(
    create: (_) => ColorSelector(),
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Instagrom',
            theme: notifier.darkMode ? darkMode : lightMode,
            initialRoute: '/',
            routes: {
              '/': (context) => MyHomePage(title: 'Instagrom'),
              '/img': (context) => OpenedImage(),
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  int index = 0;

  void changeTitle(){
    setState(() {
      widget.title = 'title ' + index.toString();
      index += 1;
    });
  }

  void _buttonAction(){
    Provider.of<ColorSelector>(context, listen: false).changeColor();
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
  }

  void _fetch(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => FutureWidgetPage())).then((themeName) => widget.title = themeName);
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
                      child: Consumer<ColorSelector>(
                        builder: (context, colorSelector, child) =>
                          Text(
                            'Post ' + (i+1).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorSelector.cur_color
                            )
                          ),
                        )
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  return_tag = i;
                  Navigator.pushNamed(context, '/img', arguments: changeTitle);
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
            children: <Widget>[
              ElevatedButton(onPressed: _fetch, child: const Text('Fetch'))
            ] + posts,
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
  late void Function() changer;

  @override
  Widget build(BuildContext context) {
    changer = ModalRoute.of(context)?.settings.arguments as void Function();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture'),
      ),
      body: Hero(
        tag: (return_tag+1).toString(),
        child: Image.network(images[return_tag]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: changer,
        tooltip: 'Change',
        child: const Icon(Icons.restore),
      ),
    );
  }
}

class ColorSelector extends ChangeNotifier{
  Color color = Colors.black;

  void changeColor(){
    color = Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1.0);
    notifyListeners();
  }

  Color get cur_color => color;
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
);

class ThemeNotifier extends ChangeNotifier {
  String key = "theme";
  late SharedPreferences _preferences;
  bool _darkMode = true;

  bool get darkMode => _darkMode;

  ThemeNotifier(){
    _loadPreferences();
  }

  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _getPreferences();
    _preferences.setBool(key, _darkMode);
  }

  _loadPreferences() async {
    await _getPreferences();
    _darkMode = _preferences.getBool(key) ?? true;
    notifyListeners();
  }

  toggleTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}

class Page {
  final String title;
  final String text;

  Page({
    required this.title,
    required this.text
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      title: json['query']['pages'].values.first['title'],
      text: json['query']['pages'].values.first['extract']
    );
  }
}

Future<Page> fetchPage() async {
  final response = await http.get(Uri.parse('https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&prop=extracts&exchars=500&format=json'));

  if (response.statusCode == 200) {
    return Page.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error on request!');
  }
}

class FutureWidgetPage extends StatefulWidget {
  FutureWidgetPage();

  @override
  _FutureWidgetPageState createState() => _FutureWidgetPageState();
}

class _FutureWidgetPageState extends State<FutureWidgetPage> with SingleTickerProviderStateMixin {
  late Future<Page> futurePage;

  late AnimationController animController;
  late List<Animation> animSize;
  late List<Animation> animColor;

  @override
  void initState() {
    super.initState();
    futurePage = fetchPage();

    animController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animSize = List.generate(10, (i) =>
      Tween<double>(
        begin: 10,
        end: (i * 40) / ((i % 2) + 1))
          .animate(animController));
    animColor = List.generate(10, (i) => 
      ColorTween(
        begin: const Color.fromRGBO(0, 150, 0, 1),
        end: Color.fromRGBO(0, 255~/(i+1),  255~/(i+1), 1))
          .animate(animController)
            ..addStatusListener((status) {}));

    animController.addListener(() {setState(() {});});
    animController.forward();
    animController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Http request to wikipedia',
            theme: notifier._darkMode ? darkMode : lightMode,
            home: Scaffold(
              appBar:
                  AppBar(title: const Text('Http request to wikipedia'), actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    String theme = notifier._darkMode ? 'Dark Theme' : 'Light Theme';
                    Navigator.pop(context, theme);
                  },
                ),
              ]),
              body: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(10, (i) => Container(
                      height: 20,
                      width: animSize[i].value,
                      color: animColor[i].value,
                    )),
                  ),              
                  Center(
                    child: FutureBuilder<Page>(
                      future: futurePage,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.title + "\n\n" + snapshot.data!.text);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  )])
            ),
          );
        }
      )
    );
  }
}