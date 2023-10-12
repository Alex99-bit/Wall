// Clase transform, de aqui adquieren sus valores
class Transform{
  float x,y;
  float scaleX,scaleY;
  float radio;
  
  Transform(){
    x = 0;
    y = 0;
    scaleX = 0;
    scaleY = 0;
    radio = 0;
  }
}

// Clase muro
class Muro extends Transform{
  int r,g,b;
  
  Muro(){
    x = width/2;
    y = height/2;
    scaleX = 50;
    scaleY = 150;
    
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
  }
  
  Muro(float x,float y,float ancho,float largo){
    this.x = x;
    this.y = y;
    scaleX = ancho;
    scaleY = largo;
  }
  
  void Draw(){
    fill(r,g,b);
    rect(x,y,scaleX,scaleY);
  }
}

// Clase collider, que verifica distintos tipos de colisiones
class Collider{
  float deltaX, deltaY;
  float cuadrado, raiz;
  boolean chocaX, chocaY;
  
  Collider(){
    chocaX = false;
    chocaY = false;
  }
  
  float CollisionBalls(Transform obj1,Transform obj2){
    deltaX = obj1.x + obj2.x;
    deltaY = obj1.y + obj2.y;
    cuadrado = (deltaX*deltaX) + (deltaY*deltaY);
    raiz = sqrt(cuadrado);
    
    return raiz;
  }
  
  boolean CollisionBWall(Transform ball,Transform wall){
    // Calcula los bordes del objeto
    float left = ball.x;
    float right = ball.x + ball.radio/2;
    float top = ball.y;
    float bottom = ball.y + ball.radio/2;
  
    // Calcula los bordes del muro
    float wallLeft = wall.x;
    float wallRight = wall.x + wall.scaleX;
    float wallTop = wall.y;
    float wallBottom = wall.y + wall.scaleY;
  
    // Verifica la colisión
    if (right > wallLeft && left < wallRight && bottom > wallTop && top < wallBottom) {
      // Colisión detectada, cambia la dirección del movimiento
      /*velX *= -1;
      velY *= -1;*/
      chocaX = true;
      chocaY = true;
    }
    
    return chocaX;
  }
  
  boolean CollisionBScreenX(Transform ball){
    if(ball.x+ball.radio/2 >= width || ball.x-ball.radio/2 <= 0){
      chocaX = true;
    }
    
    return chocaX;
  }
  
  boolean CollisionBScreenY(Transform ball){
    if(ball.y+ball.radio/2 >= height || ball.y-ball.radio/2 <= 0){
      chocaY = true;
    }
    
    return chocaY;
  }
}

// Clase ball
class Ball extends Transform{
  Collider colision;
  
  int r,g,b;
  float velX, velY;
  
  Ball(float velx,float vely,float radio){
    colision = new Collider();
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
    
    velX = velx;
    velY = vely;
    
    x = random(width);
    y = random(height);
    this.radio = radio;
  }
  
  void Dibuja(){
    fill(r,g,b);
    circle(x,y,radio);
  }
  
  void Mueve(){
    if(colision.CollisionBScreenX(this)){
      velX *= -1;
      colision.chocaX = false;
    }
    
    if(colision.CollisionBScreenY(this)){
      velY *= -1;
      colision.chocaY = false;
    }
    
    x+=velX;
    y+=velY;
  }
  
  void MoveWall(Transform wall){
    if(colision.CollisionBWall(this,wall)){
      velX *= -1;
      velY *= -1;
      
      colision.chocaX = false;
      colision.chocaY = false;
    }
  }
}

//Ball test = new Ball(15,15,50);
Muro wall = new Muro(1600/2,200,60,400);
Collider colGlobal = new Collider();

ArrayList<Ball> pelotas = new ArrayList<Ball>();

void setup(){
  size(1600,800);
  int n = 10;
  for(int i=0;i<n;i++){
    pelotas.add(new Ball(random(5,20),random(5,20),random(20,50)));
  }
}

void draw(){
  background(200);
  
  //frameRate(24);
  
  wall.Draw();
  
  for(int i=0;i<pelotas.size();i++){
    pelotas.get(i).Dibuja();
    pelotas.get(i).Mueve();
    pelotas.get(i).MoveWall(wall);
    
    for(int j=i;j<pelotas.size();j++){
      if(colGlobal.CollisionBalls(pelotas.get(i),pelotas.get(j)) < (pelotas.get(i).radio/2)+(pelotas.get(j).radio/2)){
        pelotas.get(i).velX *= -1;
        pelotas.get(i).velY *= -1;
        
        pelotas.get(j).velX *= -1;
        pelotas.get(j).velY *= -1;
        
        print(" Entra ");
      }
    }
  }
  
  /*test.Dibuja();
  test.Mueve();
  test.MoveWall(wall);*/
  
}
