part of breakout;

class Board {
  static const String white  = '#ffffff';
  static const String black  = '#000000';
  static const String yellow = '#ffff00';

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  num width, height;
  num speed = 1, dx = 2, dy = 4;

  Wall wall;
  Ball ball;
  Racket racket;

  Board(this.canvas) {
    context = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    clear();
    querySelector('#play').onClick.listen((e) {
      init();
    });
    SelectElement selectSpeed = querySelector('#speed');
    selectSpeed.value = '1';
    selectSpeed.onChange.listen((Event e) {
      var speed = selectSpeed.value;
      switch (speed) {
        case '1':
          dx = 2; dy = 4; break;
        case '2':
          dx = 3; dy = 6; break;
        case '3':
          dx = 4; dy = 8;
      }
    });
  }

  init() {
    wall = new Wall(this);
    ball = new Ball(this, white, yellow);
    racket = new Racket(this, white, black);
    // redraw
    window.animationFrame.then(gameLoop);
  }

  gameLoop(num delta) {
    if (draw()) {
      window.animationFrame.then(gameLoop);
    }
  }

  clear() {
    rectangle(context, 0, 0, width, height, black);
  }

  bool draw() {
    clear();
    ball.draw();
    racket.draw();
    if (!wall.draw()) return false; // user wins

    // If hit, reverse the ball.
    if (wall.hitBy(ball)) dy = -dy;

    // Move the racket if left or right is currently pressed.
    if (racket.rightDown) racket.x += 5;
    else if (racket.leftDown) racket.x -= 5;

    if (ball.x + dx + Ball.radius > width ||
        ball.x + dx - Ball.radius < 0) dx = -dx;

    if (ball.y + dy - Ball.radius < 0) dy = -dy;
    else if (ball.y + dy + Ball.radius > height - Racket.height) {
      if (ball.x > racket.x && ball.x < racket.x + Racket.width) {
        // Move the ball differently based on where it hits the racket.
        dx = 8 * ((ball.x- (racket.x + Racket.width / 2)) / Racket.width);
        dy = -dy;
      } else if (ball.y + dy + Ball.radius > height) return false;
    }

    ball.x += dx; ball.y += dy;
    return true;
  }
}