import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//fonte
PFont fonte;

//musicas
Minim audio;
AudioPlayer menuloop;
AudioPlayer play;
AudioPlayer batida;
AudioPlayer terminou;
AudioPlayer batidaplayer;
int bug = 1;

//images
PImage telamenu;
PImage telamapa;
PImage telacontrole;
PImage telacredito;
PImage placar;
PImage telaplayer1;
PImage telaplayer2;
PImage fantasma;
PImage muro;
PImage osso;
PImage bola1;
PImage bola2;
PImage bola3;
PImage bola4;


//telas 
int tempo = 0;
boolean menu = true;
boolean playing = false;
boolean gameover = false;
boolean instrucoes = false;
boolean creditos = false;

//players
float player1X = 30;
float player1Y = 250;
float player1largura= 10;
float player1altura = 50;

float player2X = 550;
float player2Y = 250;
float player2largura = 10;
float player2altura = 50;

//velocidade player
float velocidadeplayer = 4;

//inimigos
float inimX = 270;
float[] inimY = { 
  100, 200, 300, 400, 500
};

//comandos
boolean cimapressioando = false;
boolean baixopressioando = false;
boolean wpressioando = false;
boolean spressioando = false;

//score
int player1score = 0;
int player2score = 0;

//bola
float bolaX = 280;
float bolaY = 500;
float raio = 10;
float bolaDeltaX = -2;
float bolaDeltaY = 3;
int sprite = 1;

void setup() {
  size(600, 600);
  ellipseMode(CENTER);
  ellipseMode(RADIUS);

  //audio
  audio = new Minim(this);
  menuloop = audio.loadFile("loop.wav");
  menuloop.loop();
  fonte=loadFont ("CreepyCircus-72.vlw");
  textFont(fonte);
  stroke(255, 255, 255);

  //sprites
  telamenu = loadImage ("telamenu.png");
  telamapa = loadImage ("telamapa.png");
  telacredito = loadImage ("telacredito.png");
  telacontrole = loadImage ("telacontrole.png");
  telaplayer1 = loadImage ("telaplayer1.png");
  telaplayer2 = loadImage ("telaplayer2.png");
  muro = loadImage ("muro.png");
  fantasma = loadImage ("fantasma.png");
  placar = loadImage ("placar.png");
  osso = loadImage ("osso.png");
  bola1 = loadImage ("caveiran1.png");
  bola2 = loadImage ("caveiran2.png");
  bola3 = loadImage ("caveiran3.png");
  bola4 = loadImage ("caveiran4.png");

  batidaplayer = audio.loadFile ("batidaplayer.wav");
  batida = audio.loadFile ("batida.wav");
  terminou = audio.loadFile ("over.wav");
}

void keyPressed() {
  if (menu) {
    if (key == 'P' || key == 'p') {
      menu = false;
      playing = true;
      bug = 1;
      tempo = 0;
      play = audio. loadFile("musica.wav");
      play.loop();
      menuloop. pause();
    } else if (key == 'O' || key == 'o') {
      menu = false;
      instrucoes = true;
    } else if (key == 'C' || key == 'c') {
      menu = false;
      creditos = true;
    }
  } else if (creditos) {
    if (key == 'V' || key == 'v') {
      creditos = false;
      menu = true;
    }
  } else  if (instrucoes) {
    if (key == 'V' || key == 'v') {
      instrucoes = false;
      menu = true;
    }
  } else if (playing) {
    if (key == CODED) {
      if (keyCode == UP) {
        cimapressioando = true;
      } else if (keyCode == DOWN) {
        baixopressioando = true;
      }
    } else if (key == 'W' || key == 'w') {
      wpressioando = true;
    } else if (key == 'S' || key == 's') {
      spressioando = true;
    }
    if (key == 'V' || key == 'v') {
      playing = false;
      menu = true;
      play.pause();
      menuloop.loop();
    }
  } else if (gameover) {
    if (key == 'v') {
      gameover = false;
      menu = true;
      player1Y = 250;
      player2Y = 250;
      bolaX = 250;
      bolaY = 250;
      terminou.pause();
      menuloop.loop();


      bolaDeltaX = -3;
      bolaDeltaY = random(6) - 3;
      player1score = 0;
      player2score = 0;
    }
  }
}

