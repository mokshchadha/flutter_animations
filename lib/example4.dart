import 'package:flutter/material.dart';

class Person {
  final String name;
  final num age;
  final String emoji;
  Person({required this.name, required this.age, required this.emoji});
}

final persons = [
  Person(age: 21, name: 'John', emoji: '🙋🏻‍♂️'),
  Person(age: 21, name: 'Jane', emoji: '👩🏼‍🦱'),
  Person(age: 21, name: 'Jack', emoji: '👨🏿'),
];

class ButtonToExample4 extends StatelessWidget {
  const ButtonToExample4({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FirstScreen()),
        );
      },
      child: const Text('Go to Example 3'),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Screen')),
      body: ListView(
        children: [
          ...persons.map(
            (e) => ListTile(
              leading: Hero(tag: e.name, child: Text(e.emoji)),
              title: Text(e.name),
              subtitle: Text('age ${e.age} years'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedScreen(person: e),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailedScreen extends StatelessWidget {
  final Person person;
  const DetailedScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: person.name,
          flightShuttleBuilder:
              (
                flightContext,
                animation,
                flightDirection,
                fromHeroContext,
                toHeroContext,
              ) {
                switch (flightDirection) {
                  case HeroFlightDirection.push:
                    return Material(
                      color: Colors.transparent,
                      child: fromHeroContext.widget,
                    );
                  case HeroFlightDirection.pop:
                    return Material(
                      color: Colors.transparent,
                      child: toHeroContext.widget,
                    );
                }
              },
          child: Text(person.emoji),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(person.name, textAlign: TextAlign.center),
            Text('${person.age} years old'),
          ],
        ),
      ),
    );
  }
}
