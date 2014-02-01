import 'package:breakout/breakout.dart';

import 'dart:html';

start() {
  init();
  // redraw
  window.animationFrame.then(gameLoop);
}

gameLoop(num delta) {
  if (draw()) {
    window.animationFrame.then(gameLoop);
  }
}

bool draw() {
  clear();
  ball.draw();
  racket.draw();
  if (!drawBricks()) return false; // user wins

  // have we hit a brick?
  // to learn about real collision detection:
  // http://www.metanetsoftware.com/
  var rowHeight = BRICK_HEIGHT + PADDING;
  var colWidth = brickw + PADDING;
  int row = (ball.y / rowHeight).floor();
  int col = (ball.x / colWidth).floor();
  if (row < NROWS && col < NCOLS && row >= 0 && col >= 0 &&
      ball.y < NROWS * rowHeight && bricks[row][col] == 1) {
    // if so, reverse the ball and mark the brick as broken
    dy = -dy;
    bricks[row][col] = 0;
  }

  // move the racket if left or right is currently pressed
  if (racket.rightDown) racket.x += 5;
  else if (racket.leftDown) racket.x -= 5;

  if (ball.x + dx + Ball.RADIUS > canvas.width ||
      ball.x + dx - Ball.RADIUS < 0) dx = -dx;

  if (ball.y + dy - Ball.RADIUS < 0) dy = -dy;
  else if (ball.y + dy + Ball.RADIUS > canvas.height - Racket.HIGHT) {
    if (ball.x > racket.x && ball.x < racket.x + Racket.WIDTH) {
      // move the ball differently based on where it hits the racket
      dx = 8 * ((ball.x- (racket.x + Racket.WIDTH / 2)) / Racket.WIDTH);
      dy = -dy;
    } else if (ball.y + dy + Ball.RADIUS > canvas.height) return false;
  }

  ball.x += dx;
  ball.y += dy;
  return true;
}

main() {
  start();
}


