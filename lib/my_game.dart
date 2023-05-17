import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:figuras_flame/figures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juego_flame/tap_button.dart';
import 'my_game.dart';


import 'drag_component.dart';
import 'flower_player.dart';

class MyGame extends FlameGame with KeyboardEvents {
  final sizeOfPlayer = Vector2(80, 180);
  int puntaje=0;
  int score=0;
  double vel=.5;
  double GenerarFigura=3;
  double TiempoGenerarFigura=0;
  int vidas=3;
  late final FlowerPlayer player;
  late final JoystickComponent joystick;

  

  // PARA ACTIVAR EL DEBUG
  @override
  bool get debugMode => true;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 200, 200, 200);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    children.register<Flower>();

    

    final image = await images.load('joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 120),
      position: Vector2(0, 0),
    );
    player = FlowerPlayer(
      position: Vector2(size.x / 2, size.y - sizeOfPlayer.y),
      paint: Paint()..color = Colors.pink,
      size: sizeOfPlayer,
      joystick: joystick,
    );
    await add(player);
    //await add(joystick);

    // await add(Flower(
    //   position: Vector2(size.x / 2, size.y - sizeOfPlayer.y),
    //   paint: Paint()..color = Colors.pink,
    //   size: sizeOfPlayer,
    // ));
    //await add(TapButton(moverDerecha)
    //  ..position = Vector2(size.x - 50, 75)
    //  ..size = Vector2(100, 100));
    //await add(TapButton(moverIzquierda)
    //  ..position = Vector2(50, 75)
    //  ..size = Vector2(100, 100));
    await add(DragComponent(moverIzquierda, moverDerecha)
      ..position = Vector2(0, size.y - 100)
      ..size = Vector2(size.x, 100));
  }

  @override
  void update(double dt) {
    if (children.isNotEmpty) {
      final Flower flower = children.query<Flower>().first;
      flower.position = Vector2(flower.position.x, size.y - sizeOfPlayer.y);
    }
    
    if(vidas>0){

    TiempoGenerarFigura+=dt;
    if(TiempoGenerarFigura>GenerarFigura){
      var RanPos=Random();
      var RanFig=Random();

      switch(RanFig.nextInt(5)){
        case 0:
          add(Mexico(position: Vector2(RanPos.nextDouble()*(size.x-140),-80), size: Vector2(140,80), paint: Paint()..color = Colors.green) );
          break;
        case 1:
          add(Pinguino(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.grey) );
          break;
        case 2:
          add(Caballito(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.brown) );
          break;
        case 3:
          add(Libreta(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.pink) );
          break;
        case 4:
          add(Elefante(position: Vector2(RanPos.nextDouble()*(size.x-120),-80), size: Vector2(120,80), paint: Paint()..color = Colors.blue) );
          break;
      }
      if(score%5==0){
      vel+=.2;
      GenerarFigura*=.9;
      }

      //add(Pinguino(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.pink) );
      TiempoGenerarFigura=0;
    }

    bool colMexico(FlowerPlayer player, Mexico figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

    bool colPinguino(FlowerPlayer player, Pinguino figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

    bool colCaballito(FlowerPlayer player, Caballito figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

    bool colStickman(FlowerPlayer player, Stickman figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

    bool colElefante(FlowerPlayer player, Elefante figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

    bool colLibreta(FlowerPlayer player, Libreta figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

    for(var text in children.query<TextComponent>()){
      children.remove(text);
    }
    add(TextComponent(
         priority: 100,
         text: score.toString(),
         position: Vector2(30, 30),
         size: Vector2(100, 50),
       ),);
    
    add(TextComponent(
         priority: 100,
         text: "Vidas:"+vidas.toString(),
         position: Vector2(30, 160),
         size: Vector2(100, 50),
       ));

    for (var figura in children.query<Mexico>()) {
      if (colMexico(player, figura)) {
        children.remove(figura);
        score += 1;
        print(score);
      } else {
        figura.y += vel;
        if (figura.y > size.y) {
          children.remove(figura);
          vidas--;
        }
      }
    }

    for (var figura in children.query<Pinguino>()) {
      if (colPinguino(player, figura)) {
        children.remove(figura);
        score += 1;
        print(score);
      } else {
        figura.y += vel;
        if (figura.y > size.y) {
          children.remove(figura);
          vidas--;
        }
      }
    }

    for (var figura in children.query<Caballito>()) {
      if (colCaballito(player, figura)) {
        children.remove(figura);
        score += 1;
        print(score);
      } else {
        figura.y += vel;
        if (figura.y > size.y) {
          children.remove(figura);
          vidas--;
        }
      }
    }

    for (var figura in children.query<Elefante>()) {
      if (colElefante(player, figura)) {
        children.remove(figura);
        score += 1;
        print(score);
      } else {
        figura.y += vel;
        if (figura.y > size.y) {
          children.remove(figura);
          vidas--;
        }
      }
    }

    for (var figura in children.query<Libreta>()) {
      if (colLibreta(player, figura)) {
        children.remove(figura);
        score += 1;
        print(score);
      } else {
        figura.y += vel;
        if (figura.y > size.y) {
          children.remove(figura);
          vidas--;
        }
      }
    }

    for (var figura in children.query<Stickman>()) {
      if (colStickman(player, figura)) {
        children.remove(figura);
        score += 1;
        print(score);
      } else {
        figura.y += vel;
        if (figura.y > size.y) {
          children.remove(figura);
          vidas--;
        }
      }
    }

    }
    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        moverIzquierda();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        moverDerecha();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void moverIzquierda() {
    final Flower flower = children.query<Flower>().first;
    flower.position.x -= 5;
    if (flower.position.x + flower.width < 0) {
      flower.position.x = size.x;
    }
  }

  void moverDerecha() {
    final Flower flower = children.query<Flower>().first;
    flower.position.x += 5;
    if (flower.position.x > size.x) {
      flower.position.x = -flower.size.x;
    }
  }
  
}