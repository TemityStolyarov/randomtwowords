//import 'dart:html';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

String upperfirst(String text) {
  if (text.isEmpty) return text;
  return '${text[0].toUpperCase()}${text.substring(1)}';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // Переназначает пару слов
  void getNext() {
    current = WordPair.random();
    /* notifyListeners() - один из
    методов ChangeNotifier, который
    уведомляет все элементы .watch об
    изменении состояния переменной */
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

/*
class MyHomePage extends StatelessWidget {
  @override
  // 1 - Автоматически вызывается каждый раз,
  // когда обстоятельства виджета сменяются,
  // следовательно, виджет всегда обновляется.
  // Такой метод есть у каждого виджета
  Widget build(BuildContext context) {
    // 2 - Класс MyHomePage через метод .watch
    // отслеживает текущее состояние
    // приложения
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData favIcon;
    if (appState.favorites.contains(pair)) {
      favIcon = Icons.favorite;
    } else {
      favIcon = Icons.favorite_border;
    }
    // 3 - виджет верхнего уровня для вложенного
    // дерева виджетов называется 'Scaffold'
    return Scaffold(
      // 4 - помещающий все дочерние элементы
      // в себя сверху вниз виджет называется
      // 'Column'
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 6 - appState - текущее состояние
            // приложения; current - переменная
            // (на данный момент является склеенной
            // парой слов WordPair.random() );
            // asLowerCase - формат вывода данных
            // в строке - в данном случае, все
            // буквы будут преобразованы в
            // строчный формат (из загланых)
            TextCard(pair: pair),
            SizedBox(
              height: 10,
            ),
            // 'Next' button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(favIcon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    /* Обращается к переменной
                    appState, отслеживающей состояние
                    приложения, и запрашивает выполнение
                    метода .getNext(); */
                    appState.getNext();
                  },
                  child: Text('Gen'), // child - ребенок
                ),
              ],
            ),
          ],
          // 7 - Эта ^ запятая не обязательно
          // должна быть здесь, потому что
          // указанный в [] виджет -
          // единственный элемент этого
          // (конкретно взятого) Column
          // списка параметров.
          //
          // Конечные запятые, тем не менее,
          // упрощают добавление новых
          // элементов и упрощают форматирование
          // кода
        ),
      ),
    );
  }
}

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: MyHomePage(),
            ),
          ),
        ],
      ),
    );
  }
}

*/
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favs'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Gen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favs yet'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favs:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

// Класс возник после того, как мы извлекли
// текст в виджет
class TextCard extends StatelessWidget {
  // Конструктор
  const TextCard({
    //
    Key? key,
    // Обязательное поле класса StatelessWidget, содержащее
    // значение переменной pair, объявленной
    // в классе выше (myHomePage), переданной через
    // локальную переменную класса
    required this.pair,
  }) : super(key: key);

  // Хранит в себе pair, полученное из
  // класса WordPair
  final WordPair pair;

  @override
  // Перезаписывает метод build()
  // на возвращение нашего текста
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    // Обернем текс с помощью Padding
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          upperfirst(pair.toString()),
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