void keyReleased() {
  if (playing) {
    if (key == CODED) {
      if (keyCode == UP) {
        cimapressioando = false;
      } else if (keyCode == DOWN) {
        baixopressioando = false;
      }
    } else if (key == 'W' || key == 'w') {
      wpressioando = false;
    } else if (key == 'S' || key == 's') {
      spressioando = false;
    }
  }
}

void draw() {
  tempo++;
  if (tempo % 6 == 0) sprite++;
  if (sprite == 5) sprite = 1;
  if (menu) {
    image (telamenu, 0, 0);
  } else if (instrucoes) {
    image (telacontrole, 0, 0);
  } else if (creditos) {
    image (telacredito, 0, 0);
  } else if (playing) {
    image (telamapa, 0, 0);

    if (tempo > 500) {
      for (int i = 0; i<5; i++) {
        image(fantasma, inimX, inimY[i]);
        if (bolaX > inimX && bolaX + 20 < inimX + 50 && bolaY > inimY[i]  && bolaY + 20 < inimY[i] + 50) bolaDeltaX *= -1;
      }
    }

    //player 2 (direita)
    if (cimapressioando) {
      if (player2Y-velocidadeplayer > 0) {
        player2Y -= velocidadeplayer;
      }
    }
    if (baixopressioando) {
      if (player2Y + velocidadeplayer + player1altura < height) {
        player2Y += velocidadeplayer;
      }
    }

    //player 1 (esquerda)
    if (wpressioando) {
      if (player1Y-velocidadeplayer > 0) {
        player1Y -= velocidadeplayer;
      }
    }
    if (spressioando) {
      if (player1Y + velocidadeplayer + player2altura < height) {
        player1Y += velocidadeplayer;
      }
    }

    float bolaesquerda = bolaX + bolaDeltaX;
    float boladireita = bolaX + (raio * 2) + bolaDeltaX;
    float bolacima = bolaY + bolaDeltaY;
    float bolabaixo = bolaY + (raio * 2) + bolaDeltaY;

    float player1direita = player1X + player1largura;
    float player1cima = player1Y;
    float player1baixo = player1Y + player1altura;

    float player2esquerda = player2X;
    float player2cima = player2Y;
    float player2baixo = player2Y + player2altura;

    //bola vs alto e baixo
    if (bolacima < 0 || bolabaixo > height) {
      bolaDeltaY *= -1;
      batida.rewind();
      batida.play();
    }

    //bola vs player 1
    if (bolaesquerda < player1direita) { 
      if (bolacima > player1baixo || bolabaixo < player1cima) {
        player2score ++;
        tempo = 0;

        if (player2score == 3) {
          playing = false;
          gameover = true;
        }
        bolaX = 280;
        bolaY = 250;
      } else {
        bolaDeltaX *= -1;
        batidaplayer.rewind();
        batidaplayer.play();
      }
    }

    //bola vs player 2
    if (boladireita > player2esquerda) {
      if (bolacima > player2baixo || bolabaixo < player2cima) {
        player1score ++;
        tempo = 0;

        if (player1score == 3) {
          playing = false;
          gameover = true;
        }
        bolaX = 280;
        bolaY = 250;
      } else {
        bolaDeltaX *= -1;
        batidaplayer.rewind();
        batidaplayer.play();
      }
    }
    if (tempo > 100) {
      bolaX += bolaDeltaX;
      bolaY += bolaDeltaY;
    }

    //placar
    image (placar, 220, 20);

    //linhas laterais
    image (muro, 0, 0);
    image (muro, 570, 0);

    //score
    textSize(36);
    text(player1score, 250, 57);
    text(player2score, 320, 57);

    //players
    image(osso, player1X, player1Y);
    image(osso, player2X, player2Y);

    //bola
    if (sprite == 1) image(bola1, bolaX, bolaY);
    if (sprite == 2) image(bola2, bolaX, bolaY);
    if (sprite == 3) image(bola3, bolaX, bolaY);
    if (sprite == 4) image(bola4, bolaX, bolaY);
  } else if (gameover) {
    background(0, 0, 0);

    textSize(72);
    if (player1score > player2score) {
      image (telaplayer1, 0, 0);
      if (bug == 1) {
        terminou.rewind();
        terminou.play();
        play.pause();
        menuloop.pause();
        bug = 2;
      }
    } else {
      image (telaplayer2, 0, 0);
      if (bug == 1) {
        terminou.rewind();
        terminou.play();
        play.pause();
        menuloop.pause();
        bug = 2;
      }
    }
  }
}

